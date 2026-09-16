"""One-time migration: move embedded base64 recipe photos to the Railway bucket.

For every recipe with embedded `photos`, this decodes each entry, uploads
it to the bucket, verifies it reads back byte-identical, writes
`photo_meta` (fresh unguessable tokens, display order preserved), and only
then empties the embedded `photos` list. A recipe is never left without
its photos: the document rewrite happens strictly after every photo of
that recipe verified, and a failure on any photo skips the whole recipe
(its uploads are removed) and continues.

Run with the same env as the API (MONGO_URL, DB_NAME, VOICE_BUCKET_*), e.g.:

    railway run python migrate_recipe_photos.py --dry-run
    railway run python migrate_recipe_photos.py

Idempotent: recipes already carrying photo_meta are skipped, so it can be
re-run after a partial failure. Recipes whose entries are not decodable
base64 are reported and left embedded.
"""
import asyncio
import os
import sys
import uuid

import typer
from motor.motor_asyncio import AsyncIOMotorClient

from photo_storage import (
    decode_photo_entry,
    delete_photo,
    get_photo,
    photo_storage_configured,
    photo_storage_key,
    put_photo,
)


async def migrate(dry_run: bool) -> int:
    if not photo_storage_configured():
        typer.echo("VOICE_BUCKET_* env vars are not set — aborting.", err=True)
        return 1
    client = AsyncIOMotorClient(os.environ["MONGO_URL"])
    db = client[os.environ.get("DB_NAME", "legacy_table")]

    cursor = db.recipes.find(
        {"photos.0": {"$exists": True}, "photo_meta": {"$exists": False}},
        {"id": 1, "photos": 1},
    )
    migrated = failed = 0
    async for recipe in cursor:
        recipe_id = recipe["id"]
        photo_meta, uploaded_keys, total_bytes = [], [], 0
        error = None
        for index, entry in enumerate(recipe["photos"]):
            try:
                data, content_type = decode_photo_entry(entry)
            except ValueError:
                error = f"photo {index} is not valid base64"
                break
            total_bytes += len(data)
            if dry_run:
                continue
            key = photo_storage_key(recipe_id, uuid.uuid4().hex)
            try:
                await put_photo(key, data, content_type)
                uploaded_keys.append(key)
                if await get_photo(key) != data:
                    raise RuntimeError("readback mismatch")
            except Exception as exc:
                error = f"photo {index}: {exc}"
                break
            photo_meta.append({
                "token": uuid.uuid4().hex,
                "storage_key": key,
                "content_type": content_type,
                "size_bytes": len(data),
            })
        if error:
            typer.echo(f"FAIL {recipe_id}: {error}", err=True)
            for key in uploaded_keys:
                try:
                    await delete_photo(key)
                except Exception:
                    typer.echo(f"       orphan left at {key}", err=True)
            failed += 1
            continue
        if dry_run:
            typer.echo(
                f"DRY  {recipe_id}: would upload {len(recipe['photos'])} "
                f"photos ({total_bytes} bytes)")
            migrated += 1
            continue
        await db.recipes.update_one(
            {"id": recipe_id},
            {"$set": {"photo_meta": photo_meta, "photos": []}},
        )
        typer.echo(
            f"OK   {recipe_id}: {len(photo_meta)} photos "
            f"({total_bytes} bytes) -> photos/{recipe_id}/")
        migrated += 1

    typer.echo(f"Done: {migrated} migrated, {failed} failed/skipped.")
    return 1 if failed else 0


def main(dry_run: bool = typer.Option(False, "--dry-run", help="Report without writing")):
    sys.exit(asyncio.run(migrate(dry_run)))


if __name__ == "__main__":
    typer.run(main)
