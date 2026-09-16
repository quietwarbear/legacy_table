"""Photo payload decoding: every shape clients actually send must round-trip
(web FileReader data URIs, mobile data URIs, pre-2025 raw base64), and
anything else — URLs, junk, empty strings — must be a clean ValueError, since
server.py turns that into a 400 and the migration into a skip.

photo_storage.py imports only stdlib + voice_storage (stdlib + boto3), so it
is tested directly with no DB or app.
"""
import base64
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from photo_storage import decode_photo_entry, photo_storage_key  # noqa: E402

JPEG = b"\xff\xd8\xff\xe0" + b"jpegbody"
PNG = b"\x89PNG\r\n\x1a\n" + b"pngbody"
WEBP = b"RIFF\x00\x00\x00\x00WEBPrest"


def _b64(data: bytes) -> str:
    return base64.b64encode(data).decode()


def test_data_uri_uses_declared_type():
    data, ctype = decode_photo_entry(f"data:image/png;base64,{_b64(JPEG)}")
    assert data == JPEG
    assert ctype == "image/png"


def test_raw_base64_sniffs_type():
    for raw, expected in [(JPEG, "image/jpeg"), (PNG, "image/png"),
                          (WEBP, "image/webp")]:
        data, ctype = decode_photo_entry(_b64(raw))
        assert data == raw
        assert ctype == expected


def test_non_image_declared_type_falls_back_to_sniffing():
    data, ctype = decode_photo_entry(
        f"data:application/octet-stream;base64,{_b64(PNG)}")
    assert data == PNG
    assert ctype == "image/png"


def test_unknown_magic_defaults_to_jpeg():
    _, ctype = decode_photo_entry(_b64(b"no magic here"))
    assert ctype == "image/jpeg"


def test_whitespace_in_payload_is_tolerated():
    b64 = _b64(JPEG)
    wrapped = "\n".join([b64[:8], b64[8:]])
    data, _ = decode_photo_entry(f"data:image/jpeg;base64,{wrapped}")
    assert data == JPEG


@pytest.mark.parametrize("entry", [
    "",
    "data:image/jpeg;base64,",
    "https://api.legacytable.app/api/photos/" + "a" * 32,
    "data:image/jpeg;base64,not!!valid@@base64",
    "https://example.com/cat.jpg",
])
def test_invalid_entries_raise_value_error(entry):
    with pytest.raises(ValueError):
        decode_photo_entry(entry)


def test_photo_storage_key_layout():
    assert photo_storage_key("r1", "p1") == "photos/r1/p1"
