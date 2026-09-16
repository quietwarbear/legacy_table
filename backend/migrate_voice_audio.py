"""One-time migration: move embedded voice_note audio to the Railway bucket.

For every recipe with an embedded `voice_note`, this uploads the decoded
audio to the bucket, verifies it reads back byte-identical, writes
`voice_meta`, and only then $unsets the embedded `voice_note`. A recipe is
never left without its audio: the unset happens strictly after readback
verification, and a failure on any recipe skips it and continues.

Run with the same env as the API (MONGO_URL, DB_NAME, VOICE_BUCKET_*), e.g.:

    railway run python migrate_voice_audio.py --dry-run
    railway run python migrate_voice_audio.py

Idempotent: recipes already carrying voice_meta are skipped, so it can be
re-run after a partial failure.
"""
import asyncio
import base64
import os
import sys

import typer
from motor.motor_asyncio import AsyncIOMotorClient

from voice_storage import (
    get_voice_audio,
    put_voice_audio,
    voice_storage_configured,
    voice_storage_key,
)

_AUDIO_MEDIA_TYPES = {
    "mp4": "audio/mp4",
    "m4a": "audio/mp4",
    "wav": "audio/wav",
    "webm": "audio/webm",
}


async def migrate(dry_run: bool) -> int:
    if not voice_storage_configured():
        typer.echo("VOICE_BUCKET_* env vars are not set — aborting.", err=True)
        return 1
    client = AsyncIOMotorClient(os.environ["MONGO_URL"])
    db = client[os.environ.get("DB_NAME", "legacy_table")]

    cursor = db.recipes.find(
        {"voice_note": {"$exists": True}, "voice_meta": {"$exists": False}},
        {"id": 1, "voice_note": 1},
    )
    migrated = failed = 0
    async for recipe in cursor:
        recipe_id = recipe["id"]
        vn = recipe["voice_note"]
        try:
            audio = base64.b64decode(vn["audio"])
        except Exception:
            typer.echo(f"SKIP {recipe_id}: embedded audio is not valid base64")
            failed += 1
            continue
        key = voice_storage_key(recipe_id)
        if dry_run:
            typer.echo(f"DRY  {recipe_id}: would upload {len(audio)} bytes to {key}")
            migrated += 1
            continue
        try:
            await put_voice_audio(
                key, audio, _AUDIO_MEDIA_TYPES.get(vn.get("format", "mp4"), "audio/mpeg"))
            readback = await get_voice_audio(key)
            if readback != audio:
                raise RuntimeError("readback mismatch")
        except Exception as exc:
            typer.echo(f"FAIL {recipe_id}: {exc}", err=True)
            failed += 1
            continue
        await db.recipes.update_one(
            {"id": recipe_id},
            {
                "$set": {
                    "voice_meta": {
                        "format": vn.get("format", "mp4"),
                        "duration_seconds": vn.get("duration_seconds"),
                        "size_bytes": len(audio),
                        "storage_key": key,
                    }
                },
                "$unset": {"voice_note": ""},
            },
        )
        typer.echo(f"OK   {recipe_id}: {len(audio)} bytes -> {key}")
        migrated += 1

    typer.echo(f"Done: {migrated} migrated, {failed} failed/skipped.")
    return 1 if failed else 0


def main(dry_run: bool = typer.Option(False, "--dry-run", help="Report without writing")):
    sys.exit(asyncio.run(migrate(dry_run)))


if __name__ == "__main__":
    typer.run(main)
