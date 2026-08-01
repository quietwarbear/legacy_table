const crypto = require("crypto");
const fs = require("fs");
const http = require("http");
const path = require("path");
const puppeteer = require("puppeteer-core");

const BUILD = path.resolve(__dirname, "..", "build");
const PORT = Number(process.env.LEGACY_TABLE_SSO_TEST_PORT || 43127);
const ORIGIN = `http://127.0.0.1:${PORT}`;

function serveBuild() {
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      const pathname = new URL(req.url, ORIGIN).pathname;
      if (pathname === "/api/auth/sso-redeem" && req.method === "POST") {
        let body = "";
        req.on("data", (chunk) => { body += chunk; });
        req.on("end", () => {
          const parsed = JSON.parse(body);
          if (parsed.audience !== "legacy_table" || parsed.origin !== ORIGIN) {
            res.writeHead(400, { "Content-Type": "application/json", "Cache-Control": "no-store" });
            res.end(JSON.stringify({ detail: "invalid" }));
            return;
          }
          res.writeHead(200, { "Content-Type": "application/json", "Cache-Control": "no-store" });
          res.end(JSON.stringify({
            token: "synthetic-session-value",
            user: {
              id: "synthetic-browser-user",
              name: "Synthetic User",
              email: "synthetic-browser@example.invalid",
              credits_balance: 0,
              created_at: "2026-01-01T00:00:00+00:00",
            },
          }));
        });
        return;
      }
      if (pathname.startsWith("/api/")) {
        res.writeHead(200, { "Content-Type": "application/json", "Cache-Control": "no-store" });
        res.end(JSON.stringify({ subscription_tier: null, credits_balance: 0 }));
        return;
      }
      let file = path.join(BUILD, pathname);
      if (!fs.existsSync(file) || fs.statSync(file).isDirectory()) file = path.join(BUILD, "index.html");
      const extension = path.extname(file);
      const type = extension === ".js" ? "text/javascript" : extension === ".css" ? "text/css" : "text/html";
      res.writeHead(200, {
        "Content-Type": type,
        "Cache-Control": pathname === "/sso" ? "no-store" : "public, max-age=60",
        "Referrer-Policy": "no-referrer",
      });
      fs.createReadStream(file).pipe(res);
    });
    server.listen(PORT, "127.0.0.1", () => resolve(server));
  });
}

(async () => {
  const code = crypto.randomBytes(32).toString("base64url");
  const server = await serveBuild();
  let browser;
  try {
    browser = await puppeteer.launch({ channel: "chrome", headless: true });
    const page = await browser.newPage();
    const externalRequests = [];
    const observedRequests = [];
    await page.setRequestInterception(true);
    page.on("request", (request) => {
      const url = request.url();
      observedRequests.push({
        url,
        postData: request.postData() || "",
        referrer: request.headers().referer || "",
        type: request.resourceType(),
      });
      if (new URL(url).origin !== ORIGIN) {
        externalRequests.push({ url, type: request.resourceType() });
        request.abort();
      } else {
        request.continue();
      }
    });

    await page.goto(`${ORIGIN}/sso?code=${encodeURIComponent(code)}`, {
      waitUntil: "domcontentloaded",
      timeout: 30_000,
    });
    await page.waitForFunction(() => window.location.pathname === "/home", { timeout: 30_000 });

    const state = await page.evaluate(async () => {
      const local = Object.fromEntries(Object.keys(localStorage).map((key) => [key, localStorage.getItem(key)]));
      const session = Object.fromEntries(Object.keys(sessionStorage).map((key) => [key, sessionStorage.getItem(key)]));
      const databases = indexedDB.databases ? await indexedDB.databases() : [];
      const cacheKeys = "caches" in window ? await caches.keys() : [];
      const registrations = "serviceWorker" in navigator ? await navigator.serviceWorker.getRegistrations() : [];
      return {
        href: window.location.href,
        referrer: document.referrer,
        local,
        session,
        databaseNames: databases.map((entry) => entry.name),
        cacheKeys,
        serviceWorkerCount: registrations.length,
        transientCodePresent: Object.prototype.hasOwnProperty.call(window, "__legacyTableTransientSSOCode"),
      };
    });

    const serializedState = JSON.stringify(state);
    if (state.href.includes("code=") || state.href.includes(code)) throw new Error("authorization code remained in URL");
    if (state.referrer.includes(code)) throw new Error("authorization code reached document referrer");
    if (serializedState.includes(code)) throw new Error("authorization code reached browser storage");
    if (state.transientCodePresent) throw new Error("transient authorization code was not destroyed");
    if (state.serviceWorkerCount !== 0) throw new Error("SSO page registered a service worker");
    if (observedRequests.some((entry) => entry.referrer.includes(code))) throw new Error("authorization code reached a request referrer");
    if (observedRequests.some((entry) => entry.url.includes(code) && !entry.url.startsWith(`${ORIGIN}/sso?`))) {
      throw new Error("authorization code reached a secondary URL");
    }
    if (externalRequests.some((entry) => ["script", "xhr", "fetch", "beacon"].includes(entry.type))) {
      throw new Error("third-party executable or telemetry request attempted on SSO page");
    }
    const redemption = observedRequests.filter((entry) => entry.url === `${ORIGIN}/api/auth/sso-redeem`);
    if (redemption.length !== 1 || !redemption[0].postData.includes(code)) {
      throw new Error("authorization code was not redeemed exactly once in the request body");
    }
    process.stdout.write("Built SSO isolation campaign passed\n");
  } finally {
    if (browser) await browser.close();
    server.close();
  }
})().catch((error) => {
  process.stderr.write(`Built SSO isolation campaign failed: ${error.message}\n`);
  process.exit(1);
});
