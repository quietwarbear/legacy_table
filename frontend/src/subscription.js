import React, { useState, useEffect, createContext, useContext, useCallback } from "react";
import { useNavigate, useSearchParams, Link } from "react-router-dom";
import { useAuth } from "./App";
import axios from "axios";
import { toast } from "sonner";
import { Crown, Check, Star, ArrowLeft, Loader2, ExternalLink } from "lucide-react";

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || "";
const API = `${BACKEND_URL}/api`;

// ===================== STRIPE PRICE IDS =====================

const PRICES = {
  heritage: {
    monthly: { id: "price_1TCNF2Ak1UyEdCJUJKEmydMm", amount: 9.99 },
    annual:  { id: "price_1TCMgEAk1UyEdCJUozc8nt8L", amount: 99.99 },
  },
  legacy: {
    monthly: { id: "price_1TCND7Ak1UyEdCJUQCBO5leT", amount: 19.99 },
    annual:  { id: "price_1TCMiqAk1UyEdCJUomu9wkct", amount: 199.99 },
  },
};

const TIER_FEATURES = {
  heritage: [
    "15 AI credits per month",
    "Unlimited family recipe storage",
    "Family sharing (up to 10 members)",
    "Photo uploads for every recipe",
    "Export & print recipe books",
    "Recipe categories & tags",
  ],
  legacy: [
    "50 AI credits per month",
    "Everything in Heritage Keeper",
    "Unlimited family members",
    "Advanced recipe organization",
    "Priority customer support",
    "Early access to new features",
    "Custom family cookbook themes",
  ],
};

// ===================== SUBSCRIPTION CONTEXT =====================

const SubscriptionContext = createContext(null);

export const useSubscription = () => useContext(SubscriptionContext);

export const SubscriptionProvider = ({ children }) => {
  const { user, token } = useAuth();
  const [tier, setTier] = useState(null); // "heritage" | "legacy" | null
  const [credits, setCredits] = useState({ balance: 0, refreshAt: null, monthlyAllowance: 3 });
  const [loading, setLoading] = useState(true);

  const fetchStatus = useCallback(async () => {
    if (!token) {
      setTier(null);
      setCredits({ balance: 0, refreshAt: null, monthlyAllowance: 3 });
      setLoading(false);
      return;
    }
    try {
      const res = await axios.get(`${API}/subscriptions/status`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setTier(res.data.subscription_tier || null);
      setCredits({
        balance: res.data.credits_balance ?? 0,
        refreshAt: res.data.credits_refresh_at ?? null,
        monthlyAllowance: res.data.monthly_allowance ?? 3,
      });
    } catch {
      setTier(null);
    }
    setLoading(false);
  }, [token]);

  useEffect(() => {
    fetchStatus();
  }, [fetchStatus]);

  const hasAny = tier != null;
  const hasHeritage = tier === "heritage" || tier === "legacy";
  const hasLegacy = tier === "legacy";

  // Check if user can access a feature gated at a given minimum tier
  const canAccess = (minTier) => {
    if (!minTier || minTier === "free") return true;
    if (minTier === "heritage") return hasHeritage;
    if (minTier === "legacy") return hasLegacy;
    return false;
  };

  // Check if user has enough credits for a feature
  const hasCredits = (cost = 1) => credits.balance >= cost;

  return (
    <SubscriptionContext.Provider
      value={{ tier, loading, hasAny, hasHeritage, hasLegacy, canAccess, hasCredits, credits, refetch: fetchStatus }}
    >
      {children}
    </SubscriptionContext.Provider>
  );
};

// ===================== FEATURE GATE COMPONENT =====================

export const FeatureGate = ({ minTier = "heritage", children, fallback }) => {
  const { canAccess, loading } = useSubscription();
  const navigate = useNavigate();

  if (loading) return null;

  if (!canAccess(minTier)) {
    if (fallback) return fallback;
    // Redirect to pricing with a return URL
    return (
      <div className="min-h-screen flex flex-col items-center justify-center bg-background p-6 text-center">
        <Crown className="w-16 h-16 text-amber-500 mb-4" />
        <h2 className="text-2xl font-serif font-bold text-foreground mb-2">
          Upgrade to {minTier === "legacy" ? "Legacy Collection" : "Heritage Keeper"}
        </h2>
        <p className="text-muted-foreground mb-6 max-w-md">
          This feature requires a {minTier === "legacy" ? "Legacy Collection" : "Heritage Keeper"} subscription
          or higher to access.
        </p>
        <button
          onClick={() => navigate("/pricing", { state: { returnTo: window.location.pathname } })}
          className="px-6 py-3 bg-amber-600 hover:bg-amber-700 text-white rounded-full font-medium transition-colors"
        >
          View Plans
        </button>
        <button
          onClick={() => navigate(-1)}
          className="mt-3 text-sm text-muted-foreground hover:text-foreground transition-colors"
        >
          Go back
        </button>
      </div>
    );
  }

  return children;
};

// ===================== CREDITS BADGE =====================

export const CreditsBadge = ({ className = "" }) => {
  const { credits, tier, loading } = useSubscription();
  const navigate = useNavigate();

  if (loading) return null;

  const pct = credits.monthlyAllowance > 0
    ? Math.round((credits.balance / credits.monthlyAllowance) * 100)
    : 0;

  return (
    <button
      onClick={() => navigate("/pricing")}
      className={`flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${
        credits.balance === 0
          ? "bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-300"
          : pct <= 30
          ? "bg-amber-100 dark:bg-amber-900/30 text-amber-700 dark:text-amber-300"
          : "bg-emerald-100 dark:bg-emerald-900/30 text-emerald-700 dark:text-emerald-300"
      } ${className}`}
      title={`${credits.balance} of ${credits.monthlyAllowance} credits remaining this month`}
    >
      <Star className="w-3.5 h-3.5" />
      {credits.balance} credit{credits.balance !== 1 ? "s" : ""}
    </button>
  );
};

// ===================== CREDITS GATE =====================

export const CreditsGate = ({ cost = 1, featureName = "This feature", children }) => {
  const { hasCredits } = useSubscription();
  const navigate = useNavigate();

  if (!hasCredits(cost)) {
    return (
      <div className="flex flex-col items-center justify-center p-6 text-center">
        <Star className="w-12 h-12 text-amber-500 mb-3" />
        <h3 className="text-lg font-serif font-bold text-foreground mb-1">
          Out of Credits
        </h3>
        <p className="text-sm text-muted-foreground mb-4 max-w-sm">
          {featureName} requires {cost} credit{cost > 1 ? "s" : ""}.
          Upgrade your plan for more credits each month.
        </p>
        <button
          onClick={() => navigate("/pricing")}
          className="px-5 py-2.5 bg-amber-600 hover:bg-amber-700 text-white rounded-full text-sm font-medium transition-colors"
        >
          Upgrade Plan
        </button>
      </div>
    );
  }

  return children;
};

// ===================== PRICING PAGE =====================

export const PricingPage = () => {
  const { token } = useAuth();
  const { tier, hasAny } = useSubscription();
  const navigate = useNavigate();
  const [annual, setAnnual] = useState(true);
  const [loadingTier, setLoadingTier] = useState(null);

  // Reset loading state when user returns from Stripe (bfcache / pageshow)
  useEffect(() => {
    const resetLoading = (e) => {
      if (e.persisted) setLoadingTier(null);
    };
    window.addEventListener("pageshow", resetLoading);
    const handleFocus = () => setLoadingTier(null);
    window.addEventListener("focus", handleFocus);
    return () => {
      window.removeEventListener("pageshow", resetLoading);
      window.removeEventListener("focus", handleFocus);
    };
  }, []);

  const handleSubscribe = async (selectedTier) => {
    if (!token) {
      navigate("/login");
      return;
    }

    const priceId = annual
      ? PRICES[selectedTier].annual.id
      : PRICES[selectedTier].monthly.id;

    setLoadingTier(selectedTier);
    try {
      const res = await axios.post(
        `${API}/subscriptions/create-checkout-session`,
        {
          price_id: priceId,
          success_url: `${window.location.origin}/subscription/success`,
          cancel_url: `${window.location.origin}/subscribe`,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      window.location.href = res.data.checkout_url;
    } catch (err) {
      toast.error("Could not start checkout. Please try again.");
      setLoadingTier(null);
    }
  };

  const handleManage = async () => {
    setLoadingTier("manage");
    try {
      const res = await axios.post(
        `${API}/subscriptions/create-portal-session`,
        {},
        { headers: { Authorization: `Bearer ${token}` } }
      );
      window.location.href = res.data.portal_url;
    } catch {
      toast.error("Could not open subscription management.");
      setLoadingTier(null);
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="px-6 py-4 flex items-center gap-3 border-b border-border">
        <button onClick={() => navigate(-1)} className="text-muted-foreground hover:text-foreground">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-lg font-serif font-bold text-foreground">Choose Your Plan</h1>
      </div>

      <div className="max-w-3xl mx-auto px-6 py-10">
        {/* Tagline */}
        <div className="text-center mb-8">
          <Crown className="w-12 h-12 text-amber-500 mx-auto mb-3" />
          <h2 className="text-3xl font-serif font-bold text-foreground mb-2">
            Preserve Your Family's Culinary Legacy
          </h2>
          <p className="text-muted-foreground">
            Upgrade to unlock the full power of Legacy Table
          </p>
        </div>

        {/* Billing Toggle */}
        <div className="flex items-center justify-center gap-3 mb-8">
          <span className={`text-sm ${!annual ? "text-foreground font-medium" : "text-muted-foreground"}`}>
            Monthly
          </span>
          <button
            onClick={() => setAnnual(!annual)}
            className={`relative w-14 h-7 rounded-full transition-colors ${
              annual ? "bg-amber-600" : "bg-muted"
            }`}
          >
            <div
              className={`absolute top-0.5 w-6 h-6 rounded-full bg-white shadow transition-transform ${
                annual ? "translate-x-7" : "translate-x-0.5"
              }`}
            />
          </button>
          <span className={`text-sm ${annual ? "text-foreground font-medium" : "text-muted-foreground"}`}>
            Annual
          </span>
          {annual && (
            <span className="text-xs bg-green-100 dark:bg-green-900 text-green-700 dark:text-green-300 px-2 py-0.5 rounded-full font-medium">
              Save ~17%
            </span>
          )}
        </div>

        {/* Already subscribed banner */}
        {hasAny && (
          <div className="bg-green-50 dark:bg-green-900/30 border border-green-200 dark:border-green-800 rounded-xl p-4 mb-8 text-center">
            <p className="text-green-800 dark:text-green-200 font-medium">
              You're on the <span className="capitalize">{tier === "heritage" ? "Heritage Keeper" : "Legacy Collection"}</span> plan
            </p>
            <button
              onClick={handleManage}
              disabled={loadingTier === "manage"}
              className="mt-2 text-sm text-green-700 dark:text-green-300 underline hover:no-underline"
            >
              {loadingTier === "manage" ? "Opening..." : "Manage subscription"}
            </button>
          </div>
        )}

        {/* Tier Cards */}
        <div className="grid md:grid-cols-2 gap-6">
          {/* Heritage Keeper */}
          <div className={`border rounded-2xl p-6 transition-all ${
            tier === "heritage"
              ? "border-amber-500 bg-amber-50/50 dark:bg-amber-900/20"
              : "border-border hover:border-amber-300"
          }`}>
            <div className="mb-4">
              <h3 className="text-xl font-serif font-bold text-foreground">Heritage Keeper</h3>
              <p className="text-sm text-muted-foreground mt-1">Perfect for getting started</p>
            </div>
            <div className="mb-6">
              <span className="text-4xl font-bold text-foreground">
                ${annual ? PRICES.heritage.annual.amount : PRICES.heritage.monthly.amount}
              </span>
              <span className="text-muted-foreground">/{annual ? "year" : "month"}</span>
              {annual && (
                <p className="text-xs text-muted-foreground mt-1">
                  ~$8.33/month
                </p>
              )}
            </div>
            <ul className="space-y-3 mb-6">
              {TIER_FEATURES.heritage.map((f, i) => (
                <li key={i} className="flex items-start gap-2 text-sm text-foreground">
                  <Check className="w-4 h-4 text-amber-600 mt-0.5 flex-shrink-0" />
                  {f}
                </li>
              ))}
            </ul>
            {tier === "heritage" ? (
              <div className="w-full py-3 text-center text-amber-700 dark:text-amber-300 bg-amber-100 dark:bg-amber-900/40 rounded-full font-medium text-sm">
                Current Plan
              </div>
            ) : (
              <button
                onClick={() => handleSubscribe("heritage")}
                disabled={loadingTier === "heritage" || hasAny}
                className="w-full py-3 bg-stone-800 dark:bg-stone-200 text-white dark:text-stone-900 rounded-full font-medium hover:opacity-90 transition-opacity disabled:opacity-50 text-sm"
              >
                {loadingTier === "heritage" ? "Loading..." : hasAny ? "Current or lower" : "Get Heritage Keeper"}
              </button>
            )}
          </div>

          {/* Legacy Collection */}
          <div className={`border rounded-2xl p-6 relative transition-all ${
            tier === "legacy"
              ? "border-amber-500 bg-amber-50/50 dark:bg-amber-900/20"
              : "border-amber-400 shadow-lg shadow-amber-100 dark:shadow-amber-900/20"
          }`}>
            <div className="absolute -top-3 right-4 bg-amber-600 text-white text-xs font-bold px-3 py-1 rounded-full">
              Most Popular
            </div>
            <div className="mb-4">
              <h3 className="text-xl font-serif font-bold text-foreground">Legacy Collection</h3>
              <p className="text-sm text-muted-foreground mt-1">For the whole family</p>
            </div>
            <div className="mb-6">
              <span className="text-4xl font-bold text-foreground">
                ${annual ? PRICES.legacy.annual.amount : PRICES.legacy.monthly.amount}
              </span>
              <span className="text-muted-foreground">/{annual ? "year" : "month"}</span>
              {annual && (
                <p className="text-xs text-muted-foreground mt-1">
                  ~$16.67/month
                </p>
              )}
            </div>
            <ul className="space-y-3 mb-6">
              {TIER_FEATURES.legacy.map((f, i) => (
                <li key={i} className="flex items-start gap-2 text-sm text-foreground">
                  <Check className="w-4 h-4 text-amber-600 mt-0.5 flex-shrink-0" />
                  {f}
                </li>
              ))}
            </ul>
            {tier === "legacy" ? (
              <div className="w-full py-3 text-center text-amber-700 dark:text-amber-300 bg-amber-100 dark:bg-amber-900/40 rounded-full font-medium text-sm">
                Current Plan
              </div>
            ) : (
              <button
                onClick={() => handleSubscribe("legacy")}
                disabled={loadingTier === "legacy"}
                className="w-full py-3 bg-amber-600 hover:bg-amber-700 text-white rounded-full font-medium transition-colors disabled:opacity-50 text-sm"
              >
                {loadingTier === "legacy" ? "Loading..." : "Get Legacy Collection"}
              </button>
            )}
          </div>
        </div>

        {/* Free tier note */}
        {!hasAny && (
          <div className="text-center mt-8">
            <button
              onClick={() => navigate("/")}
              className="text-sm text-muted-foreground hover:text-foreground transition-colors"
            >
              Continue with free plan (limited features)
            </button>
          </div>
        )}
      </div>
    </div>
  );
};

// ===================== SUCCESS PAGE =====================

export const SubscriptionSuccessPage = () => {
  const navigate = useNavigate();
  const { refetch } = useSubscription();
  const [searchParams] = useSearchParams();

  useEffect(() => {
    // Refetch subscription status after successful checkout
    const timer = setTimeout(() => {
      refetch();
    }, 2000);
    return () => clearTimeout(timer);
  }, [refetch]);

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-background p-6 text-center">
      <div className="w-20 h-20 bg-green-100 dark:bg-green-900/30 rounded-full flex items-center justify-center mb-6">
        <Check className="w-10 h-10 text-green-600" />
      </div>
      <h1 className="text-3xl font-serif font-bold text-foreground mb-2">Welcome to the Family!</h1>
      <p className="text-muted-foreground mb-8 max-w-md">
        Your subscription is now active. Start preserving your family's culinary legacy with all the premium features.
      </p>
      <button
        onClick={() => navigate("/")}
        className="px-8 py-3 bg-amber-600 hover:bg-amber-700 text-white rounded-full font-medium transition-colors"
      >
        Start Cooking
      </button>
    </div>
  );
};
