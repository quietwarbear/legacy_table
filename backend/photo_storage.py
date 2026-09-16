"""Recipe photo storage on the Railway bucket shared with voice keepsakes.

Recipe documents used to embed every photo as a base64 string in `photos`
(multi-MB each) — after PR #51 moved voice audio out, photos are the main
remaining driver of document bloat behind the 2026-09-16 in-memory-sort
outage. New photos go to the bucket under `photos/{recipe_id}/{photo_id}`;
documents keep only `photo_meta` (token, storage key, content type, size)
and API responses carry public `/api/photos/{token}` URLs instead of base64.

The bucket and credentials are the same VOICE_BUCKET_* reference variables
PR #51 wired up on the Railway service — one bucket holds all recipe media,
the env prefix is historical. Without them, server.py falls back to
embedding photos in the document as before (dev keeps working, prod must
have them set). The put/get/delete helpers in voice_storage.py are already
generic over (key, bytes, content type), so they are reused rather than
duplicated; what this module adds is the photo key scheme and the base64
decoding/sniffing shared by server.py and the migration script.
"""
import base64
import binascii
import re

from voice_storage import (
    VoiceStorageError,
    VoiceStorageNotConfigured,
    delete_voice_audio,
    get_voice_audio,
    put_voice_audio,
    voice_storage_configured,
)

# Same bucket, same config, same failure modes — photo callers get names
# that read correctly at the call site.
PhotoStorageError = VoiceStorageError
PhotoStorageNotConfigured = VoiceStorageNotConfigured
photo_storage_configured = voice_storage_configured
put_photo = put_voice_audio
get_photo = get_voice_audio
delete_photo = delete_voice_audio


def photo_storage_key(recipe_id: str, photo_id: str) -> str:
    return f"photos/{recipe_id}/{photo_id}"


# Clients send data URIs (web FileReader, mobile 'data:$mime;base64,...');
# pre-2025 documents may hold raw base64 with no prefix.
_DATA_URI_RE = re.compile(r"^data:([^;,]+);base64,(.*)$", re.DOTALL)


def _sniff_content_type(data: bytes) -> str:
    if data.startswith(b"\xff\xd8\xff"):
        return "image/jpeg"
    if data.startswith(b"\x89PNG"):
        return "image/png"
    if data.startswith(b"GIF8"):
        return "image/gif"
    if data[:4] == b"RIFF" and data[8:12] == b"WEBP":
        return "image/webp"
    return "image/jpeg"


def decode_photo_entry(entry: str) -> tuple[bytes, str]:
    """Decode one photos[] entry (data URI or raw base64) to (bytes, content type).

    Raises ValueError for anything that is not a base64 image payload — a
    URL, an empty string, corrupted data. Callers decide whether that is a
    400 (API) or a skip (migration).
    """
    match = _DATA_URI_RE.match(entry)
    if match:
        declared, payload = match.group(1), match.group(2)
    else:
        declared, payload = None, entry
    payload = "".join(payload.split())
    if not payload:
        raise ValueError("empty photo payload")
    try:
        data = base64.b64decode(payload, validate=True)
    except (binascii.Error, ValueError) as exc:
        raise ValueError("photo payload is not valid base64") from exc
    if not data:
        raise ValueError("empty photo payload")
    # Trust a declared image/* type; sniff everything else (some clients
    # fall back to application/octet-stream for unknown extensions).
    if declared and declared.startswith("image/"):
        return data, declared
    return data, _sniff_content_type(data)
