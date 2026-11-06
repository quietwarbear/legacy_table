"""Who may start an 'Open in Kindred' jump.

Kindred signs the person into whichever Kindred account holds the email
Legacy Table sends. An address nobody has proved must never travel, or anyone
could register here with someone else's email and land in their Kindred
account.

Legacy Table doesn't verify emails for password sign-ups, so for now only
sign-ins where the provider has proved the address (Google, Apple) may jump.
Accounts that carry email_verified=True (none today) also qualify, so adding
email verification later switches password accounts on with no change here.
"""

VERIFIED_SIGN_IN_PROVIDERS = frozenset({"google", "apple"})

UNVERIFIED_MESSAGE = (
    "Opening Kindred from here needs an account signed in with Google or Apple. "
    "You can still sign in at heykindred.org directly."
)


def email_proven(user: dict) -> bool:
    if user.get("email_verified") is True:
        return True
    return user.get("auth_provider") in VERIFIED_SIGN_IN_PROVIDERS
