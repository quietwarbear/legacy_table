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

// Meta is the one sender the backend cannot feed: GA4 gets conversions
// server-side, Meta only ever learns from the browser.
describe("Meta Pixel forwarding", () => {
  beforeEach(() => {
    jest.clearAllMocks();
    window.gtag = jest.fn();
    window.fbq = jest.fn();
    delete window.__legacyTableSensitiveSSORoute;
  });

  it.each([
    ["signup", "CompleteRegistration"],
    ["begin_checkout", "InitiateCheckout"],
    ["purchase", "Purchase"],
  ])("%s is forwarded to Meta as %s", (product, standard) => {
    trackProductEvent(product, { surface: "web" });
    expect(window.fbq).toHaveBeenCalledWith("track", standard, { surface: "web" });
  });

  it.each([
    ["gift_checkout_started", "InitiateCheckout"],
    ["gift_purchased", "Purchase"],
  ])("gift flow: %s is forwarded as %s", (name, standard) => {
    trackEvent(name, {});
    expect(window.fbq).toHaveBeenCalledWith("track", standard, {});
  });

  it("events with no Meta equivalent are not sent to Meta", () => {
    trackEvent("store_badge_click", { store: "apple" });
    trackProductEvent("recipe_saved", {});
    expect(window.fbq).not.toHaveBeenCalled();
  });

  it("a suppressed SSO route reaches Meta no more than the others", () => {
    window.__legacyTableSensitiveSSORoute = true;
    trackProductEvent("purchase", { surface: "web" });
    expect(window.fbq).not.toHaveBeenCalled();
  });

  it("no Pixel on the page is a no-op, not a crash", () => {
    delete window.fbq;
    expect(() => trackProductEvent("purchase", { surface: "web" })).not.toThrow();
  });
});
