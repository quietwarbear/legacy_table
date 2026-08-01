const PRODUCTION_KINDRED_ORIGINS = new Set([
  "https://kindred-production-badd.up.railway.app",
]);

export const kindredApiOrigin = () => {
  const configured = (process.env.REACT_APP_KINDRED_API_ORIGIN || "https://kindred-production-badd.up.railway.app").trim();
  let parsed;
  try {
    parsed = new URL(configured);
  } catch {
    throw new Error("transfer_configuration_unavailable");
  }
  const localPage = /^(?:localhost|127\.0\.0\.1)$/i.test(window.location.hostname);
  const localTarget = /^(?:localhost|127\.0\.0\.1)$/i.test(parsed.hostname);
  if (
    parsed.username || parsed.password || parsed.search || parsed.hash
    || !["", "/"].includes(parsed.pathname)
    || (!localPage && !PRODUCTION_KINDRED_ORIGINS.has(parsed.origin))
    || (localPage && !(localTarget || PRODUCTION_KINDRED_ORIGINS.has(parsed.origin)))
    || (!localTarget && parsed.protocol !== "https:")
  ) {
    throw new Error("transfer_configuration_unavailable");
  }
  return parsed.origin;
};

const transferRequest = async (path, grant, body) => {
  if (!/^[A-Za-z0-9_-]{40,160}$/.test(grant || "")) throw new Error("transfer_unavailable");
  const controller = new AbortController();
  const timeout = window.setTimeout(() => controller.abort(), 15000);
  let response;
  try {
    response = await fetch(`${kindredApiOrigin()}/api/legacy-table/${path}`, {
      method: "POST",
      cache: "no-store",
      credentials: "omit",
      redirect: "error",
      referrerPolicy: "no-referrer",
      headers: {
        "Content-Type": "application/json",
        "X-Kindred-Transfer": grant,
      },
      body: body ? JSON.stringify(body) : undefined,
      signal: controller.signal,
    });
  } catch {
    throw new Error("transfer_unavailable");
  } finally {
    window.clearTimeout(timeout);
  }
  let payload = {};
  try { payload = await response.json(); } catch { /* safe categorical failure */ }
  if (!response.ok) {
    const error = new Error("transfer_unavailable");
    error.status = response.status;
    error.code = payload.error_code || "transfer_unavailable";
    throw error;
  }
  return payload;
};

export const retrieveKindredRecipe = (grant) => transferRequest("transfer-payload", grant);
export const acknowledgeKindredRecipe = (grant, body) => transferRequest("transfer-acknowledgement", grant, body);
export const revokeKindredRecipe = (grant) => transferRequest("transfer-revoke", grant).catch(() => null);
