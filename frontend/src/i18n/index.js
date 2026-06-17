// i18n framework for the Legacy Table web app (step 1: framework + switcher + English baseline).
//
// English is the source of truth (locales/en.json). The other 9 languages mirror the mobile
// app's set; es/fr/pt are seeded here and the rest fall back to English until their strings are
// filled in (step 3 — much of it can be reused from the mobile .arb files). Adding a key only to
// en.json is enough; missing keys in other languages fall back automatically.
import i18n from "i18next";
import { initReactI18next } from "react-i18next";

import en from "./locales/en.json";
import es from "./locales/es.json";
import fr from "./locales/fr.json";
import pt from "./locales/pt.json";
import yo from "./locales/yo.json";
import pa from "./locales/pa.json";
import fa from "./locales/fa.json";
import hi from "./locales/hi.json";
import ur from "./locales/ur.json";
import ar from "./locales/ar.json";

// Displayed in each language's own native name (same regardless of the active locale).
export const LANGUAGES = [
  { code: "en", label: "English" },
  { code: "es", label: "Español" },
  { code: "fr", label: "Français" },
  { code: "pt", label: "Português" },
  { code: "yo", label: "Yorùbá" },
  { code: "pa", label: "ਪੰਜਾਬੀ" },
  { code: "fa", label: "فارسی" },
  { code: "hi", label: "हिन्दी" },
  { code: "ur", label: "اردو" },
  { code: "ar", label: "العربية" },
];

const RTL = new Set(["ar", "fa", "ur"]);
const STORAGE_KEY = "lt_lang";
const SUPPORTED = LANGUAGES.map((l) => l.code);

function initialLang() {
  try {
    const saved = localStorage.getItem(STORAGE_KEY);
    if (saved && SUPPORTED.includes(saved)) return saved;
  } catch (e) { /* localStorage unavailable */ }
  const nav = (navigator.language || "en").slice(0, 2).toLowerCase();
  return SUPPORTED.includes(nav) ? nav : "en";
}

// Set the document direction (RTL for Arabic/Persian/Urdu) and lang attribute.
export function applyDirection(lng) {
  document.documentElement.setAttribute("dir", RTL.has(lng) ? "rtl" : "ltr");
  document.documentElement.setAttribute("lang", lng);
}

i18n.use(initReactI18next).init({
  resources: {
    en: { translation: en },
    es: { translation: es },
    fr: { translation: fr },
    pt: { translation: pt },
    yo: { translation: yo },
    pa: { translation: pa },
    fa: { translation: fa },
    hi: { translation: hi },
    ur: { translation: ur },
    ar: { translation: ar },
  },
  lng: initialLang(),
  fallbackLng: "en",
  supportedLngs: SUPPORTED,
  interpolation: { escapeValue: false }, // React already escapes
  returnEmptyString: false,
});

applyDirection(i18n.language);
i18n.on("languageChanged", (lng) => {
  try { localStorage.setItem(STORAGE_KEY, lng); } catch (e) { /* ignore */ }
  applyDirection(lng);
});

export default i18n;
