"""Family Legacy printed cookbook — PDF generation + Lulu Print API client.

The physical payoff of the $99 gift SKU: an 8.5x8.5 heirloom cookbook whose
pages carry QR codes that play the cook's own voice (the public
/listen/{token} pages).

Print spec (Lulu, verified 2026-07):
- Trim 8.5x8.5, bleed 0.125" all sides -> 8.75x8.75 page boxes
- Keep text/QR >= 0.5" inside trim; QR vector, pure black, >= 0.8"
- Color paperback minimum 32 pages, casewrap hardcover 24; even counts
- Two PDFs per job: single-page interior + one-piece wraparound cover
  (spine width comes from Lulu's cover-dimensions API per page count)
"""

import base64
import io
import logging
import os
from datetime import datetime, timezone

import httpx
import qrcode
from reportlab.lib.colors import Color, black, white
from reportlab.lib.units import inch
from reportlab.lib.utils import ImageReader
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfgen import canvas as rl_canvas
from reportlab.platypus import (
    BaseDocTemplate, Flowable, Frame, PageBreak, PageTemplate, Paragraph,
    Spacer,
)

logger = logging.getLogger("cookbook_print")

# ---- fonts --------------------------------------------------------------
# Print services (Lulu preflight) require every font fully embedded.
# ReportLab's base-14 names (Times-*, Helvetica*) are metrics-only and never
# embed, so we ship OFL-licensed TTFs (backend/fonts/) and register them.
# Gelasio is metric-compatible with Georgia, the brand serif.

_FONT_DIR = os.path.join(os.path.dirname(__file__), "fonts")

SERIF = "LT-Serif"
SERIF_BOLD = "LT-Serif-Bold"
SERIF_ITALIC = "LT-Serif-Italic"
SANS = "LT-Sans"
SANS_BOLD = "LT-Sans-Bold"

for _name, _file in [
    (SERIF, "Gelasio-Regular.ttf"),
    (SERIF_BOLD, "Gelasio-Bold.ttf"),
    (SERIF_ITALIC, "Gelasio-Italic.ttf"),
    (SANS, "Inter-Regular.ttf"),
    (SANS_BOLD, "Inter-Bold.ttf"),
]:
    pdfmetrics.registerFont(TTFont(_name, os.path.join(_FONT_DIR, _file)))
pdfmetrics.registerFontFamily(
    SERIF, normal=SERIF, bold=SERIF_BOLD, italic=SERIF_ITALIC,
    boldItalic=SERIF_BOLD)
pdfmetrics.registerFontFamily(SANS, normal=SANS, bold=SANS_BOLD,
                              italic=SANS, boldItalic=SANS_BOLD)


def _embedded_canvas(*args, **kwargs):
    """Canvas factory that never references base-14 Helvetica: ReportLab
    stamps the canvas's initial font into every page's resources (blank
    pages included), which fails print preflight."""
    kwargs.setdefault("initialFontName", SANS)
    return rl_canvas.Canvas(*args, **kwargs)

# ---- geometry ----------------------------------------------------------

TRIM_IN = 8.5
BLEED_IN = 0.125
PAGE_IN = TRIM_IN + 2 * BLEED_IN            # 8.75
SAFETY_IN = 0.5                              # from trim
MARGIN_IN = BLEED_IN + SAFETY_IN             # from page edge
PAGE_SIZE = (PAGE_IN * inch, PAGE_IN * inch)
MIN_PAGES_SOFTCOVER = 32
MIN_PAGES_HARDCOVER = 24

# ---- brand (print-safe approximations of the brand book palette) -------

CREAM = Color(0.973, 0.961, 0.945)           # F8F5F1
INK = Color(0.169, 0.169, 0.169)             # 2B2B2B
INK_SOFT = Color(0.435, 0.435, 0.435)        # 6F6F6F
ORANGE = Color(0.949, 0.420, 0.227)          # F26B3A
SAGE = Color(0.263, 0.431, 0.333)            # 436E55

TITLE_STYLE = ParagraphStyle(
    "title", fontName=SERIF_BOLD, fontSize=26, leading=31, textColor=INK)
AUTHOR_STYLE = ParagraphStyle(
    "author", fontName=SANS, fontSize=10.5, leading=14,
    textColor=INK_SOFT, spaceBefore=4)
STORY_STYLE = ParagraphStyle(
    "story", fontName=SERIF_ITALIC, fontSize=12.5, leading=19,
    textColor=INK, spaceBefore=12)
HEADING_STYLE = ParagraphStyle(
    "heading", fontName=SERIF_BOLD, fontSize=15, leading=19,
    textColor=SAGE, spaceBefore=16, spaceAfter=6)
BODY_STYLE = ParagraphStyle(
    "body", fontName=SANS, fontSize=10.5, leading=16, textColor=INK)
INGREDIENT_STYLE = ParagraphStyle(
    "ingredient", fontName=SANS, fontSize=10.5, leading=16,
    textColor=INK, leftIndent=10)


def _escape(text: str) -> str:
    return (text or "").replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


# ---- flowables ----------------------------------------------------------

class VectorQR(Flowable):
    """Pure-black vector QR code — print-safe (no CMYK registration blur),
    drawn as rects so it stays crisp at any resolution."""

    def __init__(self, url: str, size_in: float = 0.9, caption: str = ""):
        super().__init__()
        self.url = url
        self.size = size_in * inch
        self.caption = caption
        self.caption_h = 14 if caption else 0
        self.width = self.size
        self.height = self.size + self.caption_h

    def draw(self):
        qr = qrcode.QRCode(border=0, error_correction=qrcode.constants.ERROR_CORRECT_M)
        qr.add_data(self.url)
        qr.make(fit=True)
        matrix = qr.get_matrix()
        n = len(matrix)
        module = self.size / n
        c = self.canv
        c.saveState()
        c.setFillColor(white)
        c.rect(0, self.caption_h, self.size, self.size, fill=1, stroke=0)
        c.setFillColor(black)
        for y, row in enumerate(matrix):
            for x, cell in enumerate(row):
                if cell:
                    c.rect(x * module,
                           self.caption_h + self.size - (y + 1) * module,
                           module, module, fill=1, stroke=0)
        if self.caption:
            c.setFillColor(INK_SOFT)
            c.setFont(SANS, 8)
            c.drawString(0, 2, self.caption)
        c.restoreState()


class RecipePhoto(Flowable):
    """First recipe photo, letterboxed to a fixed height, from base64."""

    def __init__(self, photo_b64: str, max_w: float, height_in: float = 2.6):
        super().__init__()
        raw = photo_b64.split(",", 1)[1] if photo_b64.startswith("data:") else photo_b64
        self._reader = ImageReader(io.BytesIO(base64.b64decode(raw)))
        iw, ih = self._reader.getSize()
        self.height = height_in * inch
        self.width = min(max_w, iw * (self.height / ih))

    def draw(self):
        self.canv.drawImage(
            self._reader, 0, 0, width=self.width, height=self.height,
            preserveAspectRatio=True, anchor="sw", mask="auto")


# ---- interior -----------------------------------------------------------

def _page_background(canvas, _doc):
    canvas.saveState()
    canvas.setFillColor(CREAM)
    canvas.rect(0, 0, PAGE_SIZE[0], PAGE_SIZE[1], fill=1, stroke=0)
    canvas.restoreState()


class _CountingDoc(BaseDocTemplate):
    pass


def generate_interior_pdf(family: dict, recipes: list, listen_base_url: str,
                          hardcover: bool = True) -> tuple[bytes, int]:
    """Build the interior. Returns (pdf_bytes, page_count) with page-count
    rules (even count, binding minimum) already satisfied via trailing
    blanks — the count feeds Lulu's cover-dimensions API."""

    def build(extra_blank_pages: int) -> tuple[bytes, int]:
        buf = io.BytesIO()
        doc = _CountingDoc(buf, pagesize=PAGE_SIZE,
                           leftMargin=MARGIN_IN * inch, rightMargin=MARGIN_IN * inch,
                           topMargin=MARGIN_IN * inch, bottomMargin=MARGIN_IN * inch,
                           initialFontName=SANS)
        frame = Frame(MARGIN_IN * inch, MARGIN_IN * inch,
                      PAGE_SIZE[0] - 2 * MARGIN_IN * inch,
                      PAGE_SIZE[1] - 2 * MARGIN_IN * inch, id="main")
        doc.addPageTemplates([PageTemplate(id="page", frames=[frame],
                                           onPage=_page_background)])
        content_w = PAGE_SIZE[0] - 2 * MARGIN_IN * inch

        story = []

        # Title page
        family_name = _escape(family.get("name") or "Our Family")
        story.append(Spacer(1, 2.2 * inch))
        story.append(Paragraph(family_name, ParagraphStyle(
            "cover_t", parent=TITLE_STYLE, fontSize=34, leading=40,
            alignment=1)))
        story.append(Spacer(1, 0.3 * inch))
        story.append(Paragraph("Recipes, stories, and the voices that taught us",
                               ParagraphStyle("cover_s", parent=AUTHOR_STYLE,
                                              fontSize=13, leading=18, alignment=1)))
        story.append(Spacer(1, 2.6 * inch))
        story.append(Paragraph(
            f"A Legacy Table heirloom · {datetime.now(timezone.utc).year}",
            ParagraphStyle("cover_f", parent=AUTHOR_STYLE, alignment=1)))
        story.append(PageBreak())

        # Recipes
        for r in recipes:
            story.append(Paragraph(_escape(r.get("title", "Untitled")), TITLE_STYLE))
            if r.get("author_name"):
                story.append(Paragraph(
                    f"as told by {_escape(r['author_name'])}", AUTHOR_STYLE))

            photos = r.get("photos") or []
            if photos:
                try:
                    story.append(Spacer(1, 10))
                    story.append(RecipePhoto(photos[0], content_w))
                except Exception:
                    logger.warning("Skipping unreadable photo on %s", r.get("id"))

            if r.get("story"):
                story.append(Paragraph(f"“{_escape(r['story'])}”", STORY_STYLE))

            if r.get("voice_token"):
                story.append(Spacer(1, 12))
                story.append(VectorQR(
                    f"{listen_base_url}/listen/{r['voice_token']}",
                    caption=f"Scan to hear {r.get('author_name') or 'them'} tell it"))

            story.append(Paragraph("Ingredients", HEADING_STYLE))
            for ing in r.get("ingredients", []):
                story.append(Paragraph(f"·&nbsp;&nbsp;{_escape(ing)}", INGREDIENT_STYLE))

            story.append(Paragraph("The way it's made", HEADING_STYLE))
            story.append(Paragraph(_escape(r.get("instructions", "")), BODY_STYLE))
            story.append(PageBreak())

        # Colophon
        story.append(Spacer(1, 3.6 * inch))
        story.append(Paragraph(
            "Made with Legacy Table — where recipes become heirlooms.<br/>legacytable.app",
            ParagraphStyle("colophon", parent=AUTHOR_STYLE, alignment=1)))

        for _ in range(extra_blank_pages):
            story.append(PageBreak())
            story.append(Spacer(1, 1))

        doc.build(story, canvasmaker=_embedded_canvas)
        return buf.getvalue(), doc.page

    pdf, pages = build(0)
    minimum = MIN_PAGES_HARDCOVER if hardcover else MIN_PAGES_SOFTCOVER
    target = max(pages, minimum)
    if target % 2:
        target += 1
    if target != pages:
        pdf, pages = build(target - pages)
    return pdf, pages


# ---- cover --------------------------------------------------------------

def generate_cover_pdf(family: dict, cover_width_pt: float,
                       cover_height_pt: float, spine_width_pt: float) -> bytes:
    """One-piece wraparound: back + spine + front. Dimensions (incl. bleed
    and spine) come from Lulu's cover-dimensions API — never hardcoded."""
    buf = io.BytesIO()
    c = _embedded_canvas(buf, pagesize=(cover_width_pt, cover_height_pt))

    # Full-bleed cream, sage band across the bottom
    c.setFillColor(CREAM)
    c.rect(0, 0, cover_width_pt, cover_height_pt, fill=1, stroke=0)
    c.setFillColor(SAGE)
    c.rect(0, 0, cover_width_pt, cover_height_pt * 0.18, fill=1, stroke=0)

    panel_w = (cover_width_pt - spine_width_pt) / 2
    front_cx = panel_w + spine_width_pt + panel_w / 2
    back_cx = panel_w / 2
    family_name = family.get("name") or "Our Family"

    # Front
    c.setFillColor(INK)
    c.setFont(SERIF_BOLD, 30)
    c.drawCentredString(front_cx, cover_height_pt * 0.58, family_name)
    c.setFont(SERIF_ITALIC, 14)
    c.setFillColor(INK_SOFT)
    c.drawCentredString(front_cx, cover_height_pt * 0.52,
                        "Recipes, stories, and the voices that taught us")
    c.setFillColor(ORANGE)
    c.setFont(SANS_BOLD, 10)
    c.drawCentredString(front_cx, cover_height_pt * 0.09, "LEGACY TABLE")

    # Back
    c.setFillColor(INK_SOFT)
    c.setFont(SERIF_ITALIC, 12)
    c.drawCentredString(back_cx, cover_height_pt * 0.55,
                        "Some recipes only one person knows how to make.")
    c.drawCentredString(back_cx, cover_height_pt * 0.51,
                        "Now the whole family does — in their own voice.")
    c.setFillColor(white)
    c.setFont(SANS, 9)
    c.drawCentredString(back_cx, cover_height_pt * 0.08, "legacytable.app")

    # Spine (only if thick enough for text)
    if spine_width_pt >= 18:
        c.saveState()
        c.translate(panel_w + spine_width_pt / 2, cover_height_pt / 2)
        c.rotate(90)
        c.setFillColor(INK)
        c.setFont(SERIF_BOLD, min(14, spine_width_pt * 0.5))
        c.drawCentredString(0, -spine_width_pt * 0.18, family_name)
        c.restoreState()

    c.showPage()
    c.save()
    return buf.getvalue()


# ---- Lulu client --------------------------------------------------------

LULU_BASE = "https://api.lulu.com"
LULU_SANDBOX_BASE = "https://api.sandbox.lulu.com"

# 8.5x8.5, full color STANDARD quality, 80# coated white, gloss finish.
# Dot-separated SKU format confirmed from Lulu's OpenAPI spec examples
# (e.g. 0550X0850.FC.PRE.PB.080CW444.GXX). CW = casewrap hardcover,
# PB = perfect-bound paperback. Validate in sandbox before first live
# order; override via env if needed.
POD_PACKAGE_HARDCOVER = os.environ.get(
    "LULU_POD_HARDCOVER", "0850X0850.FC.STD.CW.080CW444.GXX")
POD_PACKAGE_SOFTCOVER = os.environ.get(
    "LULU_POD_SOFTCOVER", "0850X0850.FC.STD.PB.080CW444.GXX")


def _lulu_base() -> str:
    use_sandbox = os.environ.get("LULU_USE_SANDBOX", "true").lower() != "false"
    return LULU_SANDBOX_BASE if use_sandbox else LULU_BASE


async def lulu_token(client: httpx.AsyncClient) -> str:
    key = os.environ.get("LULU_CLIENT_KEY", "")
    secret = os.environ.get("LULU_CLIENT_SECRET", "")
    if not key or not secret:
        raise RuntimeError("Lulu credentials not configured")
    resp = await client.post(
        f"{_lulu_base()}/auth/realms/glasstree/protocol/openid-connect/token",
        data={"grant_type": "client_credentials"},
        auth=(key, secret))
    resp.raise_for_status()
    return resp.json()["access_token"]


def _derive_spine_pt(cover_width_pt: float, hardcover: bool) -> float:
    """Lulu's cover-dimensions response gives only total width/height (per
    the OpenAPI spec) — derive the spine. Total width = 2 panels + spine,
    where a panel is trim + bleed (paperback) or trim + wrap allowance
    (casewrap, ~0.75\"). Approximation is fine: it only positions cover
    text; the physical proof copy is the final validator."""
    panel_extra_in = 0.75 if hardcover else BLEED_IN
    panel_pt = (TRIM_IN + panel_extra_in) * 72
    return max(0.0, cover_width_pt - 2 * panel_pt)


async def lulu_cover_dimensions(pod_package_id: str, page_count: int,
                                hardcover: bool = True) -> dict:
    """Returns {width, height, spine_width} in points for the wraparound
    cover at this page count. width/height come from Lulu (strings in the
    response, per spec); spine is derived."""
    async with httpx.AsyncClient(timeout=30) as client:
        token = await lulu_token(client)
        resp = await client.post(
            f"{_lulu_base()}/cover-dimensions/",
            headers={"Authorization": f"Bearer {token}"},
            json={"pod_package_id": pod_package_id,
                  "interior_page_count": page_count,
                  "unit": "pt"})
        if resp.status_code >= 400:
            logger.error("Lulu cover-dimensions %d: %s",
                         resp.status_code, resp.text[:500])
        resp.raise_for_status()
        data = resp.json()
        width = float(data["width"])
        height = float(data["height"])
        return {
            "width": width,
            "height": height,
            "spine_width": _derive_spine_pt(width, hardcover),
            "unit": "pt",
        }


async def lulu_create_print_job(*, pod_package_id: str, page_count: int,
                                interior_url: str, cover_url: str,
                                shipping: dict, external_id: str,
                                shipping_level: str = "GROUND") -> dict:
    """Create the print job. Lulu fetches both PDFs from our artifact URLs."""
    payload = {
        "external_id": external_id,
        "contact_email": os.environ.get(
            "LULU_CONTACT_EMAIL", "contact@ubuntu-markets.org"),
        "line_items": [{
            "external_id": f"{external_id}-book",
            "title": "Family Legacy heirloom cookbook",
            "quantity": 1,
            "printable_normalization": {
                "pod_package_id": pod_package_id,
                "interior": {"source_url": interior_url},
                "cover": {"source_url": cover_url},
            },
        }],
        "shipping_address": shipping,
        "shipping_level": shipping_level,
    }
    async with httpx.AsyncClient(timeout=60) as client:
        token = await lulu_token(client)
        resp = await client.post(
            f"{_lulu_base()}/print-jobs/",
            headers={"Authorization": f"Bearer {token}"},
            json=payload)
        if resp.status_code >= 400:
            logger.error("Lulu print-jobs %d: %s",
                         resp.status_code, resp.text[:500])
        resp.raise_for_status()
        return resp.json()


async def lulu_print_job_status(job_id: str) -> dict:
    async with httpx.AsyncClient(timeout=30) as client:
        token = await lulu_token(client)
        resp = await client.get(
            f"{_lulu_base()}/print-jobs/{job_id}/",
            headers={"Authorization": f"Bearer {token}"})
        resp.raise_for_status()
        return resp.json()
