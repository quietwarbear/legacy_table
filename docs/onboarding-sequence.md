# Legacy Table — New-user activation sequence

**Goal:** Move a new account from "this is interesting" to "this is valuable enough to pay for" by getting them to three moments: first recipe saved, first family member invited, first recipe added by someone else. Paid conversion follows those moments; it doesn't precede them.

**Voice:** the existing welcome email already has it — warm, short, family-first. Every message in this sequence keeps that register and repeats the ownership promise once, early.

**Triggers use in-app events, not calendar days alone.** A message is skipped if the user already did the thing. Exit the sequence entirely on subscription.

---

## What exists today (from the codebase, Sep 9 2026)

- Welcome email on signup via `send_email_background` → `welcome_email_html`. Dormant unless `RESEND_API_KEY` is set on Railway.
- FCM push wired on backend and mobile (`push_service.dart`); a weekly family-prompt loop that sends to all tokens. Dormant unless `FIREBASE_SERVICE_ACCOUNT` is set.
- `/onboarding/seed-sample-family` endpoint that adds sample recipes.
- In-app notifications write to the database only.

**Before building anything:** confirm both env vars are set in Railway. If the welcome email has never gone out, that alone is step one.

---

## The sequence

| # | When | Channel | Skip if | Job |
|---|------|---------|---------|-----|
| 0 | Signup | Email | — | Welcome + ownership promise |
| 1 | Day 2 | Email + push | Has saved a recipe | First recipe |
| 2 | Day 5 | Email | Has invited someone | Invite one person |
| 3 | Day 9 | Push | Family has 2+ members | Get the elder in |
| 4 | Day 14 | Email | Opened app in last 7 days | Come back |
| 5 | Day 21 | Email | Subscribed, or family < 2 members | Why upgrade |
| 6 | Day 30 | Push | Opened app in last 14 days | Last call |

Then the existing weekly family prompt takes over.

---

### 0 · Welcome (signup) — email

Keep the current welcome email. Add one paragraph after the opener so the promise lands in the first message they ever get:

> One thing before you start: **your recipes are yours.** We never sell them, share them, or use them without you. Only the family you invite can see what you save, and you can download or delete everything, any time.

Everything else stays as written. The "Set your table" button is already right.

---

### 1 · First recipe (day 2) — email + push

**Skip if:** user has saved at least one recipe.

**Push:** Which recipe would your family riot without? Save it in two minutes. → opens Share a Recipe

**Email subject:** The one recipe your family would riot without

**Body:**
{First}, every family has one. The jollof that has to be made a certain way. The pound cake nobody else gets right. The soup that shows up when someone's sick.

Start with that one. You don't need the exact measurements; you can voice it, scan a handwritten card, or save it from a link, and fix the details later.

[Button: Save the first recipe]

Your recipes stay yours. Always.

---

### 2 · Invite one person (day 5) — email

**Skip if:** user has sent at least one invite.

**Subject:** A cookbook with one cook isn't a cookbook yet

**Body:**
{First}, the recipes you save are safe. But the table isn't set for one.

Invite the person who taught you the most in the kitchen, or the one who keeps asking you for the recipe. They'll see only what your family saves, nothing else, and they can add their own.

[Button: Invite one person]

Tip: send the invite code by WhatsApp. That's where the family already is.

---

### 3 · Get the elder in (day 9) — push

**Skip if:** family has two or more members.

**Push:** Whose recipe is about to be lost? Invite them today and let them voice it. → opens Invite

---

### 4 · Come back (day 14) — email

**Skip if:** user opened the app in the last 7 days.

**Subject:** Your table is still set, {First}

**Body:**
Life got busy. That's fine; the table waits.

If it helps, here's the fastest way back in: open the app, tap Voice a Recipe, and talk for sixty seconds about one dish. That's a saved recipe. Everything else can come later.

[Button: Open Legacy Table]

If you're not sure Legacy Table is for you, reply and tell us what you were hoping it would do. A real person reads these.

---

### 5 · Why upgrade (day 21) — email

**Skip if:** subscribed. **Also skip if:** family has fewer than two members (they haven't felt the value yet; don't sell to them, send them back to step 2 logic).

**Subject:** What paying actually gets you

**Body:**
{First}, your account is free and stays free. Your recipes are yours either way; paying never changes that.

What Heritage Keeper adds is room and help: a bigger family, and the AI features that turn a voice note or a photo of grandma's card into a clean recipe with her words kept intact. Legacy Collection is the same for the whole extended family.

If your cookbook has started to feel like the real thing, this is when it's worth it.

[Button: See plans]

Billing runs through the App Store or Google Play. Cancel from your phone any time.

---

### 6 · Last call (day 30) — push

**Skip if:** opened the app in the last 14 days.

**Push:** One recipe. Sixty seconds. Voice it before it's gone. → opens Voice a Recipe

After this, the user drops into the standing weekly family prompt and no further one-off messages.

---

## Build notes for the developer

- Add a `lifecycle` collection (or fields on `users`): `signup_at`, `first_recipe_at`, `first_invite_at`, `last_open_at`, `subscribed_at`, and a `sent` set of step ids.
- One scheduler tick (same pattern as `weekly_prompt_loop`) evaluates every user once a day against the table above and sends what's due. Idempotent by step id.
- Email goes through the existing `send_email_background`; push through `send_push_to_all` refactored into a per-token `send_push_to_user`.
- Every email carries the unsubscribe footer `_shell` already provides; step 5 must also honor "don't email me about plans."
- Track opens and taps per step in the same `track` layer the landing page uses so Amaka and Sobia can read the funnel.

## What to measure (Amaka's question, answered with numbers)

Signup → first recipe (target 40% by day 7) → first invite (25% by day 14) → second member adds a recipe (10% by day 21) → subscribe. Wherever the biggest drop is, that's the step to rewrite first.
