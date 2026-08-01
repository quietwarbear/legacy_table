const fs = require("fs");
const path = require("path");

const publicIndex = fs.readFileSync(path.join(__dirname, "../public/index.html"), "utf8");
const appSource = fs.readFileSync(path.join(__dirname, "App.js"), "utf8");
const entrySource = fs.readFileSync(path.join(__dirname, "index.js"), "utf8");
const vercel = JSON.parse(fs.readFileSync(path.join(__dirname, "../vercel.json"), "utf8"));

test("SSO bootstrap scrubs the query before third-party initialization", () => {
  const scrub = publicIndex.indexOf('window.history.replaceState(null, "", "/sso")');
  expect(scrub).toBeGreaterThan(0);
  expect(scrub).toBeLessThan(publicIndex.indexOf("cdn-cookieyes.com"));
  expect(scrub).toBeLessThan(publicIndex.indexOf("googletagmanager.com"));
  expect(publicIndex).toContain("__legacyTableSensitiveSSORoute");
  expect(publicIndex).toContain('<meta name="referrer" content="no-referrer" />');
});

test("application analytics stays disabled for the SSO document", () => {
  expect(entrySource).toContain("!window.__legacyTableSensitiveSSORoute");
  expect(entrySource).toContain("localhost|127");
  expect(entrySource).toContain("initAnalytics()");
});

test("SSO redemption uses transient memory and exact audience and origin", () => {
  expect(appSource).toContain("window.__legacyTableTransientSSOCode");
  expect(appSource).toContain("delete window.__legacyTableTransientSSOCode");
  expect(appSource).not.toContain('new URLSearchParams(window.location.search).get("code")');
  expect(appSource).toContain('audience: "legacy_table"');
  expect(appSource).toContain("origin: window.location.origin");
});

test("Vercel marks the SSO landing no-store, no-referrer, and noindex", () => {
  const sso = vercel.headers.find((entry) => entry.source === "/sso");
  expect(sso).toBeDefined();
  expect(sso.headers).toEqual(expect.arrayContaining([
    { key: "Cache-Control", value: "no-store, max-age=0" },
    { key: "Referrer-Policy", value: "no-referrer" },
    { key: "X-Robots-Tag", value: "noindex, nofollow, noarchive" },
  ]));
});
