// Thin wrapper over gtag so components never touch window directly.
// GA4 + Google Ads tags are loaded in public/index.html; this no-ops when
// gtag is absent (ad blockers, tests, local dev).

export function trackEvent(name, params = {}) {
  if (typeof window !== "undefined" && typeof window.gtag === "function") {
    window.gtag("event", name, params);
  }
}

// The single most important web metric: clicks through to the app stores.
// placement: "hero" | "footer_cta" | "pricing" | "invite"
export function trackStoreClick(store, placement) {
  trackEvent("store_badge_click", { store, placement });
}
