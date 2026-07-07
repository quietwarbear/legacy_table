import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../App";
import { trackStoreClick } from "../lib/track";
import { Card, CardContent } from "../components/ui/card";
import { Button } from "../components/ui/button";
import { Check, Menu } from "lucide-react";

// ----------------------------------------------------------------------------
// Store URLs and badge assets — kept here in addition to LandingPage so this
// page is self-contained. When we extract a shared <StoreBadges /> module,
// both pages will switch over.
// ----------------------------------------------------------------------------
const APP_STORE_URL =
  "https://apps.apple.com/us/app/legacy-table/id6759821009";
const PLAY_STORE_URL =
  "https://play.google.com/store/apps/details?id=com.htrecipes.family_recipe_app";
const APP_STORE_BADGE =
  "https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83";
const PLAY_STORE_BADGE =
  "https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png";

// ----------------------------------------------------------------------------
// PRICES — these mirror what frontend/src/subscription.js currently shows
// in-app. Doc flagged that they may not match what's live in the App Store
// and Google Play. Verify against:
//   - Play Console → Monetize → Products → Subscriptions
//   - App Store Connect → My Apps → Legacy Table → Monetization → Subscriptions
// and update in one place when the canonical numbers are confirmed.
//
// TODO(pricing-verification): replace these with the real store prices.
// ----------------------------------------------------------------------------
const PRICES = {
  heritage: { monthly: 9.99, annual: 99.99 },
  legacy: { monthly: 19.99, annual: 199.99 },
};

const StoreBadges = ({ size = "default", align = "center", className = "" }) => {
  const heights =
    size === "large" ? "h-14 sm:h-16" : size === "small" ? "h-10" : "h-12";
  const alignClass =
    align === "center" ? "justify-center" : "justify-start";

  return (
    <div className={`flex flex-wrap items-center gap-3 ${alignClass} ${className}`}>
      <a
        href={APP_STORE_URL}
        target="_blank"
        rel="noopener noreferrer"
        onClick={() => trackStoreClick("apple", "pricing")}
        aria-label="Download Legacy Table on the App Store"
        className="inline-block transition-transform hover:scale-[1.02] focus:outline-none focus:ring-2 focus:ring-primary rounded-md"
      >
        <img
          src={APP_STORE_BADGE}
          alt="Download on the App Store"
          className={`${heights} w-auto`}
        />
      </a>
      <a
        href={PLAY_STORE_URL}
        target="_blank"
        rel="noopener noreferrer"
        onClick={() => trackStoreClick("google", "pricing")}
        aria-label="Get Legacy Table on Google Play"
        className="inline-block transition-transform hover:scale-[1.02] focus:outline-none focus:ring-2 focus:ring-primary rounded-md"
      >
        <img
          src={PLAY_STORE_BADGE}
          alt="Get it on Google Play"
          className={`${heights} w-auto`}
        />
      </a>
    </div>
  );
};

// Lightweight nav mirroring LandingPage's TopNav so /pricing matches the
// branded chrome without depending on the LandingPage component.
const TopNav = () => {
  const [open, setOpen] = useState(false);
  const linkClass =
    "text-sm font-semibold text-foreground/80 hover:text-foreground transition-colors";

  return (
    <header className="sticky top-0 z-50 w-full bg-background/85 backdrop-blur border-b border-border">
      <div className="max-w-7xl mx-auto px-4 md:px-6 lg:px-8 h-16 flex items-center justify-between">
        <Link
          to="/"
          className="font-serif text-xl font-bold text-foreground"
          aria-label="Legacy Table — home"
        >
          Legacy Table
        </Link>

        <nav className="hidden md:flex items-center gap-7">
          <Link to="/#how-it-works" className={linkClass}>
            How it works
          </Link>
          <Link to="/#why" className={linkClass}>
            Why
          </Link>
          <Link to="/pricing" className={`${linkClass} text-foreground`}>
            Pricing
          </Link>
        </nav>

        <div className="flex items-center gap-3">
          <Link
            to="/login"
            className={`${linkClass} hidden sm:inline-flex`}
          >
            Sign in
          </Link>
          <a
            href="#get-the-app"
            className="hidden sm:inline-flex"
          >
            <Button
              size="sm"
              className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full"
            >
              Sign up free
            </Button>
          </a>
          <button
            className="md:hidden p-2 -mr-2"
            aria-label="Open menu"
            onClick={() => setOpen((v) => !v)}
          >
            <Menu className="w-5 h-5" />
          </button>
        </div>
      </div>

      {open && (
        <div className="md:hidden border-t border-border bg-background">
          <div className="max-w-7xl mx-auto px-4 py-3 flex flex-col gap-3">
            <Link to="/" onClick={() => setOpen(false)} className={`${linkClass} py-2`}>
              Home
            </Link>
            <Link to="/pricing" onClick={() => setOpen(false)} className={`${linkClass} py-2`}>
              Pricing
            </Link>
            <Link to="/login" onClick={() => setOpen(false)} className={`${linkClass} py-2`}>
              Sign in
            </Link>
          </div>
        </div>
      )}
    </header>
  );
};

// ----------------------------------------------------------------------------
// Pricing tier card
// ----------------------------------------------------------------------------
const TierCard = ({
  name,
  tagline,
  priceMonthly,
  priceAnnual,
  isAnnual,
  features,
  featured = false,
  freeTier = false,
}) => {
  const displayPrice = isAnnual ? priceAnnual : priceMonthly;
  const monthlyEquivalent =
    isAnnual && priceAnnual ? (priceAnnual / 12).toFixed(2) : null;
  const savingsPct =
    isAnnual && priceAnnual && priceMonthly
      ? Math.round(100 - (priceAnnual / (priceMonthly * 12)) * 100)
      : null;

  return (
    <Card
      className={`flex flex-col h-full rounded-xl overflow-hidden ${
        featured
          ? "border-2 border-primary shadow-lg md:-translate-y-2"
          : "border border-border shadow-sm"
      }`}
    >
      {featured && (
        <div className="bg-primary text-primary-foreground text-xs font-semibold uppercase tracking-widest text-center py-1.5">
          Most popular
        </div>
      )}
      <CardContent className="p-6 flex flex-col flex-1">
        <h3 className="font-serif text-2xl font-bold text-foreground mb-1">
          {name}
        </h3>
        <p className="text-sm text-muted-foreground mb-5">{tagline}</p>

        {freeTier ? (
          <div className="mb-5">
            <span className="font-serif text-4xl font-bold text-foreground">
              $0
            </span>
            <span className="text-muted-foreground"> forever</span>
          </div>
        ) : (
          <div className="mb-5">
            <span className="font-serif text-4xl font-bold text-foreground">
              ${displayPrice}
            </span>
            <span className="text-muted-foreground">
              {" "}
              / {isAnnual ? "year" : "month"}
            </span>
            {isAnnual && monthlyEquivalent && (
              <p className="text-xs text-muted-foreground mt-1">
                ≈ ${monthlyEquivalent}/mo
                {savingsPct ? ` · save ${savingsPct}%` : ""}
              </p>
            )}
          </div>
        )}

        <ul className="space-y-2.5 mb-6 flex-1">
          {features.map((f, i) => (
            <li key={i} className="flex items-start gap-2 text-sm">
              <Check
                className={`w-4 h-4 mt-0.5 flex-shrink-0 ${
                  featured ? "text-primary" : "text-muted-foreground"
                }`}
              />
              <span className="text-muted-foreground">{f}</span>
            </li>
          ))}
        </ul>

        <div className="mt-auto">
          <StoreBadges size="small" align="center" />
          <p className="text-xs text-muted-foreground text-center mt-3">
            {freeTier
              ? "Download the app to start"
              : "Subscribe inside the app"}
          </p>
        </div>
      </CardContent>
    </Card>
  );
};

const PricingPage = () => {
  const { user } = useAuth();
  const navigate = useNavigate();
  const [isAnnual, setIsAnnual] = useState(true);

  // Logged-in users go to the in-app subscription manager instead of seeing
  // marketing tier copy.
  useEffect(() => {
    if (user) {
      navigate("/subscribe", { replace: true });
    }
  }, [user, navigate]);

  return (
    <div className="min-h-screen bg-background text-foreground">
      <TopNav />

      {/* Hero */}
      <section className="py-16 md:py-24 px-4 md:px-6 lg:px-8 max-w-7xl mx-auto text-center">
        <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4">
          PRICING
        </p>
        <h1 className="font-serif text-4xl md:text-5xl font-bold text-foreground mb-4">
          Start free. Upgrade when your family does.
        </h1>
        <p className="text-lg text-muted-foreground max-w-2xl mx-auto mb-2">
          Every Legacy Table account is free. Paid plans unlock AI features
          and bigger families.
        </p>
        <p className="text-sm text-muted-foreground max-w-2xl mx-auto">
          Subscriptions are billed through the App Store or Google Play.
          Cancel anytime from your phone's account settings.
        </p>

        {/* Annual / Monthly toggle */}
        <div className="mt-10 inline-flex items-center gap-3 bg-muted rounded-full p-1">
          <button
            onClick={() => setIsAnnual(false)}
            className={`px-5 py-2 text-sm font-semibold rounded-full transition-colors ${
              !isAnnual
                ? "bg-background text-foreground shadow"
                : "text-muted-foreground"
            }`}
            aria-pressed={!isAnnual}
          >
            Monthly
          </button>
          <button
            onClick={() => setIsAnnual(true)}
            className={`px-5 py-2 text-sm font-semibold rounded-full transition-colors ${
              isAnnual
                ? "bg-background text-foreground shadow"
                : "text-muted-foreground"
            }`}
            aria-pressed={isAnnual}
          >
            Annual <span className="text-primary ml-1">save ~17%</span>
          </button>
        </div>
      </section>

      {/* Tier cards */}
      <section className="px-4 md:px-6 lg:px-8 max-w-7xl mx-auto pb-20">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 items-stretch">
          <TierCard
            name="Free"
            tagline="Try every recipe feature, then decide"
            freeTier
            features={[
              "3 AI credits per month",
              "Unlimited family recipe storage",
              "1 family · share with up to 4 members",
              "Photo uploads for every recipe",
              "Export your cookbook anytime",
            ]}
          />
          <TierCard
            name="Heritage Keeper"
            tagline="Perfect for getting started"
            priceMonthly={PRICES.heritage.monthly}
            priceAnnual={PRICES.heritage.annual}
            isAnnual={isAnnual}
            features={[
              "15 AI credits per month",
              "Everything in Free",
              "Family sharing (up to 10 members)",
              "Recipe categories & tags",
              "Export & print recipe books",
            ]}
          />
          <TierCard
            name="Legacy Collection"
            tagline="For the whole family"
            priceMonthly={PRICES.legacy.monthly}
            priceAnnual={PRICES.legacy.annual}
            isAnnual={isAnnual}
            featured
            features={[
              "50 AI credits per month",
              "Everything in Heritage Keeper",
              "Unlimited family members",
              "Advanced recipe organization",
              "Priority customer support",
              "Early access to new features",
              "Custom family cookbook themes",
            ]}
          />
        </div>

        {/* Verify-prices banner (visible only in dev so prices that may be
            stale don't surprise the team). Production builds set
            NODE_ENV=production so this won't render. */}
        {process.env.NODE_ENV !== "production" && (
          <div className="mt-10 max-w-3xl mx-auto bg-yellow-50 dark:bg-yellow-900/20 border border-yellow-200 dark:border-yellow-800 rounded-lg p-4 text-sm">
            <p className="font-semibold text-yellow-900 dark:text-yellow-200 mb-1">
              ⚠ Verify these prices before launch
            </p>
            <p className="text-yellow-800 dark:text-yellow-300">
              The prices in this file (PRICES const) mirror{" "}
              <code>frontend/src/subscription.js</code>, which may be out of
              sync with the live App Store and Google Play. Confirm against
              App Store Connect → Monetization → Subscriptions and Play
              Console → Monetize → Products → Subscriptions, then update
              both files in lockstep.
            </p>
          </div>
        )}
      </section>

      {/* Family Legacy gift — flag-gated until the print pipeline ships.
          Enable with REACT_APP_SHOW_FAMILY_LEGACY=true in Vercel env. */}
      {process.env.REACT_APP_SHOW_FAMILY_LEGACY === "true" && (
        <section className="px-4 md:px-6 lg:px-8 py-16 md:py-20">
          <div className="max-w-3xl mx-auto text-center rounded-2xl border-2 border-primary/30 bg-card shadow-md p-10">
            <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-3">
              OR GIVE IT AS A GIFT
            </p>
            <h2 className="font-serif text-3xl md:text-4xl font-bold mb-4">
              Family Legacy — $99, once.
            </h2>
            <p className="text-muted-foreground leading-relaxed mb-8 max-w-xl mx-auto">
              A year of Legacy Table for their whole family, plus a printed
              heirloom cookbook whose pages play the voices behind the
              recipes. Bought with a card, given with a code.
            </p>
            <Button size="lg" className="rounded-full" asChild>
              <Link to="/gift">Give Family Legacy</Link>
            </Button>
          </div>
        </section>
      )}

      {/* FAQ */}
      <section className="px-4 md:px-6 lg:px-8 py-16 md:py-20 bg-muted">
        <div className="max-w-3xl mx-auto">
          <h2 className="font-serif text-3xl font-bold text-center mb-12">
            Common questions
          </h2>
          <dl className="space-y-8">
            <div>
              <dt className="font-semibold text-foreground mb-2">
                Where does the subscription get charged?
              </dt>
              <dd className="text-muted-foreground">
                Through your App Store or Google Play account, depending on
                where you downloaded the app. We don't see or store your
                payment information.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-foreground mb-2">
                How do I cancel?
              </dt>
              <dd className="text-muted-foreground">
                On iOS, open Settings → tap your name → Subscriptions →
                Legacy Table → Cancel. On Android, open Google Play → tap
                your profile → Payments &amp; subscriptions → Subscriptions →
                Legacy Table → Cancel. The cancellation takes effect at the
                end of your current billing period.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-foreground mb-2">
                Can I share one subscription with my family?
              </dt>
              <dd className="text-muted-foreground">
                Yes. Subscriptions cover everyone you invite into your
                Legacy Table family (up to 4 on Free, 10 on Heritage Keeper,
                unlimited on Legacy Collection). Each member gets full
                access without paying separately.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-foreground mb-2">
                What's an "AI credit"?
              </dt>
              <dd className="text-muted-foreground">
                Credits power the AI helpers — scanning a handwritten recipe
                card, turning a voice memo into a recipe, generating a
                share-ready image. Each AI action costs 1–2 credits. Free
                accounts get 3/month, Heritage Keeper gets 15, Legacy
                Collection gets 50. Credits refresh at the start of each
                billing cycle.
              </dd>
            </div>
            <div>
              <dt className="font-semibold text-foreground mb-2">
                Does the price ever change?
              </dt>
              <dd className="text-muted-foreground">
                If we ever change a subscription price, existing subscribers
                stay on their current price for the remainder of their term
                and we'll notify you before the next renewal. New
                subscribers see the current price.
              </dd>
            </div>
          </dl>
        </div>
      </section>

      {/* Get the app section */}
      <section
        id="get-the-app"
        className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-secondary text-secondary-foreground"
      >
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="font-serif text-4xl md:text-5xl font-bold mb-4">
            Start your family's cookbook today.
          </h2>
          <p className="text-lg md:text-xl mb-10 opacity-90">
            Free to download on iOS and Android. Subscribe in-app whenever
            your family is ready.
          </p>

          <StoreBadges size="large" align="center" className="mb-6" />

          <p className="text-sm opacity-75 mb-12">
            Already have an account?{" "}
            <Link
              to="/login"
              className="underline hover:no-underline font-medium"
            >
              Sign in
            </Link>
          </p>

          <div className="text-xs opacity-75 space-y-1">
            <p>
              © 2026 Ubuntu Markets LLC · legacytable.app ·
              contact@ubuntu-markets.org
            </p>
            <div className="flex justify-center gap-4 text-xs">
              <a href="/privacy-policy" className="hover:underline">
                Privacy Policy
              </a>
              <span>·</span>
              <Link to="/terms" className="hover:underline">
                Terms of Service
              </Link>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default PricingPage;
