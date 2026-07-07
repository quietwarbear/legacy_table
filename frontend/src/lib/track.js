import posthog from "posthog-js";

// Analytics wrappers so components never touch window/posthog directly.
// - GA4 + Google Ads tags load in public/index.html; gtag calls no-op when
//   absent (ad blockers, tests, local dev).
// - PostHog: shared Ubuntu Markets project (EU), events tagged
//   product: legacy_table_web. phc_ tokens are public client-side tokens —
//   same one the mobile app ships (mobile tags itself via $app_name).

const POSTHOG_KEY = "phc_m3uewVirngKNvpwdZ6DYkwMaWXjCscBf5iPwCSpJGm68";
const POSTHOG_HOST = "https://eu.i.posthog.com";

export function initAnalytics() {
  posthog.init(POSTHOG_KEY, {
    api_host: POSTHOG_HOST,
    capture_pageview: true,
    autocapture: true,
  });
  posthog.register({ product: "legacy_table_web" });
}

// Tie events to the backend user id (never email as the identifier).
export function identifyUser(user) {
  if (!user?.id) return;
  posthog.identify(String(user.id));
}

// Clear identity on logout so the next login isn't merged.
export function resetAnalytics() {
  posthog.reset();
}

export function trackEvent(name, params = {}) {
  if (typeof window !== "undefined" && typeof window.gtag === "function") {
    window.gtag("event", name, params);
  }
  posthog.capture(name, params);
}

// The single most important web metric: clicks through to the app stores.
// placement: "hero" | "footer_cta" | "pricing" | "invite"
export function trackStoreClick(store, placement) {
  trackEvent("store_badge_click", { store, placement });
}
