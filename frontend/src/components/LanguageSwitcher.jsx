import { Globe } from "lucide-react";
import { useTranslation } from "react-i18next";
import { LANGUAGES } from "@/i18n";

// Language picker for the web app. Lists every supported language in its own native name,
// switches via i18next (which persists the choice and flips RTL for ar/fa/ur).
export default function LanguageSwitcher({ className = "" }) {
  const { i18n, t } = useTranslation();
  const current = i18n.resolvedLanguage || i18n.language || "en";

  return (
    <div className={`relative flex items-center ${className}`}>
      <Globe className="w-4 h-4 text-muted-foreground absolute left-2.5 pointer-events-none" />
      <select
        aria-label={t("language.label")}
        title={t("language.label")}
        value={current}
        onChange={(e) => i18n.changeLanguage(e.target.value)}
        data-testid="language-switcher"
        className="bg-transparent border border-border/50 rounded-full pl-8 pr-3 py-1.5 text-sm text-foreground hover:border-primary/50 focus:outline-none focus:ring-1 focus:ring-primary cursor-pointer"
      >
        {LANGUAGES.map((l) => (
          <option key={l.code} value={l.code} className="bg-card text-foreground">
            {l.label}
          </option>
        ))}
      </select>
    </div>
  );
}
