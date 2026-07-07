# Printed heirloom cookbook (Family Legacy fulfillment)

Family's recipes → interior PDF with QR voice pages → wraparound cover →
Lulu Print API → hardcover on the shelf. The QR codes encode the public
`/listen/{voice_token}` pages, so the printed book plays the cook's voice
in any phone camera.

## Verified economics (Lulu, standard color, 8.5×8.5, July 2026)
- 60p hardcover: $14.79 print + $5.69–13.74 US shipping → ~$20–29 landed
- 120p hardcover: $18.60 print → ~$24–32 landed
- On the $99 gift SKU: 67–79% gross margin at recommended defaults
- Default: standard color on 80# coated, casewrap hardcover, GROUND

## Endpoints
- `POST /api/cookbook/print/preview` (auth) → generates the interior PDF,
  returns a proofing URL (`/api/cookbook/artifact/{token}`)
- `POST /api/cookbook/print/order` (auth) → full pipeline: interior +
  cover (spine width from Lulu's cover-dimensions API), artifacts stored
  in GridFS, print job created. Entitled by a redeemed Family Legacy gift
  with `cookbook_status: not_started`; `PUSH_ADMIN_EMAILS` members bypass
  for sandbox testing.
- `GET /api/cookbook/print/order/{id}` (auth) → merges stored + live Lulu
  status.

## Railway env
- `LULU_CLIENT_KEY` / `LULU_CLIENT_SECRET` — from developers.lulu.com
- `LULU_USE_SANDBOX` — `true` (default) until first proofed live order
- Optional overrides: `LULU_POD_HARDCOVER`, `LULU_POD_SOFTCOVER`,
  `LULU_CONTACT_EMAIL`, `PUBLIC_WEB_BASE`, `PUBLIC_API_BASE`

## Before first LIVE order (sandbox checklist)
1. Run an admin sandbox order end-to-end; confirm Lulu's async preflight
   accepts both PDFs (watch print-job status transitions)
2. Confirm the two POD package IDs resolve in Lulu's catalog (constants
   are best-effort from the spec sheet; override via env if needed)
3. Verify at signup: Print API per-order fee (~$1.75?) and sales-tax
   handling
4. Order ONE physical proof copy of the demo family's book before
   enabling for customers — check QR scanability on gloss stock, colors,
   spine alignment

## Print spec notes (embedded in cookbook_print.py)
- 8.75×8.75 page boxes (0.125" bleed), text/QRs ≥0.5" inside trim
- QRs are pure-black vector rects — no CMYK registration blur
- Color minimums: 32pp softcover / 24pp hardcover, even counts (padded
  automatically)
- Fonts are reportlab built-ins (Times/Helvetica) for v1; swapping to
  brand Playfair/Manrope TTFs is a later polish pass
