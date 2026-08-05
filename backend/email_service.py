"""Outbound transactional email via Resend (https://resend.com).

First email capability in the backend. Design constraints:
  - Graceful no-op when RESEND_API_KEY is unset (dev, or pre-setup prod):
    every send logs and returns False, nothing raises, no request path
    ever fails because email is down or unconfigured.
  - Fire-and-forget from request handlers via send_email_background() so
    webhooks and signup never wait on (or fail because of) Resend.

Setup (one-time, ~15 min):
  1. Create a Resend account, add the legacytable.app domain, and add the
     DNS records Resend shows (SPF + DKIM) at the registrar.
  2. Create an API key; set in Railway:  RESEND_API_KEY=re_...
     Optionally:  EMAIL_FROM="Legacy Table <table@legacytable.app>"
  3. Store the Resend login + API key in the Bitwarden team vault.
"""
import asyncio
import logging
import os
from typing import Optional

import httpx

logger = logging.getLogger(__name__)

RESEND_API_KEY = os.environ.get("RESEND_API_KEY", "")
EMAIL_FROM = os.environ.get("EMAIL_FROM", "Legacy Table <table@legacytable.app>")

_RESEND_URL = "https://api.resend.com/emails"


async def send_email(to: str, subject: str, html: str) -> bool:
    """Send one email. Returns True on success; never raises."""
    if not RESEND_API_KEY:
        logger.info("Email skipped (RESEND_API_KEY unset): %r -> %s", subject, to)
        return False
    if not to:
        return False
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            resp = await client.post(
                _RESEND_URL,
                headers={"Authorization": f"Bearer {RESEND_API_KEY}"},
                json={"from": EMAIL_FROM, "to": [to], "subject": subject, "html": html},
            )
        if resp.status_code in (200, 201):
            logger.info("Email sent: %r -> %s", subject, to)
            return True
        logger.error("Email failed (%s): %s", resp.status_code, resp.text[:300])
        return False
    except Exception as e:  # network, DNS, timeout — never break the caller
        logger.error("Email error sending %r to %s: %s", subject, to, e)
        return False


def send_email_background(to: str, subject: str, html: str) -> None:
    """Fire-and-forget send for use inside request/webhook handlers."""
    asyncio.create_task(send_email(to, subject, html))


# ---- Templates ------------------------------------------------------------
# Same warm palette as the backend invite page (#92400E on cream). Inline
# styles only — email clients ignore <style> blocks.

def _shell(inner: str) -> str:
    return f"""<!DOCTYPE html>
<html lang="en">
<body style="margin:0;padding:0;background:#FFFBEB;font-family:Georgia,'Times New Roman',serif;color:#451A03;">
  <div style="max-width:520px;margin:0 auto;padding:32px 24px;">
    <p style="font-size:13px;letter-spacing:2px;text-transform:uppercase;color:#92400E;margin:0 0 24px;">Legacy Table</p>
    {inner}
    <p style="font-size:12px;color:#A16207;margin-top:40px;border-top:1px solid #FDE68A;padding-top:16px;">
      Legacy Table — where recipes become heirlooms.<br>
      Questions? Just reply to this email or write support@ubuntu-village.org.
    </p>
  </div>
</body>
</html>"""


def welcome_email_html(name: str) -> str:
    first = (name or "").strip().split(" ")[0] or "friend"
    return _shell(f"""
    <h1 style="font-size:26px;margin:0 0 16px;">Welcome to the table, {first}.</h1>
    <p style="font-size:16px;line-height:1.6;">
      You just gave your family's recipes a place to live — with the stories
      and the voices of the people who make them.
    </p>
    <p style="font-size:16px;line-height:1.6;">A good first five minutes:</p>
    <p style="font-size:16px;line-height:1.8;margin:0 0 24px;">
      1. Start your family (or join with an invite code).<br>
      2. Add the one recipe your family would riot without.<br>
      3. Invite the cooks — the table isn't set for one.
    </p>
    <a href="https://legacytable.app/home"
       style="display:inline-block;background:#92400E;color:#ffffff;text-decoration:none;padding:14px 28px;border-radius:12px;font-size:16px;font-weight:bold;">
      Set your table
    </a>""")


def gift_code_email_html(code: str, recipient_name: Optional[str]) -> str:
    for_line = (
        f"for {recipient_name}" if recipient_name else "for someone you love"
    )
    return _shell(f"""
    <h1 style="font-size:26px;margin:0 0 16px;">Your Family Legacy gift is ready.</h1>
    <p style="font-size:16px;line-height:1.6;">
      Thank you — you just bought a year of Legacy Table {for_line}, including
      the printed family cookbook with voice-note QR codes.
    </p>
    <p style="font-size:14px;color:#92400E;margin:24px 0 8px;">Gift code</p>
    <p style="font-size:30px;letter-spacing:6px;font-family:'Courier New',monospace;background:#FEF3C7;border:1px dashed #D97706;border-radius:12px;padding:16px;text-align:center;margin:0 0 24px;">
      {code}
    </p>
    <p style="font-size:16px;line-height:1.6;">
      Pass this code to the recipient — they redeem it at
      <a href="https://legacytable.app/redeem" style="color:#92400E;">legacytable.app/redeem</a>
      after creating a free account. No subscription, no renewal; the year is
      already paid.
    </p>
    <p style="font-size:14px;line-height:1.6;color:#A16207;">
      Tip: gift codes make lovely surprises inside a birthday card.
    </p>""")
