const crypto = require("crypto");
const fs = require("fs");
const http = require("http");
const path = require("path");
const puppeteer = require("puppeteer-core");

const BUILD = path.resolve(__dirname, "..", "build");
const LEGACY_PORT = Number(process.env.LEGACY_TABLE_IMPORT_TEST_PORT || 43127);
const KINDRED_PORT = Number(process.env.KINDRED_TRANSFER_TEST_PORT || 43128);
const LEGACY_ORIGIN = `http://127.0.0.1:${LEGACY_PORT}`;
const KINDRED_ORIGIN = `http://127.0.0.1:${KINDRED_PORT}`;

function json(res, status, body, extra = {}) {
  res.writeHead(status, { "Content-Type": "application/json", "Cache-Control": "no-store", ...extra });
  res.end(JSON.stringify(body));
}

function serveLegacy(code, operation, receipt) {
  let accepted = false;
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      const pathname = new URL(req.url, LEGACY_ORIGIN).pathname;
      if (pathname === "/api/auth/sso-redeem" && req.method === "POST") {
        let body = "";
        req.on("data", (chunk) => { body += chunk; });
        req.on("end", () => {
          const parsed = JSON.parse(body);
          if (parsed.code !== code) return json(res, 400, { detail: "invalid" });
          return json(res, 200, { token: "synthetic-session", user: { id: "synthetic-user", family_id: "synthetic-family", created_at: "2026-01-01T00:00:00Z" } });
        });
        return;
      }
      if (pathname === `/api/recipe-imports/${operation}` && req.method === "GET") {
        return accepted
          ? json(res, 200, { operation_id: operation, status: "accepted", receipt_reference: receipt, family_behavior: "existing_family" })
          : json(res, 404, { operation_id: operation, status: "rejected", error_code: "import_operation_not_found" });
      }
      if (pathname === "/api/recipe-imports" && req.method === "POST") {
        accepted = true;
        return json(res, 201, { operation_id: operation, status: "accepted", receipt_reference: receipt, family_behavior: "existing_family" });
      }
      if (pathname.startsWith("/api/")) return json(res, 200, {});
      let file = path.join(BUILD, pathname);
      if (!fs.existsSync(file) || fs.statSync(file).isDirectory()) file = path.join(BUILD, "index.html");
      const ext = path.extname(file);
      res.writeHead(200, { "Content-Type": ext === ".js" ? "text/javascript" : ext === ".css" ? "text/css" : "text/html", "Cache-Control": "no-store", "Referrer-Policy": "no-referrer" });
      fs.createReadStream(file).pipe(res);
    });
    server.listen(LEGACY_PORT, "127.0.0.1", () => resolve(server));
  });
}

function serveKindred(grant, operation, revision, receipt) {
  return new Promise((resolve) => {
    const server = http.createServer((req, res) => {
      const cors = { "Access-Control-Allow-Origin": LEGACY_ORIGIN, "Access-Control-Allow-Headers": "Content-Type, X-Kindred-Transfer", "Access-Control-Allow-Methods": "POST, OPTIONS" };
      if (req.method === "OPTIONS") return json(res, 204, {}, cors);
      if (req.headers["x-kindred-transfer"] !== grant) return json(res, 404, { status: "unavailable", error_code: "transfer_not_found" }, cors);
      if (req.url === "/api/legacy-table/transfer-payload") {
        return json(res, 200, { source: "kindred", operation_id: operation, source_subject_reference: "krs_synthetic_subject_reference", source_revision_digest: revision, consent_version: "kindred_recipe_import_v1", title: "Synthetic holiday dish", instructions_or_story: "Synthetic preparation notes only.", category: "Other" }, cors);
      }
      if (req.url === "/api/legacy-table/transfer-acknowledgement") {
        return json(res, 200, { operation_id: operation, status: "completed", receipt_reference: receipt }, cors);
      }
      return json(res, 404, {}, cors);
    });
    server.listen(KINDRED_PORT, "127.0.0.1", () => resolve(server));
  });
}

(async () => {
  const code = crypto.randomBytes(32).toString("base64url");
  const grant = crypto.randomBytes(48).toString("base64url");
  const operation = `ltop_${crypto.randomBytes(24).toString("base64url")}`;
  const revision = crypto.createHash("sha256").update("synthetic-revision").digest("hex");
  const receipt = `ltr_${crypto.randomBytes(24).toString("base64url")}`;
  const [legacy, kindred] = await Promise.all([serveLegacy(code, operation, receipt), serveKindred(grant, operation, revision, receipt)]);
  let browser;
  try {
    browser = await puppeteer.launch({ channel: "chrome", headless: true });
    const page = await browser.newPage();
    const observed = [];
    const external = [];
    await page.setRequestInterception(true);
    page.on("request", (request) => {
      const item = { url: request.url(), type: request.resourceType(), referrer: request.headers().referer || "", postData: request.postData() || "" };
      observed.push(item);
      const origin = new URL(item.url).origin;
      if (![LEGACY_ORIGIN, KINDRED_ORIGIN].includes(origin)) { external.push(item); request.abort(); } else request.continue();
    });
    await page.goto(`${LEGACY_ORIGIN}/sso?code=${code}#transfer=${grant}`, { waitUntil: "domcontentloaded", timeout: 30000 });
    await page.waitForSelector('[data-testid="kindred-import-family-confirm"]');
    await page.click('[data-testid="kindred-import-family-confirm"]');
    await page.click('[data-testid="kindred-import-submit"]');
    await page.waitForSelector('[data-testid="kindred-import-complete"]');
    const state = await page.evaluate(async () => ({
      href: location.href,
      referrer: document.referrer,
      local: { ...localStorage },
      session: { ...sessionStorage },
      databases: indexedDB.databases ? await indexedDB.databases() : [],
      caches: "caches" in window ? await caches.keys() : [],
      registrations: "serviceWorker" in navigator ? (await navigator.serviceWorker.getRegistrations()).length : 0,
      globals: ["__legacyTableTransientSSOCode", "__legacyTableTransientTransferCredential"].filter((key) => Object.prototype.hasOwnProperty.call(window, key)),
    }));
    const stateText = JSON.stringify(state);
    if (state.href !== `${LEGACY_ORIGIN}/sso` || state.referrer.includes(code) || state.referrer.includes(grant)) throw new Error("sensitive navigation state remained");
    if (stateText.includes(code) || stateText.includes(grant)) throw new Error("handoff credential reached browser storage");
    if (state.globals.length || state.caches.length || state.registrations) throw new Error("sensitive document retained browser artifacts");
    if (external.some((item) => ["script", "xhr", "fetch", "beacon"].includes(item.type))) throw new Error("third-party request attempted");
    if (observed.some((item) => (item.url.includes(code) || item.url.includes(grant)) && !item.url.startsWith(`${LEGACY_ORIGIN}/sso?`))) throw new Error("credential reached secondary URL");
    if (observed.some((item) => item.referrer.includes(code) || item.referrer.includes(grant) || item.postData.includes(grant))) throw new Error("credential reached referrer or request body");
    const grantRequests = observed.filter((item) => item.url.startsWith(`${KINDRED_ORIGIN}/api/legacy-table/`));
    if (grantRequests.length < 2) throw new Error("header-only Kindred bridge was not exercised");
    process.stdout.write("Built Kindred import isolation campaign passed\n");
  } finally {
    if (browser) await browser.close();
    legacy.close();
    kindred.close();
  }
})().catch((error) => { process.stderr.write(`Built Kindred import isolation campaign failed: ${error.message}\n`); process.exit(1); });
