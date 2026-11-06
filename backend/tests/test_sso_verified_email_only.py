"""'Open in Kindred' only carries an email the person has proven they own.

Kindred signs the person into whichever account holds the email Legacy Table
sends, so an unproven address would let anyone who registers here with
someone else's email land in that person's Kindred account.
"""
import pathlib
import sys

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

import sso_guard  # noqa: E402


@pytest.mark.parametrize(
    "user, proven",
    [
        ({"auth_provider": "google"}, True),
        ({"auth_provider": "apple"}, True),
        ({"auth_provider": "password"}, False),
        ({}, False),  # password sign-ups carry no provider or flag
        ({"auth_provider": "facebook"}, False),
        ({"auth_provider": "ubuntu-sso"}, False),
        ({"email_verified": True}, True),
        ({"email_verified": "true", "auth_provider": "password"}, False),
    ],
)
def test_email_proven(user, proven):
    assert sso_guard.email_proven(user) is proven


def test_open_kindred_checks_before_contacting_kindred():
    src = (ROOT / "server.py").read_text(encoding="utf-8")
    body = src.split("async def lt_open_kindred", 1)[1].split("\n@api_router", 1)[0]
    guard = body.index("sso_guard.email_proven(user)")
    assert guard < body.index("UBUNTU_SSO_SECRET")
    assert guard < body.index("/auth/sso-code")
    assert "status_code=403" in body[guard:guard + 200]
