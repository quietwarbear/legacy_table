"""A Stripe customer created against one account is unusable on another.

That is exactly what a Stripe account migration produces, and the symptom is
invisible: checkout just fails. These tests pin the recovery behaviour without
importing server.py, which needs a database and live config to load.
"""

import ast
from pathlib import Path

import pytest

SERVER = Path(__file__).resolve().parents[1] / "server.py"
TREE = ast.parse(SERVER.read_text(encoding="utf-8"))


def _function(name):
    for node in ast.walk(TREE):
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)) and node.name == name:
            return node
    raise AssertionError(f"{name}() not found in server.py")


def _load(name):
    """Exec a single top-level function out of server.py in a bare namespace."""
    src = ast.get_source_segment(SERVER.read_text(encoding="utf-8"), _function(name))
    ns = {}
    exec(compile(src, str(SERVER), "exec"), ns)
    return ns[name]


is_missing_customer_error = _load("_is_missing_customer_error")


class StripeError(Exception):
    """Stand-in for stripe.error.InvalidRequestError, which carries `param`."""

    def __init__(self, message, param=None):
        super().__init__(message)
        self.param = param


@pytest.mark.parametrize(
    "exc",
    [
        # The real message Stripe returns for a customer from another account.
        StripeError("No such customer: 'cus_UgVAgSoh2aq0P8'"),
        StripeError("Request req_x: No such customer: 'cus_x'", param="customer"),
        StripeError("no such customer: 'cus_x'"),
        StripeError("boom", param="customer"),
    ],
)
def test_detects_unusable_customer(exc):
    assert is_missing_customer_error(exc) is True


@pytest.mark.parametrize(
    "exc",
    [
        StripeError("No such price: 'price_x'", param="line_items[0][price]"),
        StripeError("Your card was declined."),
        StripeError("No such subscription: 'sub_x'"),
        ValueError("unrelated"),
    ],
)
def test_ignores_unrelated_failures(exc):
    """Recreating a customer must not paper over a genuine payment failure."""
    assert is_missing_customer_error(exc) is False


def _calls(func_name):
    return {
        node.func.id
        for node in ast.walk(_function(func_name))
        if isinstance(node, ast.Call) and isinstance(node.func, ast.Name)
    }


def test_checkout_recovers_from_an_unusable_customer():
    """Checkout must mint a replacement customer rather than surfacing the error."""
    calls = _calls("create_checkout_session")
    assert "_is_missing_customer_error" in calls
    assert "_create_stripe_customer" in calls


def test_portal_clears_an_unusable_customer():
    """The portal has no subscription to show, but must not leave the stale ID
    in place — otherwise the user's next checkout fails too."""
    portal = _function("create_portal_session")
    calls = _calls("create_portal_session")
    assert "_is_missing_customer_error" in calls
    src = ast.get_source_segment(SERVER.read_text(encoding="utf-8"), portal)
    assert "$unset" in src and "stripe_customer_id" in src
