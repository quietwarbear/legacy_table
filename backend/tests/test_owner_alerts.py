"""Owner sales alerts: the right events email the owners exactly once, and
nothing here can ever break a payments webhook.

owner_alerts.py imports only email_service (no DB, no server.py), so it is
tested directly with a fake Mongo collection and a patched send_email.
"""
import asyncio
import os
import sys
from pathlib import Path

import pytest
from pymongo.errors import DuplicateKeyError

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

import owner_alerts  # noqa: E402


class FakeCollection:
    def __init__(self):
        self.keys = set()

    async def insert_one(self, doc):
        if doc["key"] in self.keys:
            raise DuplicateKeyError("dup")
        self.keys.add(doc["key"])

    async def create_index(self, *a, **k):
        return "key_1"


class FakeDB(dict):
    def __getitem__(self, name):
        return self.setdefault(name, FakeCollection()) if name not in self else super().__getitem__(name)


@pytest.fixture
def sent(monkeypatch):
    out = []

    async def fake_send(to, subject, html):
        out.append((to, subject, html))
        return True

    monkeypatch.setattr(owner_alerts, "send_email", fake_send)
    monkeypatch.setenv("OWNER_ALERT_EMAILS", "a@example.org, b@example.org")
    monkeypatch.delenv("OWNER_ALERT_RENEWALS", raising=False)
    return out


async def _drain():
    # let fire-and-forget tasks run
    for _ in range(3):
        await asyncio.sleep(0)


def _rc(**over):
    base = {
        "id": "evt_1",
        "type": "INITIAL_PURCHASE",
        "store": "APP_STORE",
        "environment": "PRODUCTION",
        "app_user_id": "user-1",
        "product_id": "com.htrecipes.familyRecipeApp.keeper.annual",
        "price_in_purchased_currency": 39.99,
        "currency": "USD",
        "country_code": "US",
        "period_type": "NORMAL",
    }
    base.update(over)
    return base


@pytest.mark.asyncio
async def test_initial_purchase_emails_every_owner(sent):
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(), "fam@example.com", "heritage")
    await _drain()
    assert [s[0] for s in sent] == ["a@example.org", "b@example.org"]
    assert "New subscriber" in sent[0][1] and "Apple" in sent[0][1] and "Heritage" in sent[0][1]
    assert "39.99 USD" in sent[0][2] and "fam@example.com" in sent[0][2]


@pytest.mark.asyncio
async def test_same_event_never_emails_twice(sent):
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(), None, "heritage")
    owner_alerts.alert_from_revenuecat(db, _rc(), None, "heritage")
    await _drain()
    assert len(sent) == 2  # two recipients, one event


@pytest.mark.asyncio
async def test_trial_and_conversion_are_labelled(sent):
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(id="e1", period_type="TRIAL"), None, "legacy")
    owner_alerts.alert_from_revenuecat(db, _rc(id="e2", type="RENEWAL", is_trial_conversion=True), None, "legacy")
    await _drain()
    subjects = {s[1] for s in sent}
    assert any("Trial started" in s for s in subjects)
    assert any("Trial converted" in s for s in subjects)


@pytest.mark.asyncio
async def test_plain_renewals_are_quiet_unless_enabled(sent, monkeypatch):
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(id="r1", type="RENEWAL"), None, "heritage")
    await _drain()
    assert sent == []
    monkeypatch.setenv("OWNER_ALERT_RENEWALS", "1")
    owner_alerts.alert_from_revenuecat(db, _rc(id="r2", type="RENEWAL"), None, "heritage")
    await _drain()
    assert len(sent) == 2 and "Renewal" in sent[0][1]


@pytest.mark.asyncio
async def test_stripe_store_and_sandbox_rc_events_are_skipped(sent):
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(id="s1", store="STRIPE"), None, "heritage")
    owner_alerts.alert_from_revenuecat(db, _rc(id="s2", environment="SANDBOX"), None, "heritage")
    await _drain()
    assert sent == []


@pytest.mark.asyncio
async def test_rc_test_event_always_goes_through(sent):
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(id="t1", type="TEST", environment="SANDBOX", store="STRIPE"), None, None)
    await _drain()
    assert len(sent) == 2 and "Test event" in sent[0][1]


@pytest.mark.asyncio
async def test_stripe_new_subscription_and_gift(sent):
    db = FakeDB()
    sub = {
        "id": "sub_1",
        "status": "active",
        "items": {"data": [{"price": {"unit_amount": 4999, "currency": "usd", "recurring": {"interval": "year"}}}]},
    }
    owner_alerts.alert_stripe_subscription(db, sub, "customer.subscription.created", "web@example.com", "legacy")
    owner_alerts.alert_stripe_gift(db, {"id": "cs_1", "amount_total": 9900, "currency": "usd"}, "buyer@example.com", "Mama Lou")
    await _drain()
    subjects = [s[1] for s in sent]
    assert sum("New subscriber" in s for s in subjects) == 2
    assert sum("gift purchased" in s for s in subjects) == 2
    body = next(h for _, s, h in sent if "New subscriber" in s)
    assert "49.99 USD" in body and "Legacy (yearly)" in body


@pytest.mark.asyncio
async def test_no_recipients_means_no_email_and_no_error(sent, monkeypatch):
    monkeypatch.setenv("OWNER_ALERT_EMAILS", "")
    db = FakeDB()
    owner_alerts.alert_from_revenuecat(db, _rc(), None, "heritage")
    await _drain()
    assert sent == []


@pytest.mark.asyncio
async def test_alert_failure_never_raises(sent, monkeypatch):
    class BrokenDB(dict):
        def __getitem__(self, name):
            raise RuntimeError("db down")

    owner_alerts.alert_from_revenuecat(BrokenDB(), _rc(), None, "heritage")
    await _drain()  # would surface as an unhandled task exception otherwise
    assert sent == []
