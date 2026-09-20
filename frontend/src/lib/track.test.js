// Guards the one rule that is easy to break by accident: conversions the
// BACKEND already reports to GA4 must not also be sent from the browser, or
// every sale counts twice in GA4 revenue.
import posthog from "posthog-js";
import { trackEvent, trackProductEvent } from "./track";

jest.mock("posthog-js", () => ({
  __esModule: true,
  default: { init: jest.fn(), capture: jest.fn(), identify: jest.fn(), reset: jest.fn(), register: jest.fn() },
}));

describe("analytics wrappers", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    window.gtag = jest.fn();
    delete window.__legacyTableSensitiveSSORoute;
  });

  it("trackProductEvent reaches PostHog only, never gtag", () => {
    trackProductEvent("purchase", { surface: "web" });
    expect(posthog.capture).toHaveBeenCalledWith("purchase", { surface: "web" });
    expect(window.gtag).not.toHaveBeenCalled();
  });

  it("trackEvent still reaches both, for events the backend does not send", () => {
    trackEvent("store_badge_click", { store: "apple" });
    expect(posthog.capture).toHaveBeenCalledWith("store_badge_click", { store: "apple" });
    expect(window.gtag).toHaveBeenCalledWith("event", "store_badge_click", { store: "apple" });
  });

  it("a suppressed SSO route is not identified by either sender", () => {
    window.__legacyTableSensitiveSSORoute = true;
    trackProductEvent("signup", { method: "email" });
    trackEvent("store_badge_click", {});
    expect(posthog.capture).not.toHaveBeenCalled();
    expect(window.gtag).not.toHaveBeenCalled();
  });
});
