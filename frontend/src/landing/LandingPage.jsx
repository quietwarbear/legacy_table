import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../App";
import { Button } from "../components/ui/button";
import { Card, CardContent } from "../components/ui/card";
import { BookHeart, Mic, Users, Shield, Lock, Download } from "lucide-react";

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
              Capture the recipes that matter, the stories behind them, and the voices that teach them. Build your family's cookbook together.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 mb-8">
              <Button
                size="lg"
                className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full"
                onClick={() => {
                  // TODO: Replace with actual App Store URL
                  window.location.href = "https://apps.apple.com/";
                }}
              >
                <img
                  src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 140 42'%3E%3Ctext x='10' y='28' font-family='Arial' font-size='14' fill='white'%3EApp Store%3C/text%3E%3C/svg%3E"
                  alt="Download on the App Store"
                  className="h-6"
                />
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="rounded-full"
                onClick={() => {
                  document.getElementById("features")?.scrollIntoView({ behavior: "smooth" });
                }}
              >
                See how it works
              </Button>
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

      {/* Features Section */}
      <section id="features" className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-muted">
        <div className="max-w-7xl mx-auto">
          <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4 text-center">
            WHAT IT DOES
          </p>
          <h2 className="font-serif text-4xl md:text-5xl font-bold text-center mb-16">
            Everything a family needs to preserve its recipes.
          </h2>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {/* Feature 1 */}
            <Card className="border-0 shadow-md">
              <CardContent className="p-8">
                <div className="mb-6 flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
                  <BookHeart className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-serif text-2xl font-bold text-foreground mb-3">
                  Recipes with the story attached
                </h3>
                <p className="text-muted-foreground leading-relaxed">
                  Every dish carries a name, a person, a moment. Capture the why, not just the how.
                </p>
              </CardContent>
            </Card>

            {/* Feature 2 */}
            <Card className="border-0 shadow-md">
              <CardContent className="p-8">
                <div className="mb-6 flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
                  <Mic className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-serif text-2xl font-bold text-foreground mb-3">
                  Voice notes from the cooks who taught you
                </h3>
                <p className="text-muted-foreground leading-relaxed">
                  Record Aunt Rita explaining the roux. Tag photos of every step. Keep the voices in the kitchen forever.
                </p>
              </CardContent>
            </Card>

            {/* Feature 3 */}
            <Card className="border-0 shadow-md">
              <CardContent className="p-8">
                <div className="mb-6 flex items-center justify-center w-12 h-12 rounded-lg bg-primary/10">
                  <Users className="w-6 h-6 text-primary" />
                </div>
                <h3 className="font-serif text-2xl font-bold text-foreground mb-3">
                  A cookbook your whole family writes
                </h3>
                <p className="text-muted-foreground leading-relaxed">
                  Invite siblings, cousins, and elders. Build the family canon together — and pass it down.
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Founder & Heritage Story Section */}
      <section className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-background">
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
                Hodari and Shylah Touré built Legacy Table after losing a grandmother's gumbo recipe to a hospital stay no one expected. The app is a love letter to every family that has watched a dish disappear with a person — and a tool for the families that don't have to.
              </p>
            </div>
            <div className="flex justify-center lg:justify-end">
              <div className="w-full max-w-sm aspect-[4/5] rounded-2xl bg-muted shadow-xl flex items-center justify-center">
                {/* TODO: founder photo */}
                <p className="text-muted-foreground">Founder photo</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section className="py-20 md:py-24 px-4 md:px-6 lg:px-8 bg-muted">
        <div className="max-w-7xl mx-auto">
          <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4 text-center">
            PRICING
          </p>
          <h3 className="font-serif text-3xl md:text-4xl font-bold text-center mb-12">
            Free for one family. Paid plans when you grow.
          </h3>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <Card className="border border-border bg-card rounded-lg overflow-hidden shadow-sm">
              <CardContent className="p-6">
                <h4 className="font-semibold text-lg text-foreground mb-1">Free</h4>
                <p className="text-sm text-muted-foreground">1 family, unlimited recipes</p>
              </CardContent>
            </Card>

            <Card className="border border-border bg-card rounded-lg overflow-hidden shadow-sm">
              <CardContent className="p-6">
                <h4 className="font-semibold text-lg text-foreground mb-1">Family Plus</h4>
                <p className="text-sm text-muted-foreground">$4.99/mo, unlimited members + exports</p>
              </CardContent>
            </Card>

            <Card className="border border-border bg-card rounded-lg overflow-hidden shadow-sm">
              <CardContent className="p-6">
                <h4 className="font-semibold text-lg text-foreground mb-1">Heirloom</h4>
                <p className="text-sm text-muted-foreground">$49/yr, everything + voice transcription</p>
              </CardContent>
            </Card>
          </div>

          <div className="text-center">
            <p className="text-muted-foreground">Pricing built for families.</p>
          </div>
        </div>
      </section>

      {/* Trust Section */}
      <section className="py-20 md:py-24 px-4 md:px-6 lg:px-8 bg-background">
        <div className="max-w-7xl mx-auto">
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

      {/* Final CTA Section */}
      <section className="py-20 md:py-32 px-4 md:px-6 lg:px-8 bg-secondary text-secondary-foreground">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="font-serif text-4xl md:text-5xl font-bold mb-4">
            Start your family's cookbook today.
          </h2>
          <p className="text-lg md:text-xl mb-8 opacity-90">
            Free on iOS. Android coming soon.
          </p>

          <Button
            size="lg"
            className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full mb-12"
            onClick={() => {
              // TODO: Replace with actual App Store URL
              window.location.href = "https://apps.apple.com/";
            }}
          >
            <img
              src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 140 42'%3E%3Ctext x='10' y='28' font-family='Arial' font-size='14' fill='white'%3EApp Store%3C/text%3E%3C/svg%3E"
              alt="Download on the App Store"
              className="h-6"
            />
          </Button>

          <div className="text-xs opacity-75 space-y-1">
            <p>© 2026 Ubuntu Markets LLC · legacytable.app · contact@ubuntu-markets.org</p>
            <div className="flex justify-center gap-4 text-xs">
              <a href="/privacy-policy" className="hover:underline">Privacy Policy</a>
              <span>·</span>
              {/* TODO: Add Terms of Service page */}
              <a href="#" className="hover:underline opacity-50 cursor-not-allowed">Terms of Service</a>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
};

export default LandingPage;
