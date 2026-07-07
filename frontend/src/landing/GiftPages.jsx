import React, { useEffect, useRef, useState } from "react";
import { Link } from "react-router-dom";
import { useAuth } from "../App";
import { trackEvent } from "../lib/track";
import { Button } from "../components/ui/button";

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || "";
const API = `${BACKEND_URL}/api`;

// Shared minimal header for the standalone gift/redeem pages.
const GiftHeader = () => (
  <header className="sticky top-0 z-50 w-full bg-background/85 backdrop-blur border-b border-border">
    <div className="max-w-7xl mx-auto px-4 md:px-6 lg:px-8 h-16 flex items-center justify-between">
      <Link to="/" className="font-serif text-xl font-bold text-foreground">
        Legacy Table
      </Link>
      <Link to="/pricing" className="text-sm font-semibold text-foreground/80 hover:text-foreground">
        Pricing
      </Link>
    </div>
  </header>
);

// ----------------------------------------------------------------------------
// /gift — the Family Legacy gift purchase page. The buyer (the keeper's
// daughter, usually) needs no account; Stripe handles payment, the success
// page hands over a code to give.
// ----------------------------------------------------------------------------
export const GiftPage = () => {
  const [email, setEmail] = useState("");
  const [recipientName, setRecipientName] = useState("");
  const [status, setStatus] = useState("idle"); // idle | working | error

  const startCheckout = async (e) => {
    e.preventDefault();
    if (!email || status === "working") return;
    setStatus("working");
    trackEvent("gift_checkout_started", {});
    try {
      const res = await fetch(`${API}/gift/checkout`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          purchaser_email: email,
          recipient_name: recipientName || null,
          success_url: `${window.location.origin}/gift/success`,
          cancel_url: `${window.location.origin}/gift`,
        }),
      });
      if (!res.ok) throw new Error("checkout failed");
      const data = await res.json();
      window.location.href = data.checkout_url;
    } catch {
      setStatus("error");
    }
  };

  return (
    <div className="min-h-screen bg-background text-foreground">
      <GiftHeader />
      <section className="py-16 md:py-24 px-4 md:px-6 max-w-3xl mx-auto">
        <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4 text-center">
          THE FAMILY LEGACY GIFT
        </p>
        <h1 className="font-serif text-4xl md:text-5xl font-bold text-center mb-6">
          Give the family table.
        </h1>
        <p className="text-lg text-muted-foreground text-center max-w-xl mx-auto mb-10 leading-relaxed">
          One year of Legacy Table for their whole family — plus a printed
          heirloom cookbook whose pages play the voices behind the recipes.
        </p>

        <div className="rounded-2xl bg-card border border-border shadow-md p-8 mb-10">
          <div className="flex items-baseline justify-center gap-2 mb-6">
            <span className="font-serif text-5xl font-bold">$99</span>
            <span className="text-muted-foreground">once — not a subscription</span>
          </div>
          <ul className="space-y-3 text-foreground/90 mb-2">
            <li>· A full year of <strong>Family Legacy</strong> — unlimited family members, 50 AI credits a month</li>
            <li>· A <strong>printed heirloom cookbook</strong> of their family's recipes</li>
            <li>· QR codes on its pages that <strong>play the cook's own voice</strong></li>
            <li>· A gift code you can put in a card — no app needed to give it</li>
          </ul>
        </div>

        <form onSubmit={startCheckout} className="max-w-md mx-auto space-y-4" data-testid="gift-form">
          <input
            type="email"
            required
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="Your email (for the receipt & gift code)"
            className="w-full rounded-full px-5 py-3 text-sm bg-background border border-border focus:outline-none focus:ring-2 focus:ring-primary"
            data-testid="gift-email-input"
          />
          <input
            type="text"
            value={recipientName}
            onChange={(e) => setRecipientName(e.target.value)}
            placeholder="Who's it for? (optional — e.g. Mom)"
            className="w-full rounded-full px-5 py-3 text-sm bg-background border border-border focus:outline-none focus:ring-2 focus:ring-primary"
            data-testid="gift-recipient-input"
          />
          <Button type="submit" size="lg" className="w-full rounded-full" disabled={status === "working"}>
            {status === "working" ? "Opening secure checkout…" : "Give Family Legacy — $99"}
          </Button>
          {status === "error" && (
            <p className="text-sm text-center text-muted-foreground">
              That didn't go through — mind trying again?
            </p>
          )}
          <p className="text-xs text-center text-muted-foreground">
            Secure payment by Stripe. The cookbook is created together with
            the family and printed when they're ready.
          </p>
        </form>
      </section>
    </div>
  );
};

// ----------------------------------------------------------------------------
// /gift/success — reveal the gift code. Polls briefly: the Stripe webhook
// mints the code moments after redirect.
// ----------------------------------------------------------------------------
export const GiftSuccessPage = () => {
  const [gift, setGift] = useState(null);
  const [gaveUp, setGaveUp] = useState(false);
  const tries = useRef(0);

  useEffect(() => {
    const sessionId = new URLSearchParams(window.location.search).get("session_id");
    if (!sessionId) {
      setGaveUp(true);
      return;
    }
    let cancelled = false;
    const poll = async () => {
      try {
        const res = await fetch(`${API}/gift/by-session/${sessionId}`);
        if (res.ok) {
          const data = await res.json();
          if (!cancelled) {
            setGift(data);
            trackEvent("gift_purchased", {});
          }
          return;
        }
      } catch {
        // transient — keep polling
      }
      tries.current += 1;
      if (tries.current < 15 && !cancelled) {
        setTimeout(poll, 2000);
      } else if (!cancelled) {
        setGaveUp(true);
      }
    };
    poll();
    return () => {
      cancelled = true;
    };
  }, []);

  return (
    <div className="min-h-screen bg-background text-foreground">
      <GiftHeader />
      <section className="py-16 md:py-24 px-4 md:px-6 max-w-2xl mx-auto text-center">
        {gift ? (
          <>
            <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4">
              THE GIFT IS READY
            </p>
            <h1 className="font-serif text-4xl font-bold mb-6">
              {gift.recipient_name ? `For ${gift.recipient_name}.` : "Here's the code."}
            </h1>
            <div
              className="font-mono text-3xl md:text-4xl font-bold tracking-widest rounded-2xl bg-card border-2 border-primary/40 py-8 px-4 mb-6 select-all"
              data-testid="gift-code"
            >
              {gift.code}
            </div>
            <p className="text-muted-foreground leading-relaxed mb-8">
              Write it in a card, text it, or say it over dinner. They redeem
              it at{" "}
              <span className="text-foreground font-medium">legacytable.app/redeem</span>{" "}
              — or in the app under Settings — and their year begins.
            </p>
            <p className="text-sm text-muted-foreground">
              A receipt is in your email. Keep this code private until you
              give it — it's the whole gift.
            </p>
          </>
        ) : gaveUp ? (
          <>
            <h1 className="font-serif text-3xl font-bold mb-4">Almost there</h1>
            <p className="text-muted-foreground">
              Your payment went through, but the gift code is taking a moment.
              Refresh this page in a minute — or write us at
              contact@ubuntu-markets.org with your receipt and we'll send it.
            </p>
          </>
        ) : (
          <p className="text-muted-foreground" data-testid="gift-waiting">
            Wrapping your gift…
          </p>
        )}
      </section>
    </div>
  );
};

// ----------------------------------------------------------------------------
// /redeem — where the recipient turns the code into their year.
// ----------------------------------------------------------------------------
export const RedeemPage = () => {
  const { user } = useAuth();
  const [code, setCode] = useState("");
  const [status, setStatus] = useState("idle"); // idle | working | done
  const [error, setError] = useState("");

  const redeem = async (e) => {
    e.preventDefault();
    if (!code || status === "working") return;
    setStatus("working");
    setError("");
    try {
      const token = localStorage.getItem("token");
      const res = await fetch(`${API}/gift/redeem`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ code }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Couldn't redeem that code");
      trackEvent("gift_redeemed", {});
      setStatus("done");
    } catch (err) {
      setStatus("idle");
      setError(err.message);
    }
  };

  return (
    <div className="min-h-screen bg-background text-foreground">
      <GiftHeader />
      <section className="py-16 md:py-24 px-4 md:px-6 max-w-xl mx-auto text-center">
        <p className="text-sm uppercase tracking-widest text-primary font-semibold mb-4">
          REDEEM A GIFT
        </p>
        <h1 className="font-serif text-4xl font-bold mb-6">
          Someone gave you the table.
        </h1>

        {status === "done" ? (
          <div data-testid="redeem-done">
            <p className="text-lg leading-relaxed mb-8">
              Your year of <strong>Family Legacy</strong> has begun — unlimited
              family members, 50 AI credits a month, and a printed heirloom
              cookbook when your family's ready to make one.
            </p>
            <Button size="lg" className="rounded-full" asChild>
              <Link to="/home">Start preserving recipes</Link>
            </Button>
          </div>
        ) : !user ? (
          <div data-testid="redeem-signin">
            <p className="text-muted-foreground leading-relaxed mb-8">
              Sign in (or create a free account) first, then come back here to
              enter your gift code.
            </p>
            <Button size="lg" className="rounded-full" asChild>
              <Link to="/login">Sign in to redeem</Link>
            </Button>
          </div>
        ) : (
          <form onSubmit={redeem} className="space-y-4" data-testid="redeem-form">
            <input
              type="text"
              required
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              placeholder="GIFT-XXXX-XXXX"
              className="w-full rounded-full px-5 py-4 text-center font-mono text-lg tracking-widest bg-background border border-border focus:outline-none focus:ring-2 focus:ring-primary"
              data-testid="redeem-code-input"
            />
            <Button type="submit" size="lg" className="w-full rounded-full" disabled={status === "working"}>
              {status === "working" ? "Unwrapping…" : "Redeem gift"}
            </Button>
            {error && (
              <p className="text-sm text-muted-foreground" data-testid="redeem-error">
                {error}
              </p>
            )}
          </form>
        )}
      </section>
    </div>
  );
};
