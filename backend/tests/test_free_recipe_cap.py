"""The free recipe cap must never reach backwards.

Accounts created under the unlimited promise keep it. The cap declines a new
recipe for capped accounts at the limit and nothing else — it never touches
recipes already saved.
"""
import importlib.util
import pathlib
import sys
import types

import pytest

ROOT = pathlib.Path(__file__).resolve().parents[1]


def _load_server_constants():
    """Read the cap logic out of server.py without importing the whole app
    (which wants Mongo, Stripe and OpenAI credentials at import time)."""
    src = (ROOT / "server.py").read_text(encoding="utf-8")
    start = src.index("FREE_TIER_RECIPE_LIMIT = ")
    end = src.index("\n\n\n", src.index("def free_recipe_cap_applies"))
    mod = types.ModuleType("cap_under_test")
    exec(compile(src[start:end], "server.py", "exec"), mod.__dict__)
    return mod


cap = _load_server_constants()


def test_limit_is_a_positive_number():
    assert isinstance(cap.FREE_TIER_RECIPE_LIMIT, int)
    assert cap.FREE_TIER_RECIPE_LIMIT > 0


@pytest.mark.parametrize("tier", ["heritage", "legacy", "family_legacy"])
def test_paid_accounts_are_never_capped(tier):
    user = {"subscription_tier": tier, "created_at": "2026-12-01T00:00:00+00:00"}
    assert cap.free_recipe_cap_applies(user) is False


def test_account_opened_before_the_cutoff_keeps_unlimited():
    user = {"subscription_tier": None, "created_at": "2026-09-19T23:59:00+00:00"}
    assert cap.free_recipe_cap_applies(user) is False


def test_account_opened_on_the_cutoff_is_capped():
    user = {"subscription_tier": None, "created_at": "2026-09-20T00:00:01+00:00"}
    assert cap.free_recipe_cap_applies(user) is True


def test_account_opened_after_the_cutoff_is_capped():
    user = {"subscription_tier": None, "created_at": "2027-01-05T12:00:00+00:00"}
    assert cap.free_recipe_cap_applies(user) is True


@pytest.mark.parametrize("created", [None, "", 0])
def test_missing_created_at_is_grandfathered_not_capped(created):
    """An account we can't date is an old account. Fail open, never at the
    user's expense."""
    assert cap.free_recipe_cap_applies({"subscription_tier": None, "created_at": created}) is False
