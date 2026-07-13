import React from "react";
import ReactDOM from "react-dom/client";
import "@/index.css";
import "@/i18n";
import App from "@/App";
import { initAnalytics } from "@/lib/track";

initAnalytics();

const rootEl = document.getElementById("root");
const app = (
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// Public routes ship as prerendered HTML (scripts/prerender.js) so crawlers
// see real content. Hydrate the snapshot for anonymous visitors; signed-in
// users get a fresh client render (no flash of the marketing page).
let hasSession = false;
try {
  hasSession = !!localStorage.getItem("token");
} catch (e) { /* storage unavailable */ }

if (rootEl.hasChildNodes() && !hasSession) {
  ReactDOM.hydrateRoot(rootEl, app);
} else {
  if (rootEl.hasChildNodes()) rootEl.innerHTML = "";
  ReactDOM.createRoot(rootEl).render(app);
}
