"""Voice keepsake audio storage on a Railway Bucket (S3-compatible).

Recipe documents used to embed the recording as base64 (`voice_note.audio`,
up to ~11MB per recipe), which is what pushed the recipes collection past
Mongo's 32MB in-memory sort limit in the 2026-09-16 outage. New recordings
go to the bucket; documents keep only `voice_meta` (format, duration, size,
storage key) plus the public `voice_token`.

Configuration comes from the Railway bucket's reference variables
(VOICE_BUCKET_* on the legacy_table service). Without them every function
raises VoiceStorageNotConfigured, and server.py falls back to embedding the
audio in the document — dev environments keep working with no bucket.

boto3 is synchronous; callers are async, so the S3 calls run in a thread
via asyncio.to_thread. Imports only stdlib + boto3 (no DB, no server.py)
so it stays testable in isolation.
"""
import asyncio
import functools
import os

import boto3
from botocore.config import Config as BotoConfig


class VoiceStorageNotConfigured(RuntimeError):
    pass


class VoiceStorageError(RuntimeError):
    """Upload/download/delete failed after storage was configured."""


def voice_storage_configured() -> bool:
    return all(
        os.environ.get(name)
        for name in (
            "VOICE_BUCKET",
            "VOICE_BUCKET_ENDPOINT",
            "VOICE_BUCKET_ACCESS_KEY_ID",
            "VOICE_BUCKET_SECRET_ACCESS_KEY",
        )
    )


@functools.lru_cache(maxsize=1)
def _client():
    if not voice_storage_configured():
        raise VoiceStorageNotConfigured("VOICE_BUCKET_* env vars are not set")
    return boto3.client(
        "s3",
        endpoint_url=os.environ["VOICE_BUCKET_ENDPOINT"],
        region_name=os.environ.get("VOICE_BUCKET_REGION", "auto"),
        aws_access_key_id=os.environ["VOICE_BUCKET_ACCESS_KEY_ID"],
        aws_secret_access_key=os.environ["VOICE_BUCKET_SECRET_ACCESS_KEY"],
        config=BotoConfig(retries={"max_attempts": 3, "mode": "standard"}),
    )


def voice_storage_key(recipe_id: str) -> str:
    return f"voice/{recipe_id}"


def _bucket() -> str:
    return os.environ["VOICE_BUCKET"]


async def put_voice_audio(key: str, audio: bytes, content_type: str) -> None:
    try:
        await asyncio.to_thread(
            _client().put_object,
            Bucket=_bucket(),
            Key=key,
            Body=audio,
            ContentType=content_type,
        )
    except VoiceStorageNotConfigured:
        raise
    except Exception as exc:
        raise VoiceStorageError(f"put failed for {key}: {type(exc).__name__}") from exc


async def get_voice_audio(key: str) -> bytes:
    try:
        response = await asyncio.to_thread(
            _client().get_object, Bucket=_bucket(), Key=key
        )
        return await asyncio.to_thread(response["Body"].read)
    except VoiceStorageNotConfigured:
        raise
    except Exception as exc:
        raise VoiceStorageError(f"get failed for {key}: {type(exc).__name__}") from exc


async def delete_voice_audio(key: str) -> None:
    try:
        await asyncio.to_thread(
            _client().delete_object, Bucket=_bucket(), Key=key
        )
    except VoiceStorageNotConfigured:
        raise
    except Exception as exc:
        raise VoiceStorageError(f"delete failed for {key}: {type(exc).__name__}") from exc
