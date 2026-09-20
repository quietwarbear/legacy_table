#!/usr/bin/env python3
"""Upload an Android App Bundle to Google Play via the Play Developer API.

Defaults to creating a DRAFT release: the build is uploaded and attached to
the track, but a human still clicks through review and rollout in Play
Console. Pass --status completed to roll out on upload.

One-time setup: see scripts/release/README.md

Examples:
    scripts/release/upload_android.py \\
        --aab mobile/build/app/outputs/bundle/release/app-release.aab \\
        --track production \\
        --notes "Performance and reliability improvements."

    # roll out immediately instead of leaving a draft
    scripts/release/upload_android.py --aab ... --track production --status completed
"""
import argparse
import os
import sys

DEFAULT_PACKAGE = "com.htrecipes.family_recipe_app"  # Legacy Table
SCOPES = ["https://www.googleapis.com/auth/androidpublisher"]


def parse_args():
    p = argparse.ArgumentParser(
        description="Upload an .aab to Google Play.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    p.add_argument("--aab", required=True, help="path to the .aab")
    p.add_argument(
        "--package",
        default=os.environ.get("PLAY_PACKAGE_NAME", DEFAULT_PACKAGE),
        help=f"application id (default: {DEFAULT_PACKAGE})",
    )
    p.add_argument(
        "--track",
        required=True,
        choices=["internal", "alpha", "beta", "production"],
        help="Play track to attach the release to",
    )
    p.add_argument(
        "--status",
        default="draft",
        choices=["draft", "completed"],
        help="draft (default) leaves rollout to a human; completed releases it",
    )
    p.add_argument("--notes", default="", help='release notes ("What\'s new")')
    p.add_argument(
        "--language", default="en-US", help="release-notes language (default en-US)"
    )
    p.add_argument(
        "--service-account",
        default=os.environ.get("GOOGLE_PLAY_SERVICE_ACCOUNT_JSON", ""),
        help="path to the service-account JSON "
        "(or set GOOGLE_PLAY_SERVICE_ACCOUNT_JSON)",
    )
    return p.parse_args()


def main():
    args = parse_args()

    if not os.path.isfile(args.aab):
        sys.exit(f"error: AAB not found: {args.aab}")
    if not args.service_account:
        sys.exit(
            "error: --service-account (or GOOGLE_PLAY_SERVICE_ACCOUNT_JSON) "
            "is required — see scripts/release/README.md"
        )
    if not os.path.isfile(args.service_account):
        sys.exit(f"error: service-account JSON not found: {args.service_account}")

    try:
        from google.oauth2 import service_account
        from googleapiclient.discovery import build
        from googleapiclient.http import MediaFileUpload
    except ImportError:
        sys.exit(
            "error: missing dependencies. Install with:\n"
            "  pip3 install google-api-python-client google-auth"
        )

    creds = service_account.Credentials.from_service_account_file(
        args.service_account, scopes=SCOPES
    )
    service = build("androidpublisher", "v3", credentials=creds, cache_discovery=False)
    edits = service.edits()

    print(f"==> Opening edit for {args.package}")
    edit_id = edits.insert(body={}, packageName=args.package).execute()["id"]

    try:
        print(f"==> Uploading {os.path.basename(args.aab)} "
              f"({os.path.getsize(args.aab) / 1_048_576:.1f} MB)")
        bundle = edits.bundles().upload(
            editId=edit_id,
            packageName=args.package,
            media_body=MediaFileUpload(
                args.aab, mimetype="application/octet-stream", resumable=True
            ),
        ).execute()
        version_code = bundle["versionCode"]
        print(f"    uploaded versionCode {version_code}")

        release = {
            "name": str(version_code),
            "versionCodes": [str(version_code)],
            "status": args.status,
        }
        if args.notes:
            release["releaseNotes"] = [
                {"language": args.language, "text": args.notes}
            ]

        print(f"==> Attaching to '{args.track}' as {args.status}")
        edits.tracks().update(
            editId=edit_id,
            track=args.track,
            packageName=args.package,
            body={"track": args.track, "releases": [release]},
        ).execute()

        print("==> Committing edit")
        edits.commit(editId=edit_id, packageName=args.package).execute()
    except Exception:
        # Abandon the edit so a failed run doesn't leave a dangling draft edit
        # blocking the next attempt.
        try:
            edits.delete(editId=edit_id, packageName=args.package).execute()
            print("    (edit abandoned)", file=sys.stderr)
        except Exception:
            pass
        raise

    if args.status == "draft":
        print(
            f"\n==> Done. versionCode {version_code} is a DRAFT on '{args.track}'.\n"
            "Nothing is live yet — open Play Console, review the release, and\n"
            "start the rollout when ready."
        )
    else:
        print(
            f"\n==> Done. versionCode {version_code} submitted to '{args.track}'.\n"
            "Google review typically takes a few hours to a couple of days."
        )


if __name__ == "__main__":
    main()
