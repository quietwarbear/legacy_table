# Store Console Checklist — Week 1 (manual actions)

These cannot be fixed in code. Do them in App Store Connect / Google Play Console.
Source: growth audit, July 6, 2026.

## Google Play Console (urgent)

1. **Data safety form** — currently declares "No data collected / No data shared."
   Legacy Table collects at minimum: name, email address (account), photos, voice
   recordings, user content (recipes/stories), purchase history (subscriptions).
   An inaccurate declaration is grounds for listing removal. Re-submit the form
   truthfully (Play Console → App content → Data safety).
2. **Short description** (30–80 chars, currently typo'd). Replace
   `Welcome to Legacy Table. Create family space, add recipes & build cookbook. now!`
   with:
   `Save your family's recipes, stories & voices in one private cookbook.`
3. **Screenshots** — replace with the 5-shot narrative (see below). Add descriptive
   alt text where supported.

## App Store Connect

1. **iPad screenshot slots** — remove the placeholder clip-art images
   ("Placeholder.mill" green plate icons) and upload real iPad captures
   (ipad_home.png / ipad_recipes.png exist and can hold the slots until a
   proper set is shot).
2. **Version string** — next release, submit `2.3.3` (no trailing period; the
   live listing shows `2.3.1.`).
3. **App name** (30 chars max) — `Legacy Table: Family Recipes` (28 ✓).
4. **Subtitle** (30 chars max) — `Preserve Grandma's Cookbook` (27 ✓).
   Adds three new index tokens (preserve/grandma/cookbook); Apple ignores
   tokens duplicated across name/subtitle/keywords, so no repeats.
5. **Keyword field** (100 chars, private) — final, 99 chars:
   `heirloom,keeper,heritage,tradition,voice,notes,nana,abuela,kitchen,organizer,scan,handwritten,story`
   Excludes tokens already in name/subtitle and competitor brand names.
   Note: iOS name/subtitle/keywords only change WITH a version submission —
   enter all of these while submitting the 2.3.3 build.

### Play full-description opening (Play indexes this text; iOS doesn't)

> Legacy Table is the private family cookbook app for preserving heirloom
> recipes — with the stories and voice notes of the people who taught them.
> Scan handwritten recipe cards, record Grandma explaining the roux, and
> build a family recipe archive your whole family writes together.

## Both stores — 5-shot screenshot narrative

1. Hero: recipe card with story visible — "Every recipe carries its story"
2. Voice: recording UI — "Keep the voice that taught you"
3. AI scan: photo of a stained index card → structured recipe — "Old cards, saved forever"
4. Family: members screen — "The whole family builds it together"
5. Cookbook: PDF/cookbook view — "An heirloom you can pass down"

## Seller-name consistency

Store seller is `Ubuntu Market LLC`; website footer says `Ubuntu Markets LLC`.
Align to the legal entity name in both places.

## DNS (registrar / Vercel)

Add a `www.legacytable.app` record (CNAME → cname.vercel-dns.com, then add the
domain in Vercel project settings so it redirects to the apex). Currently the
www host does not resolve at all.
