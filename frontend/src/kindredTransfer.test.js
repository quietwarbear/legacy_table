const fs = require("fs");
const path = require("path");

const transport = fs.readFileSync(path.join(__dirname, "lib/kindredTransfer.js"), "utf8");
const landing = fs.readFileSync(path.join(__dirname, "components/KindredRecipeImportLanding.jsx"), "utf8");

test("Kindred grant transport is header-only and omits ambient credentials", () => {
  expect(transport).toContain('"X-Kindred-Transfer": grant');
  expect(transport).toContain('credentials: "omit"');
  expect(transport).toContain('redirect: "error"');
  expect(transport).toContain('referrerPolicy: "no-referrer"');
  expect(transport).not.toMatch(/searchParams.*grant|\/transfer\/\$\{grant\}|\?transfer=/);
  expect(transport).not.toMatch(/localStorage|sessionStorage|indexedDB|caches\./);
});

test("destination reconciliation precedes POST and uses the original operation", () => {
  expect(landing.indexOf("let result = await reconcile()"))
    .toBeLessThan(landing.indexOf("axios.post(`${API}/recipe-imports`"));
  expect(landing).toContain("encodeURIComponent(payload.operation_id)");
  expect(landing).not.toMatch(/randomUUID|crypto\.random|operation_id\s*=\s*/);
  expect(landing).toContain("familyConfirmed");
});
