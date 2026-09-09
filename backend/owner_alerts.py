"""Owner sales alerts — one email to the owners for every subscription event
that matters, across all three doors (Apple, Google, Stripe web).

Design constraints (same as email_service):
  - Never raises, never blocks a webhook. Fire-and-forget only.
  - No-op unless OWNER_ALERT_EMAILS is set (comma-separated). Nothing is
    hard-coded here so the recipient list lives in Railway, not in git.
  - Deduped: the same (source, id, kind) never emails twice, so a Stripe
    retry or a RevenueCat redelivery can't spam the inbox.

Config (Railway):
  OWNER_ALERT_EMAILS="hodari@ubuntu-village.org,shy@ubuntu-village.org"
  OWNER_ALERT_RENEWALS=1        # optional — also email on renewals (off by default)
  RESEND_API_KEY / EMAIL_FROM   # already required by email_service
"""
import asyncio
import html
import logging
import os
from datetime import datetime, timezone
from typing import Optional

from pymongo.errors import DuplicateKeyError, PyMongoError

from email_service import send_email

logger = logging.getLogger(__name__)

_COLLECTION = "owner_alerts"


def _recipients() -> list[str]:
    raw = os.environ.get("OWNER_ALERT_EMAILS", "")
    return [e.strip() for e in raw.split(",") if e.strip()]


def renewals_enabled() -> bool:
    return os.environ.get("OWNER_ALERT_RENEWALS", "").strip().lower() in ("1", "true", "yes")


async def ensure_owner_alert_indexes(db) -> None:
    await db[_COLLECTION].create_index("key", unique=True)


# Human labels for the subject line. Anything not listed is not alerted.
_KIND_LABELS = {
    "new_subscriber": "New subscriber",
    "trial_started": "Trial started",
    "trial_converted": "Trial converted",
    "renewal": "Renewal",
    "plan_change": "Plan change",
    "cancellation": "Cancellation",
    "expiration": "Subscription ended",
    "billing_issue": "Billing issue",
    "gift_purchase": "Family Legacy gift purchased",
    "test": "Test event",
}

_STORE_LABELS = {
    "APP_STORE": "Apple",
    "MAC_APP_STORE": "Apple (Mac)",
    "PLAY_STORE": "Google Play",
    "STRIPE": "Web (Stripe)",
    "PROMOTIONAL": "Promo grant",
}


def _fmt_money(amount: Optional[float], currency: Optional[str]) -> str:
    if amount is None:
        return "—"
    cur = (currency or "USD").upper()
    return f"{amount:,.2f} {cur}"


def _alert_html(kind: str, fields: list[tuple[str, str]]) -> str:
    rows = "".join(
        f'<tr><td style="padding:6px 12px 6px 0;color:#92400E;white-space:nowrap;vertical-align:top;">{html.escape(k)}</td>'
        f'<td style="padding:6px 0;">{html.escape(v)}</td></tr>'
        for k, v in fields
        if v
    )
    label = _KIND_LABELS.get(kind, kind)
    return f"""<!DOCTYPE html>
<html lang="en"><body style="margin:0;padding:0;background:#FFFBEB;font-family:Georgia,'Times New Roman',serif;color:#451A03;">
  <div style="max-width:520px;margin:0 auto;padding:32px 24px;">
    <p style="font-size:13px;letter-spacing:2px;text-transform:uppercase;color:#92400E;margin:0 0 16px;">Legacy Table · Sales</p>
    <h1 style="font-size:24px;margin:0 0 16px;">{html.escape(label)}</h1>
    <table style="font-size:15px;line-height:1.5;border-collapse:collapse;">{rows}</table>
    <p style="font-size:12px;color:#A16207;margin-top:32px;border-top:1px solid #FDE68A;padding-top:12px;">
      Sent by the Legacy Table backend. Full detail in RevenueCat / Stripe.
    </p>
  </div>
</body></html>"""


async def _send_alert(db, key: str, kind: str, subject: str, fields: list[tuple[str, str]]) -> None:
    recipients = _recipients()
    if not recipients:
        logger.info("Owner alert skipped (OWNER_ALERT_EMAILS unset): %s", key)
        return
    try:
        await db[_COLLECTION].insert_one({
            "key": key,
            "kind": kind,
            "created_at": datetime.now(timezone.utc).isoformat(),
        })
    except DuplicateKeyError:
        logger.info("Owner alert already sent, skipping: %s", key)
        return
    except PyMongoError as e:
        # Storage trouble should not silence the alert; worst case is a repeat.
        logger.warning("Owner alert dedupe store failed (%s), sending anyway", type(e).__name__)
    body = _alert_html(kind, fields)
    results = await asyncio.gather(*(send_email(r, subject, body) for r in recipients))
    logger.info("Owner alert %s -> %d/%d delivered", key, sum(1 for r in results if r), len(recipients))


def _fire(coro) -> None:
    async def _guarded():
        try:
            await coro
        except Exception as e:  # never let an alert break a webhook
            logger.error("Owner alert error: %s", e)
    asyncio.create_task(_guarded())


# ---- RevenueCat --------------------------------------------------------------

def _rc_kind(event: dict) -> Optional[str]:
    t = event.get("type", "")
    period = (event.get("period_type") or "").upper()
    if t == "INITIAL_PURCHASE":
        return "trial_started" if period == "TRIAL" else "new_subscriber"
    if t == "RENEWAL":
        # First renewal after a trial is the conversion — always worth an email.
        if event.get("is_trial_conversion"):
            return "trial_converted"
        return "renewal" if renewals_enabled() else None
    if t == "PRODUCT_CHANGE":
        return "plan_change"
    if t == "CANCELLATION":
        return "cancellation"
    if t == "EXPIRATION":
        return "expiration"
    if t == "BILLING_ISSUE":
        return "billing_issue"
    if t == "TEST":
        return "test"
    return None


def alert_from_revenuecat(db, event: dict, user_email: Optional[str], tier: Optional[str]) -> None:
    """Call from the RevenueCat webhook. Skips STRIPE-store events because the
    Stripe webhook already alerts on those (avoids double emails)."""
    kind = _rc_kind(event)
    if not kind:
        return
    store = (event.get("store") or "").upper()
    if store == "STRIPE" and kind != "test":
        return
    if event.get("environment", "PRODUCTION").upper() == "SANDBOX" and kind != "test":
        return
    event_id = event.get("id") or f"{event.get('app_user_id')}:{event.get('type')}:{event.get('purchased_at_ms')}"
    key = f"rc:{event_id}"
    store_label = _STORE_LABELS.get(store, store or "—")
    price = event.get("price_in_purchased_currency", event.get("price"))
    subject = f"[Legacy Table] {_KIND_LABELS[kind]} · {store_label}"
    if tier:
        subject += f" · {tier.title()}"
    fields = [
        ("Store", store_label),
        ("Plan", tier.title() if tier else (event.get("product_id") or "—")),
        ("Price", _fmt_money(price, event.get("currency"))),
        ("Country", event.get("country_code") or "—"),
        ("Customer", user_email or "—"),
        ("User ID", event.get("app_user_id") or "—"),
        ("Product", event.get("product_id") or "—"),
        ("Reason", event.get("cancel_reason") or event.get("expiration_reason") or ""),
        ("Event", event.get("type") or "—"),
    ]
    _fire(_send_alert(db, key, kind, subject, fields))


# ---- Stripe (web) --------------------------------------------------------------

def alert_stripe_subscription(db, subscription: dict, event_type: str, customer_email: Optional[str], tier: Optional[str]) -> None:
    """Call from the Stripe webhook for customer.subscription.created/deleted."""
    if event_type == "customer.subscription.created":
        kind = "trial_started" if subscription.get("status") == "trialing" else "new_subscriber"
    elif event_type == "customer.subscription.deleted":
        kind = "expiration"
    else:
        return
    sub_id = subscription.get("id", "")
    key = f"stripe:{sub_id}:{kind}"
    items = (subscription.get("items") or {}).get("data") or []
    price = items[0].get("price") if items else None
    amount = (price.get("unit_amount") or 0) / 100 if price else None
    interval = (price.get("recurring") or {}).get("interval") if price else None
    subject = f"[Legacy Table] {_KIND_LABELS[kind]} · Web (Stripe)"
    if tier:
        subject += f" · {tier.title()}"
    fields = [
        ("Store", "Web (Stripe)"),
        ("Plan", f"{tier.title()} ({interval}ly)" if tier and interval else (tier.title() if tier else "—")),
        ("Price", _fmt_money(amount, price.get("currency") if price else None)),
        ("Customer", customer_email or "—"),
        ("Subscription", sub_id),
        ("Event", event_type),
    ]
    _fire(_send_alert(db, key, kind, subject, fields))


def alert_stripe_gift(db, session: dict, purchaser_email: Optional[str], recipient_name: Optional[str]) -> None:
    """Call from the Stripe webhook after a Family Legacy gift is minted."""
    session_id = session.get("id", "")
    key = f"stripe:{session_id}:gift_purchase"
    amount = (session.get("amount_total") or 0) / 100
    fields = [
        ("Store", "Web (Stripe)"),
        ("Price", _fmt_money(amount, session.get("currency"))),
        ("Buyer", purchaser_email or "—"),
        ("Recipient", recipient_name or "—"),
        ("Session", session_id),
    ]
    _fire(_send_alert(db, key, "gift_purchase", "[Legacy Table] Family Legacy gift purchased · Web (Stripe)", fields))
