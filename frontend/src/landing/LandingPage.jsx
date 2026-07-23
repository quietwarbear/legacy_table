import React, { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../App";
import { trackStoreClick, trackEvent } from "../lib/track";
import { Button } from "../components/ui/button";
import { Card, CardContent } from "../components/ui/card";
import {
  BookHeart,
  Mic,
  Users,
  Shield,
  Lock,
  Download,
  Menu,
} from "lucide-react";

// ----------------------------------------------------------------------------
// Store URLs — source of truth for download links.
// ----------------------------------------------------------------------------
const APP_STORE_URL =
  "https://apps.apple.com/us/app/legacy-table/id6759821009";
const PLAY_STORE_URL =
  "https://play.google.com/store/apps/details?id=com.htrecipes.family_recipe_app";

// Official badge assets from Apple + Google. Both are explicitly licensed for
// hotlinking in marketing contexts. If the live site needs deterministic
// uptime, swap these for /public copies later.
const APP_STORE_BADGE =
  "https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83";
const PLAY_STORE_BADGE =
  "https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png";

const scrollToId = (id) => {
  const el = document.getElementById(id);
  if (el) el.scrollIntoView({ behavior: "smooth", block: "start" });
};

// ----------------------------------------------------------------------------
// Shared <StoreBadges /> — App Store + Google Play badges side by side.
// Used in the hero and the final CTA. One component = one place to fix when
// the badge URLs or click targets change.
// ----------------------------------------------------------------------------
const StoreBadges = ({ size = "default", align = "start", className = "", placement = "hero" }) => {
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
        onClick={() => trackStoreClick("apple", placement)}
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
        onClick={() => trackStoreClick("google", placement)}
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

// ----------------------------------------------------------------------------
// Sticky top navigation. Reachable: How it works, Why, Sign in (existing
// users -> /login), Sign up free (new users -> scrolls to the download
// section since accounts are created inside the app on first launch).
// Pricing is intentionally NOT in the nav — subscriptions live in the app
// (App Store / Play Store handle billing).
// ----------------------------------------------------------------------------
const TopNav = () => {
  const [open, setOpen] = React.useState(false);

  const linkClass =
    "text-sm font-semibold text-foreground/80 hover:text-foreground transition-colors";

  return (
    <header className="sticky top-0 z-50 w-full bg-background/85 backdrop-blur border-b border-border">
      <div className="max-w-7xl mx-auto px-4 md:px-6 lg:px-8 h-16 flex items-center justify-between">
        <button
          onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}
          className="font-serif text-xl font-bold text-foreground"
          aria-label="Legacy Table — back to top"
        >
          Legacy Table
        </button>

        {/* Desktop nav */}
        <nav className="hidden md:flex items-center gap-7">
          <button onClick={() => scrollToId("how-it-works")} className={linkClass}>
            How it works
          </button>
          <button onClick={() => scrollToId("why")} className={linkClass}>
            Why
          </button>
          {/* Static page served from public/guides — must be a real <a>, not a router Link */}
          <a href="/guides/" className={linkClass}>
            Guides
          </a>
          <Link to="/pricing" className={linkClass}>
            Pricing
          </Link>
        </nav>

        <div className="flex items-center gap-3">
          <Link
            to="/login"
            className={`${linkClass} hidden sm:inline-flex`}
            aria-label="Sign in to your Legacy Table account"
          >
            Sign in
          </Link>
          <Button
            size="sm"
            className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full hidden sm:inline-flex"
            onClick={() => scrollToId("get-the-app")}
          >
            Sign up free
          </Button>
          {/* Mobile menu toggle */}
          <button
            className="md:hidden p-2 -mr-2"
            aria-label="Open menu"
            onClick={() => setOpen((v) => !v)}
          >
            <Menu className="w-5 h-5" />
          </button>
        </div>
      </div>

      {/* Mobile menu drawer */}
      {open && (
        <div className="md:hidden border-t border-border bg-background">
          <div className="max-w-7xl mx-auto px-4 py-3 flex flex-col gap-3">
            <button
              onClick={() => {
                setOpen(false);
                scrollToId("how-it-works");
              }}
              className={`${linkClass} text-left py-2`}
            >
              How it works
            </button>
            <button
              onClick={() => {
                setOpen(false);
                scrollToId("why");
              }}
              className={`${linkClass} text-left py-2`}
            >
              Why
            </button>
            <a href="/guides/" className={`${linkClass} py-2`}>
              Guides
            </a>
            <Link
              to="/pricing"
              onClick={() => setOpen(false)}
              className={`${linkClass} py-2`}
            >
              Pricing
            </Link>
            <Link
              to="/login"
              onClick={() => setOpen(false)}
              className={`${linkClass} py-2`}
            >
              Sign in
            </Link>
            <Button
              size="sm"
              className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full"
              onClick={() => {
                setOpen(false);
                scrollToId("get-the-app");
              }}
            >
              Sign up free
            </Button>
          </div>
        </div>
      )}
    </header>
  );
};

// ----------------------------------------------------------------------------
// Voice demo — the product's most differentiated moment, shown, not told:
// spoken words on the left become a structured recipe (with the voice kept)
// on the right. Pure CSS animation; no video weight.
// ----------------------------------------------------------------------------
const VoiceDemo = () => (
  <section className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-background">
    <style>{`
      @keyframes lt-bar { 0%,100% { transform: scaleY(0.3); } 50% { transform: scaleY(1); } }
      @keyframes lt-rise { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }
      .lt-wave span { display:inline-block; width:3px; border-radius:2px; margin-right:3px;
        height:18px; transform-origin:center; animation: lt-bar 1.1s ease-in-out infinite; }
      .lt-rise { animation: lt-rise 0.7s ease-out both; }
      @media (prefers-reduced-motion: reduce) {
        .lt-wave span, .lt-rise { animation: none; }
      }
    `}</style>
    <div className="max-w-7xl mx-auto">
      <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4 text-center">
        SAY IT OUT LOUD
      </p>
      <h2 className="font-serif text-4xl md:text-5xl font-bold text-center mb-6">
        She talks. Legacy Table writes it down forever.
      </h2>
      <p className="text-lg text-muted-foreground text-center max-w-2xl mx-auto mb-16 leading-relaxed">
        Press record while the cook explains it in her own words. The app turns
        the recording into a structured recipe — and keeps her voice attached
        to it, for good.
      </p>

      <div className="grid grid-cols-1 lg:grid-cols-[1fr_auto_1fr] gap-8 items-center max-w-5xl mx-auto">
        {/* What she says */}
        <div className="rounded-2xl bg-muted p-8 shadow-md lt-rise">
          <div className="flex items-center gap-3 mb-4">
            <div className="flex items-center justify-center w-10 h-10 rounded-full bg-primary/10">
              <Mic className="w-5 h-5 text-primary" />
            </div>
            <div className="lt-wave text-primary" aria-hidden="true">
              <span style={{ background: "currentColor", animationDelay: "0s" }} />
              <span style={{ background: "currentColor", animationDelay: "0.15s" }} />
              <span style={{ background: "currentColor", animationDelay: "0.3s" }} />
              <span style={{ background: "currentColor", animationDelay: "0.45s" }} />
              <span style={{ background: "currentColor", animationDelay: "0.6s" }} />
            </div>
            <span className="text-xs uppercase tracking-wider text-muted-foreground font-semibold">
              Recording
            </span>
          </div>
          <p className="font-serif text-xl md:text-2xl italic text-foreground leading-relaxed">
            “A cup of flour, a cup of oil — and you stir, baby. Don't rush it.
            You stir until it looks like Louisiana…”
          </p>
          <p className="text-sm text-muted-foreground mt-4">Grandma Rose, explaining the roux</p>
        </div>

        {/* Arrow */}
        <div className="hidden lg:flex flex-col items-center text-primary" aria-hidden="true">
          <span className="text-3xl">→</span>
        </div>

        {/* What the family keeps */}
        <div className="rounded-2xl bg-card border border-border p-8 shadow-xl lt-rise" style={{ animationDelay: "0.35s" }}>
          <h3 className="font-serif text-2xl font-bold text-foreground mb-4">
            Grandma Rose's Gumbo
          </h3>
          <ul className="text-sm text-muted-foreground space-y-2 mb-5">
            <li>· 1 cup flour</li>
            <li>· 1 cup vegetable oil</li>
            <li>· Stir 30–45 min, “until it looks like Louisiana”</li>
          </ul>
          <div className="flex items-center gap-3 rounded-full bg-primary/10 px-4 py-2 w-fit">
            <span className="text-primary" aria-hidden="true">▶</span>
            <span className="text-sm font-semibold text-foreground">Grandma Rose · 0:47</span>
          </div>
          <p className="text-xs text-muted-foreground mt-4">
            Her voice stays with the recipe. Forever.
          </p>
        </div>
      </div>

      <p className="text-center text-sm text-muted-foreground mt-12">
        Three ways to capture: <span className="text-foreground font-medium">speak it</span>,{" "}
        <span className="text-foreground font-medium">scan the handwritten card</span>, or{" "}
        <span className="text-foreground font-medium">save from a link</span>.
      </p>
    </div>
  </section>
);

// ----------------------------------------------------------------------------
// Email capture — the fallback for visitors who aren't ready to install.
// Posts to the public marketing endpoint; honeypot field deters bots.
// ----------------------------------------------------------------------------
const EmailCapture = () => {
  const [email, setEmail] = useState("");
  const [status, setStatus] = useState("idle"); // idle | sending | done | error

  const submit = async (e) => {
    e.preventDefault();
    if (!email || status === "sending") return;
    setStatus("sending");
    try {
      const base = process.env.REACT_APP_BACKEND_URL || "";
      const res = await fetch(`${base}/api/marketing/email-signup`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, source: "landing_footer" }),
      });
      if (!res.ok) throw new Error("bad status");
      trackEvent("email_signup", { source: "landing_footer" });
      setStatus("done");
    } catch {
      setStatus("error");
    }
  };

  if (status === "done") {
    return (
      <p className="text-sm opacity-90 mb-12" data-testid="email-capture-done">
        You're on the list. One gentle idea a month — that's all.
      </p>
    );
  }

  return (
    <form onSubmit={submit} className="mb-12 max-w-md mx-auto" data-testid="email-capture-form">
      <p className="text-sm opacity-90 mb-3">
        Not ready to download? Leave your email — one idea a month for
        capturing your family's recipes, nothing else.
      </p>
      <div className="flex gap-2">
        <input
          type="email"
          required
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          placeholder="you@example.com"
          className="flex-1 rounded-full px-5 py-3 text-sm text-foreground bg-background/95 border-0 focus:outline-none focus:ring-2 focus:ring-primary"
          data-testid="email-capture-input"
        />
        <Button type="submit" size="lg" className="rounded-full" disabled={status === "sending"}>
          {status === "sending" ? "…" : "Keep me posted"}
        </Button>
      </div>
      {status === "error" && (
        <p className="text-xs mt-2 opacity-90">
          That didn't go through — mind trying again?
        </p>
      )}
    </form>
  );
};

const LandingPage = () => {
  const { user } = useAuth();
  const navigate = useNavigate();

  // Redirect authenticated users to /home
  useEffect(() => {
    if (user) {
      navigate("/home", { replace: true });
    }
  }, [user, navigate]);

  return (
    <div className="min-h-screen bg-background text-foreground">
      <TopNav />

      {/* Hero Section */}
      <section className="py-20 md:py-32 px-4 md:px-6 lg:px-8 max-w-7xl mx-auto">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
          <div>
            <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4">
              FAMILY RECIPES, REMEMBERED
            </p>
            <h1 className="font-serif text-5xl md:text-6xl font-bold text-foreground leading-tight mb-6">
              Where recipes become heirlooms.
            </h1>
            <p className="text-lg md:text-xl text-muted-foreground mb-8 max-w-xl leading-relaxed">
              Capture the recipes, the stories, and the voices that teach them.
              Build your family's cookbook together — privately.
            </p>

            {/* Primary CTA: store badges. Secondary: jump to features. */}
            <StoreBadges size="large" align="start" className="mb-4" />
            <div className="flex flex-col sm:flex-row gap-4 items-start">
              <Button
                size="lg"
                variant="outline"
                className="rounded-full"
                onClick={() => scrollToId("how-it-works")}
              >
                What it does
              </Button>
              <Link
                to="/login"
                className="text-sm font-semibold text-foreground/70 hover:text-foreground transition-colors self-center sm:self-auto sm:py-3"
              >
                Already have an account? Sign in →
              </Link>
            </div>
          </div>

          <div className="flex justify-center lg:justify-end">
            <div className="w-full max-w-md aspect-square rounded-2xl overflow-hidden bg-muted shadow-xl">
              <img
                src={`${process.env.PUBLIC_URL || ""}/legacy-hero.png`}
                alt="Legacy Table App Preview"
                className="w-full h-full object-cover"
              />
            </div>
          </div>
        </div>
      </section>

      {/* Features Section
          Anchor: how-it-works — keeping the legacy id="features" too so any
          external links still work, but the new nav targets how-it-works. */}
      <section
        id="how-it-works"
        className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-muted scroll-mt-16"
      >
        <a id="features" />
        <div className="max-w-7xl mx-auto">
          <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4 text-center">
            WHAT IT DOES
          </p>
          <h2 className="font-serif text-4xl md:text-5xl font-bold text-center mb-16">
            Everything a family needs to preserve its recipes.
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <Card className="border-0 shadow-md">
              <CardContent className="p-8">
                <div className="mb-6 flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
                  <BookHeart className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-serif text-2xl font-bold text-foreground mb-3">
                  Recipes with the story attached
                </h3>
                <p className="text-muted-foreground leading-relaxed">
                  Every dish carries a name, a person, a moment. Capture the
                  why, not just the how.
                </p>
              </CardContent>
            </Card>

            <Card className="border-0 shadow-md">
              <CardContent className="p-8">
                <div className="mb-6 flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
                  <Mic className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-serif text-2xl font-bold text-foreground mb-3">
                  Voice notes from the cooks who taught you
                </h3>
                <p className="text-muted-foreground leading-relaxed">
                  Record Aunt Rita explaining the roux. Tag photos of every
                  step. Keep the voices in the kitchen forever.
                </p>
              </CardContent>
            </Card>

            <Card className="border-0 shadow-md">
              <CardContent className="p-8">
                <div className="mb-6 flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
                  <Users className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-serif text-2xl font-bold text-foreground mb-3">
                  A cookbook your whole family writes
                </h3>
                <p className="text-muted-foreground leading-relaxed">
                  Invite siblings, cousins, and elders. Build the family canon
                  together — and pass it down.
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Voice → recipe demo */}
      <VoiceDemo />

      {/* Founder & Heritage Story Section */}
      <section
        id="why"
        className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-background scroll-mt-16"
      >
        <div className="max-w-7xl mx-auto">
          <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4">
            WHY WE BUILT IT
          </p>
          <h2 className="font-serif text-4xl md:text-5xl font-bold text-foreground mb-12">
            Some recipes only one person knows how to make.
          </h2>

          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            <div>
              <p className="text-lg text-muted-foreground leading-relaxed mb-6">
                Hodari and Shylah Touré built Legacy Table after losing a
                grandmother's gumbo recipe to a hospital stay no one expected.
                The app is a love letter to every family that has watched a
                dish disappear with a person — and a tool for the families
                that don't have to.
              </p>
            </div>
            <div className="flex justify-center lg:justify-end">
              <div className="w-full max-w-md rounded-2xl overflow-hidden shadow-xl">
                <img
                  src={`${process.env.PUBLIC_URL || ""}/founders.jpg`}
                  alt="Hodari and Shylah Touré, founders of Legacy Table"
                  className="w-full h-auto block"
                  loading="lazy"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Trust Section */}
      <section className="py-20 md:py-24 px-4 md:px-6 lg:px-8 bg-background border-t border-border/50">
        <div className="max-w-7xl mx-auto">
          <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-12 text-center">
            BUILT FOR FAMILIES, NOT FOR FEEDS
          </p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-12 text-center">
            <div>
              <div className="flex justify-center mb-4">
                <Shield className="w-12 h-12 text-primary" />
              </div>
              <h4 className="font-serif text-xl font-semibold text-foreground mb-2">
                Your recipes, your data
              </h4>
            </div>

            <div>
              <div className="flex justify-center mb-4">
                <Lock className="w-12 h-12 text-primary" />
              </div>
              <h4 className="font-serif text-xl font-semibold text-foreground mb-2">
                No public profiles
              </h4>
            </div>

            <div>
              <div className="flex justify-center mb-4">
                <Download className="w-12 h-12 text-primary" />
              </div>
              <h4 className="font-serif text-xl font-semibold text-foreground mb-2">
                Export everything, anytime
              </h4>
            </div>
          </div>
        </div>
      </section>

      {/* The Keeper — name the buyer, and say the honest thing about time. */}
      <section className="py-20 md:py-28 px-4 md:px-6 lg:px-8 bg-muted">
        <div className="max-w-3xl mx-auto text-center">
          <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4">
            FOR THE KEEPER OF THE RECIPES
          </p>
          <h2 className="font-serif text-4xl md:text-5xl font-bold text-foreground mb-6">
            Every family has one person who keeps the recipes.
          </h2>
          <p className="text-lg md:text-xl text-muted-foreground leading-relaxed mb-4">
            If you're reading this, it's probably you.
          </p>
          <p className="text-lg md:text-xl text-foreground leading-relaxed font-medium mb-10">
            The hardest part of this work is that it can't be done later.
            Record them while they can still tell you how.
          </p>
          <Button
            size="lg"
            className="rounded-full"
            onClick={() => scrollToId("get-the-app")}
          >
            Start your family's cookbook
          </Button>
        </div>
      </section>

      {/* Final CTA / Get The App Section
          No pricing on the landing page — subscriptions live in the app
          (App Store / Play Store handle billing). Visitors download free,
          subscribe inside the app if they want a paid tier. */}
      <section
        id="get-the-app"
        className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-secondary text-secondary-foreground scroll-mt-16"
      >
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="font-serif text-4xl md:text-5xl font-bold mb-4">
            Start your family's cookbook today.
          </h2>
          <p className="text-lg md:text-xl mb-10 opacity-90">
            Free to download on iOS and Android. Subscribe in-app whenever
            your family is ready.
          </p>

          <StoreBadges size="large" align="center" className="mb-6" placement="footer_cta" />

          <p className="text-sm opacity-75 mb-10">
            Already have an account?{" "}
            <Link
              to="/login"
              className="underline hover:no-underline font-medium"
            >
              Sign in
            </Link>
          </p>

          <EmailCapture />

          <div className="text-xs opacity-75 space-y-1">
            <p>
              © 2026 Ubuntu Markets LLC · legacytable.app ·
              support@ubuntu-village.org
            </p>
            <div className="flex justify-center gap-4 text-xs">
              <a href="/guides/" className="hover:underline">
                Guides
              </a>
              <span>·</span>
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

export default LandingPage;
