import React, { useEffect } from "react";
import { Link, useNavigate } from "react-router-dom";
import { useAuth } from "../App";
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
const StoreBadges = ({ size = "default", align = "start", className = "" }) => {
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
              {/* TODO(PR 3): replace this placeholder with the real founder
                  photo. Keeping a styled placeholder rather than a broken
                  <img> so the alt text doesn't render as visible body copy. */}
              <div className="w-full max-w-sm aspect-[4/5] rounded-2xl bg-gradient-to-br from-primary/10 via-muted to-secondary/20 shadow-xl flex items-center justify-center">
                <p className="text-muted-foreground/60 text-sm">
                  Founder photo — coming soon
                </p>
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
              {/* TODO(PR 3): point at /terms once the page ships */}
              <a
                href="#"
                className="hover:underline opacity-50 cursor-not-allowed"
              >
                Terms of Service
              </a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default LandingPage;
