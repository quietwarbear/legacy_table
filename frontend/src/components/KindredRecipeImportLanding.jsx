import { useEffect, useState } from "react";
import axios from "axios";

import { acknowledgeKindredRecipe, retrieveKindredRecipe, revokeKindredRecipe } from "@/lib/kindredTransfer";

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || "";
const API = `${BACKEND_URL}/api`;
const ACCEPTED = new Set(["accepted", "already_accepted"]);

const safeMessage = (state) => ({
  conflict: "This transfer could not be reconciled safely.",
  deleted: "The earlier Legacy Table copy was deleted and will not be recreated.",
  unavailable: "The private transfer is unavailable. Your Kindred recipe is unchanged.",
}[state] || "The private transfer could not be completed.");

export const KindredRecipeImportLanding = ({ grant, sessionToken, user, onDone, onAbandon, onTerminal }) => {
  const [payload, setPayload] = useState(null);
  const [status, setStatus] = useState("loading");
  const [familyConfirmed, setFamilyConfirmed] = useState(false);
  const [cookbookName, setCookbookName] = useState("");
  const [error, setError] = useState("");

  useEffect(() => {
    let active = true;
    retrieveKindredRecipe(grant)
      .then((recipe) => {
        if (!active) return;
        setPayload(recipe);
        setStatus("ready");
      })
      .catch(() => {
        if (!active) return;
        setStatus("unavailable");
        setError(safeMessage("unavailable"));
      });
    return () => { active = false; };
  }, [grant]);

  const acknowledge = async (result) => {
    await acknowledgeKindredRecipe(grant, {
      operation_id: payload.operation_id,
      source_revision_digest: payload.source_revision_digest,
      status: result.status,
      receipt_reference: result.receipt_reference || null,
      error_code: result.error_code || null,
    });
    setStatus("completed");
    onDone();
  };

  const reconcile = async () => {
    try {
      const response = await axios.get(`${API}/recipe-imports/${encodeURIComponent(payload.operation_id)}`, {
        headers: { Authorization: `Bearer ${sessionToken}` },
        timeout: 15000,
      });
      return response.data;
    } catch (requestError) {
      if (requestError.response?.status === 404) return null;
      throw requestError;
    }
  };

  const submit = async () => {
    if (status !== "ready" || !familyConfirmed) return;
    if (!user?.family_id && !cookbookName.trim()) return;
    setStatus("submitting");
    setError("");
    try {
      let result = await reconcile();
      if (!result) {
        const request = {
          ...payload,
          family_cookbook_action: user?.family_id ? "use_existing" : "create",
          family_cookbook_name: user?.family_id ? null : cookbookName.trim(),
        };
        try {
          result = (await axios.post(`${API}/recipe-imports`, request, {
            headers: { Authorization: `Bearer ${sessionToken}` },
            timeout: 15000,
          })).data;
        } catch (postError) {
          if (postError.response) {
            result = postError.response.data;
          } else {
            result = await reconcile();
            if (!result) throw postError;
          }
        }
      }
      if (ACCEPTED.has(result?.status)) {
        await acknowledge(result);
        return;
      }
      if (["deleted", "conflict"].includes(result?.status)) {
        await acknowledgeKindredRecipe(grant, {
          operation_id: payload.operation_id,
          source_revision_digest: payload.source_revision_digest,
          status: result.status,
          receipt_reference: result.receipt_reference || null,
          error_code: result.error_code || null,
        });
        onTerminal(result.status);
        return;
      }
      throw new Error("destination_unavailable");
    } catch {
      setStatus("ready");
      setError("The result is not yet confirmed. Retry safely with this same transfer.");
    }
  };

  const abandon = async () => {
    setStatus("abandoning");
    await revokeKindredRecipe(grant);
    onAbandon();
  };

  return (
    <div data-testid="kindred-import-landing" style={{ width: "100%", maxWidth: 620, textAlign: "left" }}>
      <p style={{ color: "#78593A", fontWeight: 700 }}>Private Kindred recipe transfer</p>
      {status === "loading" && <p>Retrieving the selected recipe securely…</p>}
      {payload && (
        <>
          <h1 style={{ fontFamily: "Georgia,serif", fontSize: 28 }}>{payload.title}</h1>
          <p style={{ whiteSpace: "pre-line", lineHeight: 1.65 }}>{payload.instructions_or_story}</p>
          {user?.family_id ? (
            <label style={{ display: "flex", gap: 8, marginTop: 20 }}>
              <input data-testid="kindred-import-family-confirm" type="checkbox" checked={familyConfirmed} onChange={(event) => setFamilyConfirmed(event.target.checked)} />
              Add this recipe to my existing family cookbook.
            </label>
          ) : (
            <div style={{ marginTop: 20 }}>
              <label>
                Neutral cookbook name
                <input data-testid="kindred-import-cookbook-name" maxLength={80} value={cookbookName} onChange={(event) => setCookbookName(event.target.value)} style={{ display: "block", width: "100%", padding: 10, marginTop: 6 }} />
              </label>
              <label style={{ display: "flex", gap: 8, marginTop: 12 }}>
                <input data-testid="kindred-import-create-confirm" type="checkbox" checked={familyConfirmed} onChange={(event) => setFamilyConfirmed(event.target.checked)} />
                Create this cookbook and add the selected recipe.
              </label>
            </div>
          )}
        </>
      )}
      {error && <p data-testid="kindred-import-error" style={{ color: "#9a3412" }}>{error}</p>}
      {status === "completed" ? (
        <p data-testid="kindred-import-complete">Recipe accepted by Legacy Table.</p>
      ) : (
        <div style={{ display: "flex", gap: 12, marginTop: 22 }}>
          <button data-testid="kindred-import-submit" disabled={!payload || !familyConfirmed || status !== "ready" || (!user?.family_id && !cookbookName.trim())} onClick={submit}>Add recipe</button>
          <button data-testid="kindred-import-abandon" disabled={["submitting", "abandoning"].includes(status)} onClick={abandon}>Not now</button>
        </div>
      )}
    </div>
  );
};
