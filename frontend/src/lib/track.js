import posthog from "posthog-js";

// Analytics wrappers so components never touch window/posthog directly.
// - GA4 + Google Ads tags load in public/index.html; gtag calls no-op when
//   absent (ad blockers, tests, local dev).
// - PostHog: shared Ubuntu Markets project (EU), events tagged
//   product: legacy_table_web. phc_ tokens are public client-side tokens —
//   same one the mobile app ships (mobile tags itself via $app_name).

const POSTHOG_KEY = "phc_m3uewVirngKNvpwdZ6DYkwMaWXjCscBf5iPwCSpJGm68";
const POSTHOG_HOST = "https://eu.i.posthog.com";

const analyticsSuppressed = () =>
  typeof window !== "undefined" && window.__legacyTableSensitiveSSORoute;

export function initAnalytics() {
  if (analyticsSuppressed()) return;
  posthog.init(POSTHOG_KEY, {
    api_host: POSTHOG_HOST,
    capture_pageview: true,
    autocapture: true,
  });
  posthog.register({ product: "legacy_table_web" });
}

// Tie events to the backend user id (never email as the identifier).
export function identifyUser(user) {
  if (analyticsSuppressed() || !user?.id) return;
  posthog.identify(String(user.id));
}

// Clear identity on logout so the next login isn't merged.
export function resetAnalytics() {
  if (analyticsSuppressed()) return;
  posthog.reset();
}

// PostHog only. For conversions the BACKEND already reports to GA4
// (sign_up on register, begin_checkout on checkout creation, purchase in the
// Stripe and RevenueCat webhooks), firing them from the browser too would
// double-count the same conversion in GA4. PostHog has no server-side sender,
// so these are the only way those steps appear in the product funnel at all.
export function trackProductEvent(name, params = {}) {
  if (analyticsSuppressed()) return;
  posthog.capture(name, params);
}

export function trackEvent(name, params = {}) {
  if (analyticsSuppressed()) return;
  if (typeof window !== "undefined" && typeof window.gtag === "function") {
    window.gtag("event", name, params);
  }
  posthog.capture(name, params);
}

// The GA4 browser client id, for the backend to attach to server-side
// conversions (signup, checkout, purchase). Those fire from webhooks, long
// after the tab may be gone; handing the backend this id is what makes a
// purchase land in the same GA4 session — and so the same campaign — as the
// click that produced it. Without it the sale still counts, but it opens its
// own session and the ad that earned it gets no credit.
//
// Read straight from the `_ga` cookie rather than gtag('get'), which is async
// and races the first form submit. The backend trims the GA1.1. prefix.
// Returns "" when the tag never loaded (ad blocker, local dev) or on a
// suppressed SSO route — the backend falls back to a synthetic id.
export function gaClientId() {
  if (analyticsSuppressed()) return "";
  if (typeof document === "undefined") return "";
  const match = document.cookie.match(/(?:^|;\s*)_ga=([^;]+)/);
  return match ? decodeURIComponent(match[1]) : "";
}

// The single most important web metric: clicks through to the app stores.
// placement: "hero" | "footer_cta" | "pricing" | "invite"
export function trackStoreClick(store, placement) {
  trackEvent("store_badge_click", { store, placement });
}
