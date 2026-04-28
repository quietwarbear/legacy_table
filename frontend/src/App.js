import React, { useState, useEffect, createContext, useContext, useCallback } from "react";
import "@/App.css";
import { BrowserRouter, Routes, Route, Navigate, useNavigate, useLocation, Link, useParams } from "react-router-dom";
import axios from "axios";
import { Toaster, toast } from "sonner";
import { ChefHat, Utensils, Camera, Clock, Users, Flame, Heart, Plus, LogOut, Menu, X, Home, User, Search, Download, BookOpen, Moon, Sun, Edit, MessageCircle, Trash2, Send, Bell, Settings, Upload, Copy, Crown, UserPlus, Sparkles, Share2, Volume2, VolumeX, SkipForward, SkipBack, ChevronLeft, ChevronRight, Calendar, Gift, Tag, Link2, Video } from "lucide-react";
import * as familiesApi from "./api/families";
import jsPDF from "jspdf";
import { Button } from "./components/ui/button";
import { Input } from "./components/ui/input";
import { Label } from "./components/ui/label";
import { Textarea } from "./components/ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./components/ui/select";
import { Badge } from "./components/ui/badge";
import { Card, CardContent } from "./components/ui/card";
import { Checkbox } from "./components/ui/checkbox";
import {
  AlertDialog,
  AlertDialogContent,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogCancel,
} from "./components/ui/alert-dialog";

import { SubscriptionProvider, useSubscription, PricingPage, SubscriptionSuccessPage, CreditsBadge, CreditsGate } from "./subscription";
import LandingPage from "./landing/LandingPage";

const BACKEND_URL = process.env.REACT_APP_BACKEND_URL || "";
const API = `${BACKEND_URL}/api`;

// Sanitize string for safe JSON: strip control chars, normalize line endings, ensure string
function sanitizeForJson(value) {
  if (value == null || value === "") return value === "" ? "" : null;
  const s = String(value)
    .replace(/\r\n/g, "\n")
    .replace(/\r/g, "\n")
    .replace(/[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]/g, "");
  return s;
}

const isValidEmail = (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test((value || "").trim());

// Resize/compress a data URL image to reduce payload size and avoid truncation
function compressDataUrl(dataUrl, maxWidth = 1200, quality = 0.8) {
  return new Promise((resolve) => {
    const img = new Image();
    img.crossOrigin = "anonymous";
    img.onload = () => {
      const w = img.width;
      const h = img.height;
      const scale = w > maxWidth ? maxWidth / w : 1;
      const cw = Math.round(w * scale);
      const ch = Math.round(h * scale);
      const canvas = document.createElement("canvas");
      canvas.width = cw;
      canvas.height = ch;
      const ctx = canvas.getContext("2d");
      ctx.drawImage(img, 0, 0, cw, ch);
      try {
        resolve(canvas.toDataURL("image/jpeg", quality));
      } catch {
        resolve(dataUrl);
      }
    };
    img.onerror = () => resolve(dataUrl);
    img.src = dataUrl;
  });
}

async function compressPhotoList(photos) {
  if (!Array.isArray(photos) || photos.length === 0) return [];
  const out = [];
  for (const p of photos) {
    if (typeof p !== "string") continue;
    out.push(p.startsWith("data:") ? await compressDataUrl(p) : p);
  }
  return out;
}

// Theme Context
const ThemeContext = createContext(null);

export const useTheme = () => useContext(ThemeContext);

const ThemeProvider = ({ children }) => {
  const [isDark, setIsDark] = useState(() => {
    const saved = localStorage.getItem("theme");
    return saved === "dark";
  });

  useEffect(() => {
    if (isDark) {
      document.documentElement.classList.add("dark");
      localStorage.setItem("theme", "dark");
    } else {
      document.documentElement.classList.remove("dark");
      localStorage.setItem("theme", "light");
    }
  }, [isDark]);

  const toggleTheme = () => setIsDark(!isDark);

  return (
    <ThemeContext.Provider value={{ isDark, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

// Auth Context
const AuthContext = createContext(null);

export const useAuth = () => useContext(AuthContext);

const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(localStorage.getItem("token"));
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      if (token) {
        try {
          const response = await axios.get(`${API}/auth/me`, {
            headers: { Authorization: `Bearer ${token}` },
          });
          setUser(response.data);
        } catch (error) {
          localStorage.removeItem("token");
          setToken(null);
        }
      }
      setLoading(false);
    };
    fetchUser();
  }, [token]);

  const login = (newToken, userData) => {
    localStorage.setItem("token", newToken);
    setToken(newToken);
    setUser(userData);
  };

  const logout = () => {
    localStorage.removeItem("token");
    setToken(null);
    setUser(null);
  };

  const updateUser = (updatedData) => {
    setUser(prev => ({ ...prev, ...updatedData }));
  };

  // Get display name (nickname or name)
  const getDisplayName = (userData = user) => {
    return userData?.nickname || userData?.name || "User";
  };

  return (
    <AuthContext.Provider value={{ user, token, login, logout, loading, updateUser, getDisplayName }}>
      {children}
    </AuthContext.Provider>
  );
};

// Protected Route
const ProtectedRoute = ({ children }) => {
  const { user, loading } = useAuth();
  
  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <div className="animate-spin rounded-full h-12 w-12 border-4 border-primary border-t-transparent"></div>
      </div>
    );
  }
  
  if (!user) {
    return <Navigate to="/login" replace />;
  }
  
  return children;
};

// Family Logo Component — app-logo (light) / app-logo-white (dark)
const FamilyLogo = ({ size = "md", showText = true }) => {
  const { isDark } = useTheme();
  const sizes = {
    sm: { container: "w-10 h-10", text: "text-lg" },
    md: { container: "w-12 h-12", text: "text-xl" },
    lg: { container: "w-16 h-16", text: "text-2xl" },
    xl: { container: "w-24 h-24", text: "text-3xl" }
  };
  const s = sizes[size];
  const logoSrc = isDark
    ? `${process.env.PUBLIC_URL || ""}/app-logo-white.png`
    : `${process.env.PUBLIC_URL || ""}/app-logo.png`;

  return (
    <div className="flex items-center gap-3">
      <div className={`${s.container} relative flex shrink-0`}>
        <img
          src={logoSrc}
          alt="Legacy Table"
          className="w-full h-full object-contain"
        />
      </div>
      {showText && (
        <div className="flex flex-col">
          <span style={{ fontFamily: "'Dancing Script', cursive" }} className={`${s.text} font-semibold text-foreground leading-tight`}>Legacy Table</span>
          <span className="text-xs uppercase tracking-widest text-muted-foreground font-medium">Family Recipes</span>
        </div>
      )}
    </div>
  );
};

// Navigation Component
const Navigation = () => {
  const { user, logout, getDisplayName, token } = useAuth();
  const { isDark, toggleTheme } = useTheme();
  const navigate = useNavigate();
  const location = useLocation();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [showNotifications, setShowNotifications] = useState(false);

  useEffect(() => {
    if (user && token) {
      fetchUnreadCount();
      // Poll for new notifications every 30 seconds
      const interval = setInterval(fetchUnreadCount, 30000);
      return () => clearInterval(interval);
    }
  }, [user, token]);

  const fetchUnreadCount = async () => {
    try {
      const response = await axios.get(`${API}/notifications/unread-count`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setUnreadCount(response.data.count);
    } catch (error) {
      console.error("Failed to fetch notification count");
    }
  };

  const fetchNotifications = async () => {
    try {
      const response = await axios.get(`${API}/notifications`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setNotifications(response.data);
    } catch (error) {
      console.error("Failed to fetch notifications");
    }
  };

  const handleNotificationClick = async (notification) => {
    // Mark as read
    if (!notification.is_read) {
      try {
        await axios.put(`${API}/notifications/${notification.id}/read`, {}, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setUnreadCount(prev => Math.max(0, prev - 1));
        setNotifications(prev => 
          prev.map(n => n.id === notification.id ? { ...n, is_read: true } : n)
        );
      } catch (error) {
        console.error("Failed to mark notification as read");
      }
    }
    
    // Navigate to recipe if applicable
    if (notification.recipe_id) {
      navigate(`/recipe/${notification.recipe_id}`);
      setShowNotifications(false);
    }
  };

  const markAllAsRead = async () => {
    try {
      await axios.put(`${API}/notifications/read-all`, {}, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setUnreadCount(0);
      setNotifications(prev => prev.map(n => ({ ...n, is_read: true })));
    } catch (error) {
      console.error("Failed to mark all as read");
    }
  };

  const toggleNotifications = () => {
    if (!showNotifications) {
      fetchNotifications();
    }
    setShowNotifications(!showNotifications);
  };

  const handleLogout = () => {
    logout();
    navigate("/login");
    toast.success("Logged out successfully");
  };

  if (!user) return null;

  return (
    <>
      <nav className="sticky top-0 z-30 bg-card/80 backdrop-blur-md border-b border-border/50" data-testid="navigation">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16">
            <Link to="/" className="flex items-center gap-2" data-testid="nav-logo">
              <FamilyLogo size="sm" showText={false} />
              <span className="font-serif text-xl font-semibold text-foreground hidden sm:block">Legacy Table</span>
            </Link>

            {/* Desktop Nav */}
            <div className="hidden md:flex items-center gap-6">
              <Link 
                to="/" 
                className={`nav-link flex items-center gap-2 text-sm font-medium ${location.pathname === '/' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'}`}
                data-testid="nav-home"
              >
                <Home className="w-4 h-4" />
                Home
              </Link>
              <Link 
                to="/add-recipe" 
                className={`nav-link flex items-center gap-2 text-sm font-medium ${location.pathname === '/add-recipe' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'}`}
                data-testid="nav-add-recipe"
              >
                <Plus className="w-4 h-4" />
                Add Recipe
              </Link>
              <Link 
                to="/profile" 
                className={`nav-link flex items-center gap-2 text-sm font-medium ${location.pathname === '/profile' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'}`}
                data-testid="nav-profile"
              >
                <User className="w-4 h-4" />
                My Recipes
              </Link>
              <Link 
                to="/cookbook" 
                className={`nav-link flex items-center gap-2 text-sm font-medium ${location.pathname === '/cookbook' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'}`}
                data-testid="nav-cookbook"
              >
                <BookOpen className="w-4 h-4" />
                Family Cookbook
              </Link>
              <Link 
                to="/family" 
                className={`nav-link flex items-center gap-2 text-sm font-medium ${location.pathname === '/family' ? 'text-primary' : 'text-muted-foreground hover:text-foreground'}`}
                data-testid="nav-family"
              >
                <Users className="w-4 h-4" />
                Family
              </Link>
            </div>

            <div className="hidden md:flex items-center gap-3">
              {/* Credits Badge */}
              <CreditsBadge />

              {/* Upgrade Button */}
              <Link
                to="/subscribe"
                className="flex items-center gap-1.5 text-xs font-semibold px-3 py-1.5 rounded-full bg-primary/10 text-primary hover:bg-primary/20 transition-colors"
                data-testid="nav-upgrade"
              >
                <Crown className="w-3.5 h-3.5" />
                Upgrade
              </Link>

              {/* Notifications */}
              <div className="relative">
                <button
                  onClick={toggleNotifications}
                  className="p-2 rounded-full hover:bg-muted transition-colors relative"
                  data-testid="notifications-btn"
                  aria-label="Notifications"
                >
                  <Bell className="w-5 h-5 text-muted-foreground" />
                  {unreadCount > 0 && (
                    <span className="absolute -top-1 -right-1 w-5 h-5 bg-primary text-primary-foreground text-xs rounded-full flex items-center justify-center font-semibold">
                      {unreadCount > 9 ? '9+' : unreadCount}
                    </span>
                  )}
                </button>
                
                {/* Notifications Dropdown */}
                {showNotifications && (
                  <div className="absolute right-0 top-12 w-80 bg-card border border-border rounded-xl shadow-lg z-50 overflow-hidden" data-testid="notifications-dropdown">
                    <div className="p-3 border-b border-border flex items-center justify-between">
                      <h3 className="font-semibold">Notifications</h3>
                      {unreadCount > 0 && (
                        <button onClick={markAllAsRead} className="text-xs text-primary hover:underline">
                          Mark all as read
                        </button>
                      )}
                    </div>
                    <div className="max-h-80 overflow-y-auto">
                      {notifications.length === 0 ? (
                        <p className="p-4 text-center text-muted-foreground text-sm">No notifications yet</p>
                      ) : (
                        notifications.map(notification => (
                          <button
                            key={notification.id}
                            onClick={() => handleNotificationClick(notification)}
                            className={`w-full p-3 text-left hover:bg-muted/50 transition-colors border-b border-border/50 last:border-0 ${
                              !notification.is_read ? 'bg-primary/5' : ''
                            }`}
                          >
                            <p className={`text-sm ${!notification.is_read ? 'font-medium' : ''}`}>
                              {notification.message}
                            </p>
                            <p className="text-xs text-muted-foreground mt-1">
                              {new Date(notification.created_at).toLocaleDateString()}
                            </p>
                          </button>
                        ))
                      )}
                    </div>
                  </div>
                )}
              </div>

              <button
                onClick={toggleTheme}
                className="p-2 rounded-full hover:bg-muted transition-colors"
                data-testid="theme-toggle"
                aria-label="Toggle dark mode"
              >
                {isDark ? <Sun className="w-5 h-5 text-accent" /> : <Moon className="w-5 h-5 text-muted-foreground" />}
              </button>

              {/* User Avatar & Settings */}
              <div className="flex items-center gap-2">
                {user?.role && (
                  <span 
                    className="text-xs font-medium px-2 py-0.5 rounded-full bg-primary/10 text-primary capitalize"
                    data-testid="nav-role-badge"
                    title={user.role === "keeper" ? "Family keeper" : "Family member"}
                  >
                    {user.role}
                  </span>
                )}
                <Link to="/settings" className="flex items-center gap-2 hover:opacity-80 transition-opacity" data-testid="nav-settings">
                  {user.avatar ? (
                    <img src={user.avatar} alt={getDisplayName()} className="w-8 h-8 rounded-full object-cover border-2 border-border" />
                  ) : (
                    <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center">
                      <span className="text-sm font-semibold text-primary">{getDisplayName().charAt(0).toUpperCase()}</span>
                    </div>
                  )}
                  <span className="text-sm font-medium text-foreground">{getDisplayName()}</span>
                </Link>
              </div>

              <Button 
                variant="ghost" 
                size="sm" 
                onClick={handleLogout}
                className="text-muted-foreground hover:text-foreground"
                data-testid="logout-btn"
              >
                <LogOut className="w-4 h-4" />
              </Button>
            </div>

            {/* Mobile menu button */}
            <button 
              className="md:hidden p-2 rounded-lg hover:bg-muted"
              onClick={() => setMobileMenuOpen(true)}
              data-testid="mobile-menu-btn"
            >
              <Menu className="w-6 h-6" />
            </button>
          </div>
        </div>
      </nav>

      {/* Mobile Menu Overlay */}
      <div 
        className={`mobile-menu-overlay ${mobileMenuOpen ? 'open' : ''}`}
        onClick={() => setMobileMenuOpen(false)}
      />

      {/* Mobile Menu */}
      <div className={`mobile-menu ${mobileMenuOpen ? 'open' : ''} bg-card`} data-testid="mobile-menu">
        <div className="p-4 border-b border-border">
          <div className="flex items-center justify-between">
            <span className="font-serif text-lg font-semibold">Menu</span>
            <button onClick={() => setMobileMenuOpen(false)} className="p-2 hover:bg-muted rounded-lg">
              <X className="w-5 h-5" />
            </button>
          </div>
        </div>
        <div className="p-4 space-y-2">
          <Link 
            to="/" 
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
          >
            <Home className="w-5 h-5 text-primary" />
            <span className="font-medium">Home</span>
          </Link>
          <Link 
            to="/add-recipe" 
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
          >
            <Plus className="w-5 h-5 text-primary" />
            <span className="font-medium">Add Recipe</span>
          </Link>
          <Link 
            to="/profile" 
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
          >
            <User className="w-5 h-5 text-primary" />
            <span className="font-medium">My Recipes</span>
          </Link>
          <Link 
            to="/cookbook" 
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
          >
            <BookOpen className="w-5 h-5 text-primary" />
            <span className="font-medium">Family Cookbook</span>
          </Link>
          <Link 
            to="/family" 
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
            data-testid="mobile-nav-family"
          >
            <Users className="w-5 h-5 text-primary" />
            <span className="font-medium">Family</span>
          </Link>
          <div className="flex items-center gap-2 p-3">
            <CreditsBadge />
          </div>
          <Link
            to="/subscribe"
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-primary/10"
            data-testid="mobile-nav-upgrade"
          >
            <Crown className="w-5 h-5 text-primary" />
            <span className="font-medium text-primary">Upgrade Plan</span>
          </Link>
          <Link
            to="/settings"
            onClick={() => setMobileMenuOpen(false)}
            className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
          >
            <Settings className="w-5 h-5 text-primary" />
            <span className="font-medium">Profile Settings</span>
          </Link>
          <div className="pt-4 border-t border-border mt-4">
            <div className="flex items-center gap-3 px-3 py-2">
              {user.avatar ? (
                <img src={user.avatar} alt={getDisplayName()} className="w-10 h-10 rounded-full object-cover border-2 border-border" />
              ) : (
                <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
                  <span className="text-lg font-semibold text-primary">{getDisplayName().charAt(0).toUpperCase()}</span>
                </div>
              )}
              <div>
                <div className="flex items-center gap-2 flex-wrap">
                  <span className="font-medium">{getDisplayName()}</span>
                  {user?.role && (
                    <span className="text-xs font-medium px-2 py-0.5 rounded-full bg-primary/10 text-primary capitalize">
                      {user.role}
                    </span>
                  )}
                </div>
                <div className="text-xs text-muted-foreground">{user.email}</div>
              </div>
            </div>
            {unreadCount > 0 && (
              <Link 
                to="/" 
                onClick={() => { toggleNotifications(); setMobileMenuOpen(false); }}
                className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted"
              >
                <Bell className="w-5 h-5 text-primary" />
                <span className="font-medium">Notifications</span>
                <span className="ml-auto bg-primary text-primary-foreground text-xs rounded-full px-2 py-0.5">{unreadCount}</span>
              </Link>
            )}
            <button 
              onClick={toggleTheme}
              className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted w-full text-left"
            >
              {isDark ? <Sun className="w-5 h-5 text-accent" /> : <Moon className="w-5 h-5 text-muted-foreground" />}
              <span className="font-medium">{isDark ? "Light Mode" : "Dark Mode"}</span>
            </button>
            <button 
              onClick={() => { handleLogout(); setMobileMenuOpen(false); }}
              className="flex items-center gap-3 p-3 rounded-lg hover:bg-muted w-full text-left text-destructive"
            >
              <LogOut className="w-5 h-5" />
              <span className="font-medium">Logout</span>
            </button>
          </div>
        </div>
      </div>
    </>
  );
};

// Login Page
const GOOGLE_CLIENT_ID = process.env.REACT_APP_GOOGLE_CLIENT_ID;

const LoginPage = () => {
  const [isLogin, setIsLogin] = useState(true);
  const [formData, setFormData] = useState({ name: "", email: "", password: "" });
  const [loading, setLoading] = useState(false);
  const { login, user } = useAuth();
  const { hasAny, loading: subLoading } = useSubscription();
  const navigate = useNavigate();
  const googleButtonRef = React.useRef(null);

  useEffect(() => {
    if (user && !subLoading) {
      navigate(hasAny ? "/home" : "/subscribe");
    }
  }, [user, subLoading, hasAny, navigate]);

  // Initialize Google Sign-In
  useEffect(() => {
    if (!GOOGLE_CLIENT_ID || user) return;

    const initGoogle = () => {
      if (!window.google?.accounts?.id) return;
      window.google.accounts.id.initialize({
        client_id: GOOGLE_CLIENT_ID,
        callback: handleGoogleResponse,
      });
      if (googleButtonRef.current) {
        window.google.accounts.id.renderButton(googleButtonRef.current, {
          type: "standard",
          theme: "outline",
          size: "large",
          text: "continue_with",
          shape: "pill",
          width: 320,
        });
      }
    };

    // Load the GSI script if not already loaded
    if (!document.getElementById("google-gsi-script")) {
      const script = document.createElement("script");
      script.id = "google-gsi-script";
      script.src = "https://accounts.google.com/gsi/client";
      script.async = true;
      script.defer = true;
      script.onload = initGoogle;
      document.head.appendChild(script);
    } else {
      initGoogle();
    }
  }, [user]);

  // Initialize Apple Sign-In (web)
  useEffect(() => {
    if (user) return;
    const APPLE_SERVICE_ID = "com.htrecipes.familyRecipeApp.signin";
    const initApple = () => {
      if (!window.AppleID?.auth) return;
      try {
        window.AppleID.auth.init({
          clientId: APPLE_SERVICE_ID,
          scope: "name email",
          redirectURI: window.location.origin + "/",
          usePopup: true,
        });
      } catch (e) {
        console.warn("Apple SDK init warning:", e);
      }
    };
    if (!document.getElementById("apple-auth-script")) {
      const script = document.createElement("script");
      script.id = "apple-auth-script";
      script.src = "https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js";
      script.async = true;
      script.defer = true;
      script.onload = initApple;
      document.head.appendChild(script);
    } else {
      initApple();
    }
  }, [user]);

  const handleAppleSignIn = async () => {
    if (!window.AppleID?.auth) {
      toast.error("Apple Sign In is loading. Please try again in a moment.");
      return;
    }
    setLoading(true);
    try {
      const result = await window.AppleID.auth.signIn();
      const idToken = result.authorization?.id_token;
      const email = result.user?.email || "";
      const fullName = [result.user?.name?.firstName, result.user?.name?.lastName].filter(Boolean).join(" ");
      if (!idToken) {
        toast.error("Apple did not return a valid token.");
        setLoading(false);
        return;
      }
      const res = await axios.post(`${API}/auth/apple`, {
        id_token: idToken,
        email,
        full_name: fullName,
      });
      login(res.data.token, res.data.user);
      toast.success("Welcome!");
      // Navigation handled by useEffect based on subscription status
    } catch (error) {
      if (error?.error === "popup_closed_by_user" || error?.code === 1001) {
        // user cancelled — no toast
      } else {
        toast.error(error.response?.data?.detail || "Apple sign-in failed");
      }
    }
    setLoading(false);
  };

  const handleGoogleResponse = async (response) => {
    setLoading(true);
    try {
      const res = await axios.post(`${API}/auth/google`, {
        credential: response.credential,
      });
      login(res.data.token, res.data.user);
      toast.success("Welcome!");
      // Navigation handled by useEffect based on subscription status
    } catch (error) {
      toast.error(error.response?.data?.detail || "Google sign-in failed");
    }
    setLoading(false);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    try {
      const endpoint = isLogin ? "/auth/login" : "/auth/register";
      const payload = isLogin ? { email: formData.email, password: formData.password } : formData;
      const response = await axios.post(`${API}${endpoint}`, payload);
      login(response.data.token, response.data.user);
      toast.success(isLogin ? "Welcome back!" : "Account created successfully!");
      // Navigation handled by useEffect based on subscription status
    } catch (error) {
      toast.error(error.response?.data?.detail || "An error occurred");
    }
    setLoading(false);
  };

  return (
    <div className="auth-container" data-testid="auth-page">
      <div className="auth-card animate-fade-in">
        <div className="text-center mb-8 flex flex-col items-center">
          <FamilyLogo size="lg" showText={false} />
          <h1 className="font-serif text-3xl font-bold text-foreground mb-2 mt-4">Legacy Table</h1>
          <p className="text-muted-foreground">Share your culinary heritage</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-5">
          {!isLogin && (
            <div className="space-y-2">
              <Label htmlFor="name" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Name</Label>
              <Input
                id="name"
                type="text"
                placeholder="Your name"
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 px-4 py-3 text-lg focus:border-primary"
                required={!isLogin}
                data-testid="input-name"
              />
            </div>
          )}
          <div className="space-y-2">
            <Label htmlFor="email" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Email</Label>
            <Input
              id="email"
              type="email"
              placeholder="your@email.com"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 px-4 py-3 text-lg focus:border-primary"
              required
              data-testid="input-email"
            />
          </div>
          <div className="space-y-2">
            <Label htmlFor="password" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Password</Label>
            <Input
              id="password"
              type="password"
              placeholder="••••••••"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 px-4 py-3 text-lg focus:border-primary"
              required
              data-testid="input-password"
            />
          </div>
          <Button 
            type="submit" 
            disabled={loading}
            className="w-full rounded-full bg-primary text-primary-foreground hover:bg-primary/90 px-8 py-6 text-lg font-serif transition-transform hover:scale-105 active:scale-95 shadow-lg shadow-primary/20"
            data-testid="auth-submit-btn"
          >
            {loading ? "Please wait..." : isLogin ? "Sign In" : "Create Account"}
          </Button>
        </form>

        <p className="text-center mt-6 text-muted-foreground">
          {isLogin ? "New to the family?" : "Already have an account?"}{" "}
          <button
            type="button"
            onClick={() => setIsLogin(!isLogin)}
            className="text-primary font-semibold hover:underline"
            data-testid="toggle-auth-mode"
          >
            {isLogin ? "Create account" : "Sign in"}
          </button>
        </p>

        <>
          <div className="relative my-6">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-border/50"></div>
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="bg-card px-4 text-muted-foreground">or</span>
            </div>
          </div>
          {GOOGLE_CLIENT_ID && (
            <div className="flex justify-center mb-3" ref={googleButtonRef}></div>
          )}
          <button
            type="button"
            onClick={handleAppleSignIn}
            disabled={loading}
            data-testid="apple-signin-btn"
            className="w-full flex items-center justify-center gap-2 bg-white dark:bg-card border-2 border-border/80 text-foreground rounded-full py-3 px-6 font-medium hover:border-primary/50 hover:shadow-sm transition-all disabled:opacity-50"
            style={{ maxWidth: 320, margin: "0 auto", height: 44 }}
          >
            <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
              <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.08zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
            </svg>
            Continue with Apple
          </button>
        </>
      </div>
    </div>
  );
};

// Recipe Card Component
const RecipeCard = ({ recipe, onClick }) => {
  const getDifficultyClass = (difficulty) => {
    switch (difficulty?.toLowerCase()) {
      case 'easy': return 'difficulty-easy';
      case 'medium': return 'difficulty-medium';
      case 'hard': return 'difficulty-hard';
      default: return 'difficulty-easy';
    }
  };

  return (
    <Card 
      className="recipe-card cursor-pointer group relative overflow-hidden rounded-2xl bg-card border border-border/50 shadow-sm hover:shadow-md transition-all duration-300"
      onClick={onClick}
      data-testid={`recipe-card-${recipe.id}`}
    >
      <div className="aspect-[4/5] w-full overflow-hidden bg-muted">
        {recipe.photos && recipe.photos.length > 0 ? (
          <img 
            src={recipe.photos[0]} 
            alt={recipe.title}
            className="recipe-image h-full w-full object-cover"
          />
        ) : (
          <div className="h-full w-full flex items-center justify-center bg-muted">
            <Utensils className="w-12 h-12 text-muted-foreground/50" />
          </div>
        )}
      </div>
      <CardContent className="p-5 flex flex-col gap-3">
        <div className="flex items-start justify-between gap-2">
          <h3 className="font-serif text-xl font-semibold text-foreground line-clamp-2">{recipe.title}</h3>
          <span className={`difficulty-badge shrink-0 ${getDifficultyClass(recipe.difficulty)}`}>
            {recipe.difficulty}
          </span>
        </div>
        <div className="flex items-center gap-4 text-sm text-muted-foreground">
          <span className="flex items-center gap-1">
            <Clock className="w-4 h-4" />
            {recipe.cooking_time} min
          </span>
          <span className="flex items-center gap-1">
            <Users className="w-4 h-4" />
            {recipe.servings} servings
          </span>
        </div>
        <div className="flex items-center gap-2 mt-1">
          <Badge variant="secondary" className="rounded-full bg-secondary/10 text-secondary hover:bg-secondary/20">
            {recipe.category}
          </Badge>
        </div>
        <p className="text-sm text-muted-foreground mt-1">by {recipe.author_name}</p>
      </CardContent>
    </Card>
  );
};

// ===================== CELEBRATION HEADQUARTERS =====================

const HolidayHeadquarters = () => {
  const [holidays, setHolidays] = useState(null);
  const [expanded, setExpanded] = useState(false);
  const [selectedHoliday, setSelectedHoliday] = useState(null);
  const [holidayRecipes, setHolidayRecipes] = useState([]);
  const [loadingRecipes, setLoadingRecipes] = useState(false);
  const { token } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    const fetchHolidays = async () => {
      try {
        const res = await axios.get(`${API}/holidays`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setHolidays(res.data);
      } catch (e) {
        console.error("Failed to load holidays");
      }
    };
    fetchHolidays();
  }, [token]);

  const loadHolidayRecipes = async (holidayName) => {
    if (selectedHoliday === holidayName) {
      setSelectedHoliday(null);
      setHolidayRecipes([]);
      return;
    }
    setSelectedHoliday(holidayName);
    setLoadingRecipes(true);
    try {
      const res = await axios.get(`${API}/holidays/${encodeURIComponent(holidayName)}/recipes`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setHolidayRecipes(res.data.recipes);
    } catch (e) {
      toast.error("Failed to load holiday recipes");
    }
    setLoadingRecipes(false);
  };

  if (!holidays) return null;

  const { upcoming, season, season_theme, holiday_recipe_counts } = holidays;
  const nextHoliday = upcoming[0];
  const visibleHolidays = expanded ? upcoming : upcoming.slice(0, 3);

  return (
    <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
      {/* Season Banner */}
      <div
        className="rounded-2xl p-6 mb-6 relative overflow-hidden"
        style={{ background: `linear-gradient(135deg, ${season_theme.gradient[0]}, ${season_theme.gradient[1]})` }}
      >
        <div className="relative z-10 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <Calendar className="w-5 h-5" style={{ color: season_theme.color }} />
              <h2 className="font-serif text-xl font-bold" style={{ color: season_theme.color }}>
                Celebration Headquarters
              </h2>
            </div>
            <p className="text-sm text-foreground/70">
              {season_theme.label} — {nextHoliday && (
                <>Next up: <span className="font-semibold">{nextHoliday.emoji} {nextHoliday.name}</span> in {nextHoliday.days_away} day{nextHoliday.days_away !== 1 ? 's' : ''}</>
              )}
            </p>
          </div>
          <div className="flex items-center gap-2">
            <Badge variant="outline" className="text-xs px-3 py-1 rounded-full capitalize" style={{ borderColor: season_theme.color, color: season_theme.color }}>
              {season}
            </Badge>
          </div>
        </div>
      </div>

      {/* Upcoming Holidays */}
      <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        {visibleHolidays.map((h) => {
          const recipeCount = holiday_recipe_counts[h.name] || 0;
          const isSelected = selectedHoliday === h.name;
          return (
            <Card
              key={h.name}
              className={`cursor-pointer transition-all hover:shadow-md ${isSelected ? 'ring-2 ring-primary' : ''}`}
              onClick={() => loadHolidayRecipes(h.name)}
            >
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-2xl">{h.emoji}</span>
                    <div>
                      <h3 className="font-serif font-semibold text-sm">{h.name}</h3>
                      <p className="text-xs text-muted-foreground">{h.days_away} day{h.days_away !== 1 ? 's' : ''} away</p>
                    </div>
                  </div>
                  {recipeCount > 0 && (
                    <Badge className="text-xs rounded-full bg-primary/10 text-primary border-0">
                      {recipeCount} recipe{recipeCount !== 1 ? 's' : ''}
                    </Badge>
                  )}
                </div>
                <p className="text-xs text-muted-foreground mt-2">{h.description}</p>
                {h.suggested_categories && (
                  <div className="flex gap-1 mt-2 flex-wrap">
                    {h.suggested_categories.slice(0, 3).map(cat => (
                      <span key={cat} className="text-[10px] px-2 py-0.5 rounded-full bg-muted text-muted-foreground">{cat}</span>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          );
        })}
      </div>

      {upcoming.length > 3 && (
        <button
          onClick={() => setExpanded(!expanded)}
          className="text-sm text-primary hover:underline mt-3 block mx-auto"
        >
          {expanded ? 'Show less' : `Show ${upcoming.length - 3} more holidays`}
        </button>
      )}

      {/* Holiday Recipes Drawer */}
      {selectedHoliday && (
        <div className="mt-6 p-4 rounded-2xl border bg-card">
          <div className="flex items-center justify-between mb-4">
            <h3 className="font-serif font-semibold">
              {upcoming.find(h => h.name === selectedHoliday)?.emoji} {selectedHoliday} Recipes
            </h3>
            <button onClick={() => { setSelectedHoliday(null); setHolidayRecipes([]); }} className="text-muted-foreground hover:text-foreground">
              <X className="w-4 h-4" />
            </button>
          </div>
          {loadingRecipes ? (
            <div className="flex gap-4">
              {[1, 2, 3].map(i => <div key={i} className="skeleton h-24 w-full rounded-xl" />)}
            </div>
          ) : holidayRecipes.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
              {holidayRecipes.map(recipe => (
                <Card
                  key={recipe.id}
                  className="cursor-pointer hover:shadow-md transition-all"
                  onClick={() => navigate(`/recipe/${recipe.id}`)}
                >
                  <CardContent className="p-3 flex items-center gap-3">
                    {recipe.photos?.[0] ? (
                      <img src={recipe.photos[0]} alt="" className="w-14 h-14 rounded-lg object-cover flex-shrink-0" />
                    ) : (
                      <div className="w-14 h-14 rounded-lg bg-primary/10 flex items-center justify-center flex-shrink-0">
                        <Utensils className="w-6 h-6 text-primary/50" />
                      </div>
                    )}
                    <div className="min-w-0">
                      <p className="font-serif font-semibold text-sm truncate">{recipe.title}</p>
                      <p className="text-xs text-muted-foreground">by {recipe.author_name}</p>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          ) : (
            <div className="text-center py-8">
              <Gift className="w-8 h-8 text-muted-foreground/50 mx-auto mb-2" />
              <p className="text-sm text-muted-foreground mb-3">No recipes tagged for {selectedHoliday} yet</p>
              <p className="text-xs text-muted-foreground">Tag recipes from their detail page to build your holiday collection!</p>
            </div>
          )}
        </div>
      )}
    </section>
  );
};

// Home Page
const HomePage = () => {
  const [recipes, setRecipes] = useState([]);
  const [categories, setCategories] = useState([]);
  const [selectedCategory, setSelectedCategory] = useState("");
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");
  const navigate = useNavigate();
  const { token, user } = useAuth();

  useEffect(() => {
    fetchRecipes();
    fetchCategories();
  }, [selectedCategory]);

  const fetchRecipes = async () => {
    try {
      const params = selectedCategory ? `?category=${encodeURIComponent(selectedCategory)}` : "";
      const response = await axios.get(`${API}/recipes${params}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setRecipes(response.data);
    } catch (error) {
      toast.error("Failed to load recipes");
    }
    setLoading(false);
  };

  const fetchCategories = async () => {
    try {
      const response = await axios.get(`${API}/categories`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setCategories(response.data);
    } catch (error) {
      console.error("Failed to load categories");
    }
  };

  const filteredRecipes = recipes.filter(r => 
    r.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
    r.author_name.toLowerCase().includes(searchTerm.toLowerCase())
  );

  return (
    <div className="min-h-screen bg-background" data-testid="home-page">
      <Navigation />
      
      {/* Hero Section */}
      <section className="relative bg-gradient-to-b from-primary/5 to-background py-12 md:py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto animate-slide-up">
            <div className="flex justify-center mb-6">
              <FamilyLogo size="xl" showText={false} />
            </div>
            <h1 className="font-serif text-4xl sm:text-5xl lg:text-6xl font-bold text-foreground mb-4">
              Legacy Table<br />Family Recipes
            </h1>
            <p className="text-lg text-muted-foreground mb-8">
              Preserve and share our family's culinary traditions with love
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button 
                onClick={() => navigate("/add-recipe")}
                className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90 px-8 py-6 text-lg font-serif transition-transform hover:scale-105 active:scale-95 shadow-lg shadow-primary/20"
                data-testid="hero-add-recipe-btn"
              >
                <Plus className="w-5 h-5 mr-2" />
                Share a Recipe
              </Button>
              <Button 
                onClick={() => navigate("/cookbook")}
                variant="outline"
                className="rounded-full border-2 border-primary text-primary hover:bg-primary/5 px-8 py-6 text-lg font-serif"
                data-testid="hero-cookbook-btn"
              >
                <BookOpen className="w-5 h-5 mr-2" />
                Family Cookbook
              </Button>
            </div>
            {/* AI Quick Actions */}
            <div className="flex flex-wrap gap-3 justify-center mt-6">
              <button
                onClick={() => navigate("/scan-recipe")}
                className="flex items-center gap-2 px-4 py-2 rounded-full bg-background/80 backdrop-blur border border-border/50 text-sm text-foreground hover:border-primary/50 hover:bg-primary/5 transition-all"
              >
                <Camera className="w-4 h-4 text-primary" />
                Scan a Recipe
              </button>
              <button
                onClick={() => navigate("/voice-recipe")}
                className="flex items-center gap-2 px-4 py-2 rounded-full bg-background/80 backdrop-blur border border-border/50 text-sm text-foreground hover:border-amber-500/50 hover:bg-amber-500/5 transition-all"
              >
                <Volume2 className="w-4 h-4 text-amber-600" />
                Voice a Recipe
              </button>
              <button
                onClick={() => navigate("/save-from-link")}
                className="flex items-center gap-2 px-4 py-2 rounded-full bg-background/80 backdrop-blur border border-border/50 text-sm text-foreground hover:border-pink-500/50 hover:bg-pink-500/5 transition-all"
              >
                <Link2 className="w-4 h-4 text-pink-600" />
                Save from Link
              </button>
            </div>
          </div>
        </div>
      </section>

      {/* Celebration Headquarters */}
      <HolidayHeadquarters />

      {/* Filters */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
          <div className="relative w-full md:w-72">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-muted-foreground" />
            <Input
              placeholder="Search recipes..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10 rounded-full border-2 border-border/50"
              data-testid="search-input"
            />
          </div>
          <div className="flex gap-2 flex-wrap">
            <button
              onClick={() => setSelectedCategory("")}
              className={`category-tag ${!selectedCategory ? 'active' : ''}`}
              data-testid="category-all"
            >
              All
            </button>
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`category-tag ${selectedCategory === cat ? 'active' : ''}`}
                data-testid={`category-${cat.toLowerCase().replace(' ', '-')}`}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>

        {/* Recipe scope copy (family vs legacy) */}
        {!loading && (
          <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2 mt-2">
            <p className="text-sm text-muted-foreground">
              {user?.family_id ? "Showing family recipes." : "Showing legacy recipes."}
            </p>
            {!user?.family_id && (
              <Button
                variant="outline"
                size="sm"
                className="rounded-full text-primary border-primary"
                onClick={() => navigate("/family")}
                data-testid="create-join-family-cta"
              >
                Create a family or join with invite code
              </Button>
            )}
          </div>
        )}
      </section>

      {/* Recipe Grid */}
      <section className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 pb-16">
        {loading ? (
          <div className="recipe-grid">
            {[...Array(6)].map((_, i) => (
              <div key={i} className="rounded-2xl overflow-hidden">
                <div className="skeleton aspect-[4/5]" />
                <div className="p-5 space-y-3">
                  <div className="skeleton h-6 w-3/4" />
                  <div className="skeleton h-4 w-1/2" />
                </div>
              </div>
            ))}
          </div>
        ) : filteredRecipes.length > 0 ? (
          <div className="recipe-grid" data-testid="recipe-grid">
            {filteredRecipes.map((recipe, index) => (
              <div key={recipe.id} className="animate-fade-in" style={{ animationDelay: `${index * 0.1}s` }}>
                <RecipeCard 
                  recipe={recipe} 
                  onClick={() => navigate(`/recipe/${recipe.id}`)}
                />
              </div>
            ))}
          </div>
        ) : (
          <div className="empty-state" data-testid="empty-state">
            <div className="empty-state-icon">
              <Utensils className="w-10 h-10" />
            </div>
            <h3 className="font-serif text-2xl font-semibold mb-2">No recipes yet</h3>
            <p className="text-muted-foreground mb-6">Be the first to share a family recipe!</p>
            <Button 
              onClick={() => navigate("/add-recipe")}
              className="rounded-full bg-primary text-primary-foreground"
              data-testid="empty-add-recipe-btn"
            >
              <Plus className="w-4 h-4 mr-2" />
              Add Recipe
            </Button>
          </div>
        )}
      </section>
    </div>
  );
};

// Add Recipe Page
const AddRecipePage = () => {
  const [formData, setFormData] = useState({
    title: "",
    ingredients: [""],
    instructions: "",
    story: "",
    photos: [],
    cooking_time: 30,
    servings: 4,
    category: "",
    difficulty: "easy"
  });
  const [loading, setLoading] = useState(false);
  const [cameraActive, setCameraActive] = useState(false);
  const videoRef = React.useRef(null);
  const streamRef = React.useRef(null);
  const { token } = useAuth();
  const navigate = useNavigate();

  const categories = ["Main Course", "Appetizer", "Dessert", "Soup", "Salad", "Breakfast", "Snack", "Beverage"];

  const handleAddIngredient = () => {
    setFormData({ ...formData, ingredients: [...formData.ingredients, ""] });
  };

  const handleIngredientChange = (index, value) => {
    const newIngredients = [...formData.ingredients];
    newIngredients[index] = value;
    setFormData({ ...formData, ingredients: newIngredients });
  };

  const handleRemoveIngredient = (index) => {
    const newIngredients = formData.ingredients.filter((_, i) => i !== index);
    setFormData({ ...formData, ingredients: newIngredients });
  };

  const handlePhotoUpload = (e) => {
    const files = Array.from(e.target.files);
    files.forEach(file => {
      const reader = new FileReader();
      reader.onload = (event) => {
        setFormData(prev => ({
          ...prev,
          photos: [...prev.photos, event.target.result]
        }));
      };
      reader.readAsDataURL(file);
    });
  };

  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ 
        video: { facingMode: 'environment' } 
      });
      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
      }
      setCameraActive(true);
    } catch (error) {
      toast.error("Could not access camera");
    }
  };

  const capturePhoto = () => {
    if (videoRef.current) {
      const canvas = document.createElement('canvas');
      canvas.width = videoRef.current.videoWidth;
      canvas.height = videoRef.current.videoHeight;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(videoRef.current, 0, 0);
      const photo = canvas.toDataURL('image/jpeg', 0.8);
      setFormData(prev => ({
        ...prev,
        photos: [...prev.photos, photo]
      }));
      stopCamera();
      toast.success("Photo captured!");
    }
  };

  const stopCamera = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(track => track.stop());
    }
    setCameraActive(false);
  };

  const removePhoto = (index) => {
    setFormData(prev => ({
      ...prev,
      photos: prev.photos.filter((_, i) => i !== index)
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!formData.title || !formData.instructions || !formData.category) {
      toast.error("Please fill in all required fields");
      return;
    }

    const validIngredients = formData.ingredients.filter(i => i.trim());
    if (validIngredients.length === 0) {
      toast.error("Please add at least one ingredient");
      return;
    }

    setLoading(true);
    try {
      const photos = await compressPhotoList(formData.photos || []);
      const payload = {
        title: sanitizeForJson(formData.title),
        ingredients: validIngredients.map((i) => sanitizeForJson(i)),
        instructions: sanitizeForJson(formData.instructions),
        story: sanitizeForJson(formData.story) || null,
        photos,
        cooking_time: formData.cooking_time ?? 30,
        servings: formData.servings ?? 4,
        category: sanitizeForJson(formData.category),
        difficulty: formData.difficulty || "easy",
      };
      await axios.post(`${API}/recipes`, payload, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      });
      toast.success("Recipe shared with the family!");
      navigate("/home");
    } catch (error) {
      const detail = error.response?.data?.detail;
      const msg = Array.isArray(detail)
        ? detail.find((d) => d.msg)?.msg || detail?.[0]?.msg || "Failed to create recipe"
        : detail || "Failed to create recipe";
      toast.error(typeof msg === "string" ? msg : "Failed to create recipe");
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-background" data-testid="add-recipe-page">
      <Navigation />
      
      {/* Camera Overlay */}
      {cameraActive && (
        <div className="photo-capture-overlay" data-testid="camera-overlay">
          <video 
            ref={videoRef} 
            autoPlay 
            playsInline 
            className="photo-capture-video"
          />
          <div className="flex gap-4 mt-6">
            <Button 
              onClick={capturePhoto}
              className="rounded-full bg-white text-foreground px-8 py-6"
              data-testid="capture-btn"
            >
              <Camera className="w-6 h-6 mr-2" />
              Capture
            </Button>
            <Button 
              onClick={stopCamera}
              variant="outline"
              className="rounded-full border-white text-white px-8 py-6"
              data-testid="cancel-camera-btn"
            >
              Cancel
            </Button>
          </div>
        </div>
      )}

      <div className="max-w-3xl mx-auto px-4 sm:px-6 py-8">
        <div className="mb-8 animate-fade-in">
          <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Share a Recipe</h1>
          <p className="text-muted-foreground">Add a new dish to the family collection</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-8 animate-slide-up">
          {/* Photos Section */}
          <div className="space-y-4">
            <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Photos</Label>
            
            <div className="flex gap-3">
              <label className="flex-1">
                <div className="photo-upload-zone flex items-center justify-center gap-3" data-testid="photo-upload-zone">
                  <Camera className="w-6 h-6 text-muted-foreground" />
                  <span className="text-muted-foreground">Upload from gallery</span>
                </div>
                <input 
                  type="file" 
                  accept="image/*" 
                  multiple 
                  className="hidden" 
                  onChange={handlePhotoUpload}
                  data-testid="photo-input"
                />
              </label>
             
            </div>

            {formData.photos.length > 0 && (
              <div className="photo-preview-grid" data-testid="photo-preview-grid">
                {formData.photos.map((photo, index) => (
                  <div key={index} className="photo-preview-item">
                    <img src={photo} alt={`Recipe photo ${index + 1}`} />
                    <button 
                      type="button"
                      onClick={() => removePhoto(index)}
                      className="remove-btn"
                      data-testid={`remove-photo-${index}`}
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Title */}
          <div className="space-y-2">
            <Label htmlFor="title" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Recipe Title *</Label>
            <Input
              id="title"
              placeholder="e.g., Grandma's Special Jollof Rice"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 px-4 py-3 text-lg focus:border-primary"
              required
              data-testid="input-title"
            />
          </div>

          {/* Category & Difficulty */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Category *</Label>
              <Select 
                value={formData.category} 
                onValueChange={(value) => setFormData({ ...formData, category: value })}
              >
                <SelectTrigger className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12" data-testid="select-category">
                  <SelectValue placeholder="Select category" />
                </SelectTrigger>
                <SelectContent>
                  {categories.map(cat => (
                    <SelectItem key={cat} value={cat}>{cat}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Difficulty</Label>
              <Select 
                value={formData.difficulty} 
                onValueChange={(value) => setFormData({ ...formData, difficulty: value })}
              >
                <SelectTrigger className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12" data-testid="select-difficulty">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="easy">Easy</SelectItem>
                  <SelectItem value="medium">Medium</SelectItem>
                  <SelectItem value="hard">Hard</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Time & Servings */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label htmlFor="time" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Cooking Time (minutes)</Label>
              <Input
                id="time"
                type="number"
                min="1"
                value={formData.cooking_time}
                onChange={(e) => setFormData({ ...formData, cooking_time: parseInt(e.target.value) || 0 })}
                className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12"
                data-testid="input-time"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="servings" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Servings</Label>
              <Input
                id="servings"
                type="number"
                min="1"
                value={formData.servings}
                onChange={(e) => setFormData({ ...formData, servings: parseInt(e.target.value) || 0 })}
                className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12"
                data-testid="input-servings"
              />
            </div>
          </div>

          {/* Ingredients */}
          <div className="space-y-4">
            <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Ingredients *</Label>
            <div className="space-y-3">
              {formData.ingredients.map((ingredient, index) => (
                <div key={index} className="flex gap-2">
                  <Input
                    placeholder={`Ingredient ${index + 1}`}
                    value={ingredient}
                    onChange={(e) => handleIngredientChange(index, e.target.value)}
                    className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30"
                    data-testid={`ingredient-${index}`}
                  />
                  {formData.ingredients.length > 1 && (
                    <Button 
                      type="button" 
                      variant="ghost" 
                      onClick={() => handleRemoveIngredient(index)}
                      className="px-3"
                      data-testid={`remove-ingredient-${index}`}
                    >
                      <X className="w-4 h-4" />
                    </Button>
                  )}
                </div>
              ))}
            </div>
            <Button 
              type="button" 
              variant="outline" 
              onClick={handleAddIngredient}
              className="rounded-full"
              data-testid="add-ingredient-btn"
            >
              <Plus className="w-4 h-4 mr-2" />
              Add Ingredient
            </Button>
          </div>

          {/* Instructions */}
          <div className="space-y-2">
            <Label htmlFor="instructions" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Instructions *</Label>
            <Textarea
              id="instructions"
              placeholder="Write the step-by-step cooking instructions..."
              value={formData.instructions}
              onChange={(e) => setFormData({ ...formData, instructions: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 min-h-[200px] resize-y"
              required
              data-testid="input-instructions"
            />
          </div>

          {/* Story (Optional) */}
          <div className="space-y-2">
            <Label htmlFor="story" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
              The Story Behind This Recipe <span className="text-muted-foreground/60 normal-case">(optional)</span>
            </Label>
            <Textarea
              id="story"
              placeholder="Share the story of this recipe... Where did it come from? Who passed it down? What memories does it hold for your family?"
              value={formData.story}
              onChange={(e) => setFormData({ ...formData, story: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 min-h-[120px] resize-y"
              data-testid="input-story"
            />
            <p className="text-xs text-muted-foreground">Tell us about the history, traditions, or special memories connected to this dish.</p>
          </div>

          {/* Submit */}
          <div className="flex gap-4 pt-4">
            <Button 
              type="button" 
              variant="outline" 
              onClick={() => navigate("/home")}
              className="rounded-full px-8 py-6"
              data-testid="cancel-btn"
            >
              Cancel
            </Button>
            <Button 
              type="submit" 
              disabled={loading}
              className="flex-1 rounded-full bg-primary text-primary-foreground hover:bg-primary/90 px-8 py-6 text-lg font-serif transition-transform hover:scale-105 active:scale-95 shadow-lg shadow-primary/20"
              data-testid="submit-recipe-btn"
            >
              {loading ? "Saving..." : "Share Recipe"}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};

// Edit Recipe Page
const EditRecipePage = () => {
  const { id } = useParams();
  const [formData, setFormData] = useState({
    title: "",
    ingredients: [""],
    instructions: "",
    story: "",
    photos: [],
    cooking_time: 30,
    servings: 4,
    category: "",
    difficulty: "easy"
  });
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [accessDenied, setAccessDenied] = useState(false);
  const { token, user } = useAuth();
  const navigate = useNavigate();

  const categories = ["Main Course", "Appetizer", "Dessert", "Soup", "Salad", "Breakfast", "Snack", "Beverage"];

  useEffect(() => {
    fetchRecipe();
  }, [id]);

  const fetchRecipe = async () => {
    try {
      const response = await axios.get(`${API}/recipes/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      const recipe = response.data;
      setAccessDenied(false);

      // Check if user is the author (or keeper can edit family recipes)
      if (recipe.author_id !== user?.id && user?.role !== "keeper") {
        toast.error("You can only edit your own recipes");
        navigate(`/recipe/${id}`);
        return;
      }

      setFormData({
        title: recipe.title,
        ingredients: recipe.ingredients.length > 0 ? recipe.ingredients : [""],
        instructions: recipe.instructions,
        story: recipe.story || "",
        photos: recipe.photos || [],
        cooking_time: recipe.cooking_time,
        servings: recipe.servings,
        category: recipe.category,
        difficulty: recipe.difficulty
      });
    } catch (error) {
      if (error.response?.status === 403) {
        setAccessDenied(true);
      } else {
        toast.error("Recipe not found");
        navigate("/home");
      }
    }
    setLoading(false);
  };

  const handleAddIngredient = () => {
    setFormData({ ...formData, ingredients: [...formData.ingredients, ""] });
  };

  const handleIngredientChange = (index, value) => {
    const newIngredients = [...formData.ingredients];
    newIngredients[index] = value;
    setFormData({ ...formData, ingredients: newIngredients });
  };

  const handleRemoveIngredient = (index) => {
    const newIngredients = formData.ingredients.filter((_, i) => i !== index);
    setFormData({ ...formData, ingredients: newIngredients });
  };

  const handlePhotoUpload = (e) => {
    const files = Array.from(e.target.files);
    files.forEach(file => {
      const reader = new FileReader();
      reader.onload = (event) => {
        setFormData(prev => ({
          ...prev,
          photos: [...prev.photos, event.target.result]
        }));
      };
      reader.readAsDataURL(file);
    });
  };

  const removePhoto = (index) => {
    setFormData(prev => ({
      ...prev,
      photos: prev.photos.filter((_, i) => i !== index)
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    if (!formData.title || !formData.instructions || !formData.category) {
      toast.error("Please fill in all required fields");
      return;
    }

    const validIngredients = formData.ingredients.filter(i => i.trim());
    if (validIngredients.length === 0) {
      toast.error("Please add at least one ingredient");
      return;
    }

    setSaving(true);
    try {
      const photos = await compressPhotoList(formData.photos || []);
      const payload = {
        title: sanitizeForJson(formData.title),
        ingredients: validIngredients.map((i) => sanitizeForJson(i)),
        instructions: sanitizeForJson(formData.instructions),
        story: sanitizeForJson(formData.story) || null,
        photos,
        cooking_time: formData.cooking_time ?? 30,
        servings: formData.servings ?? 4,
        category: sanitizeForJson(formData.category),
        difficulty: formData.difficulty || "easy",
      };
      await axios.put(`${API}/recipes/${id}`, payload, {
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
      });
      toast.success("Recipe updated successfully!");
      navigate(`/recipe/${id}`);
    } catch (error) {
      const detail = error.response?.data?.detail;
      const msg = Array.isArray(detail)
        ? detail.find((d) => d.msg)?.msg || detail?.[0]?.msg || "Failed to update recipe"
        : detail || "Failed to update recipe";
      toast.error(typeof msg === "string" ? msg : "Failed to update recipe");
    }
    setSaving(false);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <Navigation />
        <div className="max-w-3xl mx-auto px-4 py-12">
          <div className="skeleton h-10 w-1/2 mb-4" />
          <div className="skeleton h-6 w-1/3 mb-8" />
          <div className="space-y-6">
            <div className="skeleton h-40 rounded-xl" />
            <div className="skeleton h-12 rounded-xl" />
            <div className="skeleton h-32 rounded-xl" />
          </div>
        </div>
      </div>
    );
  }

  if (accessDenied) {
    return (
      <div className="min-h-screen bg-background" data-testid="edit-recipe-page">
        <Navigation />
        <div className="max-w-3xl mx-auto px-4 sm:px-6 py-12">
          <div className="text-center py-12 px-4 rounded-2xl bg-muted/50 border border-border">
            <h2 className="font-serif text-2xl font-semibold text-foreground mb-2">You don't have access to this recipe</h2>
            <p className="text-muted-foreground mb-6">Join the family to edit it, or it may be private to another family.</p>
            <div className="flex flex-wrap gap-3 justify-center">
              <Button onClick={() => navigate("/home")} className="rounded-full">Go home</Button>
              {!user?.family_id && (
                <Button variant="outline" onClick={() => navigate("/family")} className="rounded-full border-primary text-primary">Join a family</Button>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background" data-testid="edit-recipe-page">
      <Navigation />

      <div className="max-w-3xl mx-auto px-4 sm:px-6 py-8">
        <div className="mb-8 animate-fade-in">
          <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Edit Recipe</h1>
          <p className="text-muted-foreground">Update your family recipe</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-8 animate-slide-up">
          {/* Photos Section */}
          <div className="space-y-4">
            <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Photos</Label>
            
            <label className="block">
              <div className="photo-upload-zone flex items-center justify-center gap-3" data-testid="edit-photo-upload-zone">
                <Camera className="w-6 h-6 text-muted-foreground" />
                <span className="text-muted-foreground">Add more photos</span>
              </div>
              <input 
                type="file" 
                accept="image/*" 
                multiple 
                className="hidden" 
                onChange={handlePhotoUpload}
                data-testid="edit-photo-input"
              />
            </label>

            {formData.photos.length > 0 && (
              <div className="photo-preview-grid" data-testid="edit-photo-preview-grid">
                {formData.photos.map((photo, index) => (
                  <div key={index} className="photo-preview-item">
                    <img src={photo} alt={`Recipe photo ${index + 1}`} />
                    <button 
                      type="button"
                      onClick={() => removePhoto(index)}
                      className="remove-btn"
                      data-testid={`edit-remove-photo-${index}`}
                    >
                      <X className="w-4 h-4" />
                    </button>
                  </div>
                ))}
              </div>
            )}
          </div>

          {/* Title */}
          <div className="space-y-2">
            <Label htmlFor="title" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Recipe Title *</Label>
            <Input
              id="title"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 px-4 py-3 text-lg focus:border-primary"
              required
              data-testid="edit-input-title"
            />
          </div>

          {/* Category & Difficulty */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Category *</Label>
              <Select 
                value={formData.category} 
                onValueChange={(value) => setFormData({ ...formData, category: value })}
              >
                <SelectTrigger className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12" data-testid="edit-select-category">
                  <SelectValue placeholder="Select category" />
                </SelectTrigger>
                <SelectContent>
                  {categories.map(cat => (
                    <SelectItem key={cat} value={cat}>{cat}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Difficulty</Label>
              <Select 
                value={formData.difficulty} 
                onValueChange={(value) => setFormData({ ...formData, difficulty: value })}
              >
                <SelectTrigger className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12" data-testid="edit-select-difficulty">
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="easy">Easy</SelectItem>
                  <SelectItem value="medium">Medium</SelectItem>
                  <SelectItem value="hard">Hard</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          {/* Time & Servings */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div className="space-y-2">
              <Label htmlFor="time" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Cooking Time (minutes)</Label>
              <Input
                id="time"
                type="number"
                min="1"
                value={formData.cooking_time}
                onChange={(e) => setFormData({ ...formData, cooking_time: parseInt(e.target.value) || 0 })}
                className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12"
                data-testid="edit-input-time"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="servings" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Servings</Label>
              <Input
                id="servings"
                type="number"
                min="1"
                value={formData.servings}
                onChange={(e) => setFormData({ ...formData, servings: parseInt(e.target.value) || 0 })}
                className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 h-12"
                data-testid="edit-input-servings"
              />
            </div>
          </div>

          {/* Ingredients */}
          <div className="space-y-4">
            <Label className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Ingredients *</Label>
            <div className="space-y-3">
              {formData.ingredients.map((ingredient, index) => (
                <div key={index} className="flex gap-2">
                  <Input
                    placeholder={`Ingredient ${index + 1}`}
                    value={ingredient}
                    onChange={(e) => handleIngredientChange(index, e.target.value)}
                    className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30"
                    data-testid={`edit-ingredient-${index}`}
                  />
                  {formData.ingredients.length > 1 && (
                    <Button 
                      type="button" 
                      variant="ghost" 
                      onClick={() => handleRemoveIngredient(index)}
                      className="px-3"
                      data-testid={`edit-remove-ingredient-${index}`}
                    >
                      <X className="w-4 h-4" />
                    </Button>
                  )}
                </div>
              ))}
            </div>
            <Button 
              type="button" 
              variant="outline" 
              onClick={handleAddIngredient}
              className="rounded-full"
              data-testid="edit-add-ingredient-btn"
            >
              <Plus className="w-4 h-4 mr-2" />
              Add Ingredient
            </Button>
          </div>

          {/* Instructions */}
          <div className="space-y-2">
            <Label htmlFor="instructions" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">Instructions *</Label>
            <Textarea
              id="instructions"
              value={formData.instructions}
              onChange={(e) => setFormData({ ...formData, instructions: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 min-h-[200px] resize-y"
              required
              data-testid="edit-input-instructions"
            />
          </div>

          {/* Story (Optional) */}
          <div className="space-y-2">
            <Label htmlFor="story" className="text-sm font-semibold uppercase tracking-wider text-muted-foreground">
              The Story Behind This Recipe <span className="text-muted-foreground/60 normal-case">(optional)</span>
            </Label>
            <Textarea
              id="story"
              placeholder="Share the story of this recipe..."
              value={formData.story}
              onChange={(e) => setFormData({ ...formData, story: e.target.value })}
              className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 min-h-[120px] resize-y"
              data-testid="edit-input-story"
            />
          </div>

          {/* Submit */}
          <div className="flex gap-4 pt-4">
            <Button 
              type="button" 
              variant="outline" 
              onClick={() => navigate(`/recipe/${id}`)}
              className="rounded-full px-8 py-6"
              data-testid="edit-cancel-btn"
            >
              Cancel
            </Button>
            <Button 
              type="submit" 
              disabled={saving}
              className="flex-1 rounded-full bg-primary text-primary-foreground hover:bg-primary/90 px-8 py-6 text-lg font-serif transition-transform hover:scale-105 active:scale-95 shadow-lg shadow-primary/20"
              data-testid="edit-submit-btn"
            >
              {saving ? "Saving..." : "Update Recipe"}
            </Button>
          </div>
        </form>
      </div>
    </div>
  );
};

// Share Recipe Card Component
// ===================== SHARE ASSET THEMES =====================

const SHARE_THEMES = [
  {
    id: 'heritage',
    name: 'Heritage',
    gradient: [['#D4A574', 0], ['#D97A6E', 0.5], ['#A89968', 1]],
    textColor: '#FFFFFF',
    accentColor: 'rgba(255,255,255,0.3)',
    decorBorder: 'rgba(255,255,255,0.15)',
  },
  {
    id: 'midnight',
    name: 'Midnight',
    gradient: [['#1a1a2e', 0], ['#16213e', 0.5], ['#0f3460', 1]],
    textColor: '#e8d5b7',
    accentColor: 'rgba(232,213,183,0.25)',
    decorBorder: 'rgba(232,213,183,0.1)',
  },
  {
    id: 'garden',
    name: 'Garden',
    gradient: [['#2d5016', 0], ['#3a5a1c', 0.5], ['#4a7c2e', 1]],
    textColor: '#f5f0e1',
    accentColor: 'rgba(245,240,225,0.25)',
    decorBorder: 'rgba(245,240,225,0.1)',
  },
  {
    id: 'spice',
    name: 'Spice',
    gradient: [['#8B2500', 0], ['#A0522D', 0.5], ['#CD853F', 1]],
    textColor: '#FFF8DC',
    accentColor: 'rgba(255,248,220,0.25)',
    decorBorder: 'rgba(255,248,220,0.12)',
  },
  {
    id: 'ivory',
    name: 'Ivory',
    gradient: [['#FAF0E6', 0], ['#F5DEB3', 0.5], ['#FAEBD7', 1]],
    textColor: '#3E2723',
    accentColor: 'rgba(62,39,35,0.15)',
    decorBorder: 'rgba(62,39,35,0.08)',
  },
];

const SHARE_FORMATS = [
  { id: 'square', name: 'Square', width: 1080, height: 1080, label: '1:1' },
  { id: 'story', name: 'Story', width: 1080, height: 1920, label: '9:16' },
];

// Canvas text wrapping helper
function wrapCanvasText(ctx, text, maxWidth) {
  const words = text.split(' ');
  const lines = [];
  let currentLine = '';
  for (const word of words) {
    const testLine = currentLine ? `${currentLine} ${word}` : word;
    if (ctx.measureText(testLine).width > maxWidth && currentLine) {
      lines.push(currentLine);
      currentLine = word;
    } else {
      currentLine = testLine;
    }
  }
  if (currentLine) lines.push(currentLine);
  return lines;
}

// Draw decorative corner flourishes
function drawCornerFlourishes(ctx, w, h, color) {
  ctx.strokeStyle = color;
  ctx.lineWidth = 2;
  const inset = 40;
  const len = 60;
  // Top-left
  ctx.beginPath();
  ctx.moveTo(inset, inset + len); ctx.lineTo(inset, inset); ctx.lineTo(inset + len, inset);
  ctx.stroke();
  // Top-right
  ctx.beginPath();
  ctx.moveTo(w - inset - len, inset); ctx.lineTo(w - inset, inset); ctx.lineTo(w - inset, inset + len);
  ctx.stroke();
  // Bottom-left
  ctx.beginPath();
  ctx.moveTo(inset, h - inset - len); ctx.lineTo(inset, h - inset); ctx.lineTo(inset + len, h - inset);
  ctx.stroke();
  // Bottom-right
  ctx.beginPath();
  ctx.moveTo(w - inset - len, h - inset); ctx.lineTo(w - inset, h - inset); ctx.lineTo(w - inset, h - inset - len);
  ctx.stroke();
}

// Main canvas renderer
function renderShareCanvas(canvas, recipe, theme, format, photoImg, isFree) {
  const ctx = canvas.getContext('2d');
  const w = format.width;
  const h = format.height;
  canvas.width = w;
  canvas.height = h;

  // Background gradient
  const gradient = ctx.createLinearGradient(0, 0, w, h);
  for (const [color, stop] of theme.gradient) {
    gradient.addColorStop(stop, color);
  }
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, w, h);

  // Photo background if available
  if (photoImg) {
    ctx.save();
    ctx.globalAlpha = 0.25;
    const imgRatio = photoImg.width / photoImg.height;
    const canvasRatio = w / h;
    let sw, sh, sx, sy;
    if (imgRatio > canvasRatio) {
      sh = photoImg.height; sw = sh * canvasRatio;
      sx = (photoImg.width - sw) / 2; sy = 0;
    } else {
      sw = photoImg.width; sh = sw / canvasRatio;
      sx = 0; sy = (photoImg.height - sh) / 2;
    }
    ctx.drawImage(photoImg, sx, sy, sw, sh, 0, 0, w, h);
    ctx.globalAlpha = 1.0;
    // Dark overlay for text readability
    ctx.fillStyle = 'rgba(0,0,0,0.35)';
    ctx.fillRect(0, 0, w, h);
    ctx.restore();
  }

  // Top accent bar
  ctx.fillStyle = theme.decorBorder;
  ctx.fillRect(0, 0, w, 8);

  // Corner flourishes
  drawCornerFlourishes(ctx, w, h, theme.accentColor);

  ctx.textAlign = 'center';
  ctx.textBaseline = 'top';
  const maxTextW = w - 140;
  const isStory = format.id === 'story';

  // Adaptive sizes for story vs square
  const titleSize = isStory ? 64 : 56;
  const subtitleSize = isStory ? 36 : 32;
  const detailSize = isStory ? 28 : 24;
  const storySize = isStory ? 26 : 22;

  // Starting Y — push content lower for story format
  let y = isStory ? 300 : 150;

  // Category badge
  if (recipe.category) {
    ctx.font = `bold ${isStory ? 18 : 16}px Arial, sans-serif`;
    const catW = ctx.measureText(recipe.category.toUpperCase()).width + 32;
    ctx.fillStyle = theme.accentColor;
    const badgeRadius = 16;
    const badgeX = (w - catW) / 2;
    const badgeY = y - (isStory ? 60 : 50);
    ctx.beginPath();
    ctx.roundRect(badgeX, badgeY, catW, 32, badgeRadius);
    ctx.fill();
    ctx.fillStyle = theme.textColor;
    ctx.fillText(recipe.category.toUpperCase(), w / 2, badgeY + 7);
  }

  // Title
  ctx.font = `bold ${titleSize}px Georgia, serif`;
  ctx.fillStyle = theme.textColor;
  const titleLines = wrapCanvasText(ctx, recipe.title, maxTextW);
  for (const line of titleLines) {
    ctx.fillText(line, w / 2, y);
    y += titleSize + 14;
  }

  // Author
  y += 30;
  ctx.font = `italic ${subtitleSize}px Georgia, serif`;
  ctx.fillStyle = theme.textColor;
  ctx.globalAlpha = 0.9;
  ctx.fillText(`A family recipe by ${recipe.author_name}`, w / 2, y);
  ctx.globalAlpha = 1;
  y += subtitleSize + 50;

  // Details row
  ctx.font = `${detailSize}px Georgia, serif`;
  ctx.fillStyle = theme.textColor;
  ctx.globalAlpha = 0.85;
  const details = [];
  if (recipe.cooking_time) details.push(`${recipe.cooking_time} min`);
  if (recipe.servings) details.push(`Serves ${recipe.servings}`);
  if (recipe.difficulty) details.push(recipe.difficulty.charAt(0).toUpperCase() + recipe.difficulty.slice(1));
  ctx.fillText(details.join('  •  '), w / 2, y);
  ctx.globalAlpha = 1;
  y += detailSize + 40;

  // Divider
  ctx.strokeStyle = theme.accentColor;
  ctx.lineWidth = 2;
  ctx.beginPath();
  ctx.moveTo(w * 0.2, y);
  ctx.lineTo(w * 0.8, y);
  ctx.stroke();
  y += 40;

  // Story snippet (if available and there's room)
  if (recipe.story) {
    ctx.font = `italic ${storySize}px Georgia, serif`;
    ctx.fillStyle = theme.textColor;
    ctx.globalAlpha = 0.75;
    const storySnippet = recipe.story.length > 120 ? recipe.story.slice(0, 117) + '...' : recipe.story;
    const storyLines = wrapCanvasText(ctx, `"${storySnippet}"`, maxTextW - 40);
    const maxStoryLines = isStory ? 5 : 3;
    for (let i = 0; i < Math.min(storyLines.length, maxStoryLines); i++) {
      ctx.fillText(storyLines[i], w / 2, y);
      y += storySize + 10;
    }
    ctx.globalAlpha = 1;
    y += 30;
  }

  // Ingredients preview (story format has room)
  if (isStory && recipe.ingredients && recipe.ingredients.length > 0) {
    y += 10;
    ctx.font = `bold ${20}px Arial, sans-serif`;
    ctx.fillStyle = theme.textColor;
    ctx.globalAlpha = 0.7;
    ctx.fillText('INGREDIENTS', w / 2, y);
    y += 36;
    ctx.font = `${22}px Georgia, serif`;
    ctx.globalAlpha = 0.65;
    const maxIngredients = Math.min(recipe.ingredients.length, 6);
    for (let i = 0; i < maxIngredients; i++) {
      const ing = recipe.ingredients[i].length > 40 ? recipe.ingredients[i].slice(0, 37) + '...' : recipe.ingredients[i];
      ctx.fillText(ing, w / 2, y);
      y += 30;
    }
    if (recipe.ingredients.length > 6) {
      ctx.fillText(`+ ${recipe.ingredients.length - 6} more`, w / 2, y);
      y += 30;
    }
    ctx.globalAlpha = 1;
  }

  // Footer — pinned near bottom
  const footerY = h - (isStory ? 180 : 130);
  ctx.font = `bold 20px Arial, sans-serif`;
  ctx.fillStyle = theme.textColor;
  ctx.globalAlpha = 0.9;
  ctx.fillText('legacytable.app', w / 2, footerY);
  ctx.font = `28px Georgia, serif`;
  ctx.globalAlpha = 1;
  ctx.fillText('Legacy Table', w / 2, footerY + 35);
  ctx.font = `14px Arial, sans-serif`;
  ctx.globalAlpha = 0.7;
  ctx.fillText('Preserve and Share Your Family Culinary Heritage', w / 2, footerY + 75);
  ctx.globalAlpha = 1;

  // Watermark for free-tier users
  if (isFree) {
    ctx.save();
    ctx.translate(w / 2, h / 2);
    ctx.rotate(-Math.PI / 6);
    ctx.font = 'bold 72px Arial, sans-serif';
    ctx.fillStyle = theme.id === 'ivory' ? 'rgba(0,0,0,0.10)' : 'rgba(255,255,255,0.18)';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('LEGACY TABLE', 0, -40);
    ctx.font = 'bold 32px Arial, sans-serif';
    ctx.fillText('Upgrade to remove watermark', 0, 30);
    ctx.restore();
  }
}

// Share Recipe Card with theme & format selection
const ShareRecipeCard = ({ recipe }) => {
  const canvasRef = React.useRef(null);
  const { hasAny } = useSubscription();
  const [themeId, setThemeId] = useState('heritage');
  const [formatId, setFormatId] = useState('square');
  const [photoImg, setPhotoImg] = useState(null);

  const theme = SHARE_THEMES.find(t => t.id === themeId) || SHARE_THEMES[0];
  const format = SHARE_FORMATS.find(f => f.id === formatId) || SHARE_FORMATS[0];

  // Load first recipe photo as background
  useEffect(() => {
    if (!recipe.photos || recipe.photos.length === 0) {
      setPhotoImg(null);
      return;
    }
    const img = new Image();
    img.crossOrigin = 'anonymous';
    const src = recipe.photos[0].startsWith('data:') ? recipe.photos[0] : recipe.photos[0];
    img.onload = () => setPhotoImg(img);
    img.onerror = () => setPhotoImg(null);
    img.src = src;
  }, [recipe.photos]);

  // Render canvas when theme/format/photo changes
  useEffect(() => {
    if (!canvasRef.current) return;
    renderShareCanvas(canvasRef.current, recipe, theme, format, photoImg, !hasAny);
  }, [recipe, theme, format, photoImg, hasAny]);

  const handleDownloadImage = () => {
    if (!canvasRef.current) return;
    const link = document.createElement('a');
    link.href = canvasRef.current.toDataURL('image/png');
    const suffix = formatId === 'story' ? '_story' : '';
    link.download = `${recipe.title.replace(/\s+/g, '_')}${suffix}_legacy_table.png`;
    link.click();
    toast.success('Image downloaded!');
  };

  const handleShare = async () => {
    const shareUrl = `${window.location.origin}/recipe/${recipe.id}`;

    // Try sharing canvas as image if supported
    if (navigator.share && canvasRef.current) {
      try {
        const blob = await new Promise(resolve => canvasRef.current.toBlob(resolve, 'image/png'));
        const file = new File([blob], `${recipe.title}_legacy_table.png`, { type: 'image/png' });
        await navigator.share({
          title: recipe.title,
          text: `Check out "${recipe.title}" - A family recipe by ${recipe.author_name}`,
          url: shareUrl,
          files: [file],
        });
        return;
      } catch (err) {
        // If file sharing isn't supported, fall through to URL sharing
        if (err.name === 'AbortError') return;
      }
    }

    // Fallback: share URL or copy
    if (navigator.share) {
      try {
        await navigator.share({
          title: recipe.title,
          text: `Check out "${recipe.title}" - A family recipe by ${recipe.author_name}`,
          url: shareUrl,
        });
      } catch (err) {
        if (err.name !== 'AbortError') console.error('Share failed:', err);
      }
    } else {
      try {
        await navigator.clipboard.writeText(shareUrl);
        toast.success('Recipe link copied to clipboard!');
      } catch { toast.error('Failed to copy link'); }
    }
  };

  return (
    <div className="space-y-5">
      {/* Theme selector */}
      <div>
        <p className="text-xs font-medium text-muted-foreground mb-2 uppercase tracking-wider">Theme</p>
        <div className="flex gap-2 flex-wrap">
          {SHARE_THEMES.map(t => (
            <button
              key={t.id}
              onClick={() => setThemeId(t.id)}
              className={`flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium transition-all ${
                themeId === t.id
                  ? 'ring-2 ring-primary ring-offset-2 ring-offset-background'
                  : 'hover:ring-1 hover:ring-border'
              }`}
              style={{
                background: `linear-gradient(135deg, ${t.gradient[0][0]}, ${t.gradient[2][0]})`,
                color: t.textColor,
              }}
            >
              {t.name}
            </button>
          ))}
        </div>
      </div>

      {/* Format selector */}
      <div>
        <p className="text-xs font-medium text-muted-foreground mb-2 uppercase tracking-wider">Format</p>
        <div className="flex gap-2">
          {SHARE_FORMATS.map(f => (
            <button
              key={f.id}
              onClick={() => setFormatId(f.id)}
              className={`px-4 py-2 rounded-xl text-sm font-medium transition-all border ${
                formatId === f.id
                  ? 'border-primary bg-primary/10 text-primary'
                  : 'border-border text-muted-foreground hover:border-primary/50'
              }`}
            >
              {f.name} <span className="text-xs opacity-60">({f.label})</span>
            </button>
          ))}
        </div>
      </div>

      {/* Canvas preview */}
      <div className="flex justify-center">
        <canvas
          ref={canvasRef}
          className="rounded-2xl shadow-lg max-w-full border-4 border-primary/20"
          style={{ maxHeight: formatId === 'story' ? '700px' : '500px', width: 'auto' }}
        />
      </div>

      {/* Actions */}
      <div className="flex gap-3 justify-center flex-wrap">
        <Button
          onClick={handleDownloadImage}
          className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90 flex items-center gap-2 px-6 py-5"
        >
          <Download className="w-4 h-4" />
          Download
        </Button>
        <Button
          onClick={handleShare}
          variant="outline"
          className="rounded-full border-2 border-primary text-primary hover:bg-primary/5 flex items-center gap-2 px-6 py-5"
        >
          <Share2 className="w-4 h-4" />
          Share
        </Button>
      </div>

      {/* Link */}
      <div className="p-3 rounded-xl bg-muted/50 border border-border/50 text-center">
        <p className="text-xs text-muted-foreground">Recipe link</p>
        <p className="font-mono text-xs mt-1 break-all text-foreground">
          legacytable.app/recipes/{recipe.id}
        </p>
      </div>
    </div>
  );
};

const ShareRecipeModal = ({ recipe, isOpen, onClose }) => {
  if (!isOpen) return null;
  return (
    <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 animate-fade-in">
      <div className="bg-background rounded-3xl max-w-2xl w-full max-h-[90vh] overflow-y-auto animate-scale-up shadow-2xl">
        <div className="sticky top-0 bg-background border-b border-border/50 p-6 flex items-center justify-between z-10">
          <h2 className="font-serif text-2xl font-bold text-foreground">Share Recipe</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-muted rounded-full transition-colors"
            aria-label="Close"
          >
            <X className="w-6 h-6" />
          </button>
        </div>
        <div className="p-6">
          <ShareRecipeCard recipe={recipe} />
        </div>
        <div className="border-t border-border/50 p-4 flex justify-end">
          <Button
            onClick={onClose}
            variant="outline"
            className="rounded-full px-6 py-5"
          >
            Close
          </Button>
        </div>
      </div>
    </div>
  );
};

// Recipe Detail Page
const RecipeDetailPage = () => {
  const [recipe, setRecipe] = useState(null);
  const [loading, setLoading] = useState(true);
  const [currentPhotoIndex, setCurrentPhotoIndex] = useState(0);
  const [comments, setComments] = useState([]);
  const [newComment, setNewComment] = useState("");
  const [submittingComment, setSubmittingComment] = useState(false);
  const [accessDenied, setAccessDenied] = useState(false);
  const [shareModalOpen, setShareModalOpen] = useState(false);
  const [holidayTags, setHolidayTags] = useState([]);
  const [holidayPickerOpen, setHolidayPickerOpen] = useState(false);
  const [savingTags, setSavingTags] = useState(false);
  const { token, user } = useAuth();
  const navigate = useNavigate();
  const { id } = useParams();

  useEffect(() => {
    fetchRecipe();
    fetchComments();
  }, [id]);

  const fetchRecipe = async () => {
    try {
      const response = await axios.get(`${API}/recipes/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setRecipe(response.data);
      setHolidayTags(response.data.holiday_tags || []);
      setAccessDenied(false);
    } catch (error) {
      if (error.response?.status === 403) {
        setAccessDenied(true);
        setRecipe(null);
      } else {
        toast.error("Recipe not found");
        navigate("/home");
      }
    }
    setLoading(false);
  };

  const fetchComments = async () => {
    try {
      const response = await axios.get(`${API}/recipes/${id}/comments`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setComments(response.data);
    } catch (error) {
      console.error("Failed to load comments");
    }
  };

  const handleAddComment = async (e) => {
    e.preventDefault();
    if (!newComment.trim()) return;
    
    setSubmittingComment(true);
    try {
      const response = await axios.post(`${API}/recipes/${id}/comments`, 
        { text: newComment },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      setComments([response.data, ...comments]);
      setNewComment("");
      toast.success("Comment added!");
    } catch (error) {
      toast.error("Failed to add comment");
    }
    setSubmittingComment(false);
  };

  const handleDeleteComment = async (commentId) => {
    try {
      await axios.delete(`${API}/comments/${commentId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setComments(comments.filter(c => c.id !== commentId));
      toast.success("Comment deleted");
    } catch (error) {
      toast.error("Failed to delete comment");
    }
  };

  const handleDelete = async () => {
    if (!window.confirm("Are you sure you want to delete this recipe?")) return;
    
    try {
      await axios.delete(`${API}/recipes/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("Recipe deleted");
      navigate("/home");
    } catch (error) {
      if (error.response?.status === 403) {
        toast.error("You can't delete this recipe");
      } else {
        toast.error("Failed to delete recipe");
      }
    }
  };

  const canDeleteRecipe = recipe && (user?.id === recipe.author_id || user?.role === "keeper");

  // Holiday tagging
  const HOLIDAY_LIST = [
    { name: "New Year's Day", emoji: "🎆" }, { name: "MLK Day", emoji: "✊🏿" },
    { name: "Super Bowl Sunday", emoji: "🏈" }, { name: "Valentine's Day", emoji: "❤️" },
    { name: "Black History Month", emoji: "✊🏿" }, { name: "St. Patrick's Day", emoji: "☘️" },
    { name: "Easter", emoji: "🐣" }, { name: "Passover", emoji: "🕎" },
    { name: "Cinco de Mayo", emoji: "🇲🇽" }, { name: "Mother's Day", emoji: "💐" },
    { name: "Memorial Day", emoji: "🇺🇸" }, { name: "Juneteenth", emoji: "✊🏿" },
    { name: "Father's Day", emoji: "👔" }, { name: "4th of July", emoji: "🎇" },
    { name: "Back to School", emoji: "📚" }, { name: "Labor Day", emoji: "🍔" },
    { name: "Halloween", emoji: "🎃" }, { name: "Thanksgiving", emoji: "🦃" },
    { name: "Hanukkah", emoji: "🕎" }, { name: "Christmas", emoji: "🎄" },
    { name: "Kwanzaa", emoji: "🕯️" }, { name: "New Year's Eve", emoji: "🥂" },
  ];

  const toggleHolidayTag = async (holidayName) => {
    const newTags = holidayTags.includes(holidayName)
      ? holidayTags.filter(t => t !== holidayName)
      : [...holidayTags, holidayName];
    setSavingTags(true);
    try {
      await axios.post(`${API}/recipes/${id}/holiday-tags`, { tags: newTags }, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setHolidayTags(newTags);
      toast.success(holidayTags.includes(holidayName) ? "Holiday tag removed" : "Holiday tag added!");
    } catch (e) {
      toast.error("Failed to update holiday tags");
    }
    setSavingTags(false);
  };

  const getDifficultyClass = (difficulty) => {
    switch (difficulty?.toLowerCase()) {
      case 'easy': return 'difficulty-easy';
      case 'medium': return 'difficulty-medium';
      case 'hard': return 'difficulty-hard';
      default: return 'difficulty-easy';
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background">
        <Navigation />
        <div className="max-w-5xl mx-auto px-4 py-12">
          <div className="skeleton h-96 rounded-3xl mb-8" />
          <div className="skeleton h-10 w-2/3 mb-4" />
          <div className="skeleton h-6 w-1/3" />
        </div>
      </div>
    );
  }

  if (accessDenied) {
    return (
      <div className="min-h-screen bg-background" data-testid="recipe-detail-page">
        <Navigation />
        <div className="max-w-5xl mx-auto px-4 sm:px-6 py-12">
          <div className="text-center py-12 px-4 rounded-2xl bg-muted/50 border border-border">
            <h2 className="font-serif text-2xl font-semibold text-foreground mb-2">You don't have access to this recipe</h2>
            <p className="text-muted-foreground mb-6">Join the family to see it, or it may be private to another family.</p>
            <div className="flex flex-wrap gap-3 justify-center">
              <Button onClick={() => navigate("/home")} className="rounded-full" data-testid="recipe-403-go-home">
                Go home
              </Button>
              {!user?.family_id && (
                <Button variant="outline" onClick={() => navigate("/family")} className="rounded-full border-primary text-primary" data-testid="recipe-403-join-family">
                  Join a family
                </Button>
              )}
            </div>
          </div>
        </div>
      </div>
    );
  }

  if (!recipe) return null;

  return (
    <div className="min-h-screen bg-background" data-testid="recipe-detail-page">
      <Navigation />
      
      <div className="max-w-5xl mx-auto px-4 sm:px-6 py-8">
        {/* Photo Gallery */}
        {recipe.photos && recipe.photos.length > 0 && (
          <div className="mb-8 animate-fade-in">
            <div className="aspect-[16/10] rounded-3xl overflow-hidden bg-muted">
              <img 
                src={recipe.photos[currentPhotoIndex]} 
                alt={recipe.title}
                className="w-full h-full object-cover"
                data-testid="recipe-main-photo"
              />
            </div>
            {recipe.photos.length > 1 && (
              <div className="flex gap-2 mt-4 overflow-x-auto pb-2">
                {recipe.photos.map((photo, index) => (
                  <button
                    key={index}
                    onClick={() => setCurrentPhotoIndex(index)}
                    className={`flex-shrink-0 w-20 h-20 rounded-xl overflow-hidden border-2 transition-all ${
                      currentPhotoIndex === index ? 'border-primary' : 'border-transparent'
                    }`}
                    data-testid={`photo-thumb-${index}`}
                  >
                    <img src={photo} alt="" className="w-full h-full object-cover" />
                  </button>
                ))}
              </div>
            )}
          </div>
        )}

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8 lg:gap-12">
          {/* Main Content */}
          <div className="lg:col-span-2 animate-slide-up">
            <div className="flex items-start justify-between gap-4 mb-6">
              <div>
                <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2" data-testid="recipe-title">
                  {recipe.title}
                </h1>
                <div className="flex items-center gap-4 text-muted-foreground">
                  <span>by {recipe.author_name}</span>
                  <span className={`difficulty-badge ${getDifficultyClass(recipe.difficulty)}`}>
                    {recipe.difficulty}
                  </span>
                </div>
              </div>
              <Button
                variant="outline"
                size="sm"
                onClick={() => setShareModalOpen(true)}
                className="rounded-full border-2 border-primary text-primary hover:bg-primary/10"
                data-testid="share-recipe-btn"
              >
                <Share2 className="w-4 h-4 mr-1" />
                Share
              </Button>
              {(user?.id === recipe.author_id || user?.role === "keeper") && (
                <div className="flex gap-2">
                  <Button
                    size="sm"
                    onClick={() => navigate(`/recipe/${recipe.id}/cook`)}
                    className="rounded-full bg-amber-600 hover:bg-amber-700 text-white"
                    data-testid="cook-mode-btn"
                  >
                    <Flame className="w-4 h-4 mr-1" />
                    Cook Mode
                  </Button>
                  {user?.id === recipe.author_id && (
                    <Button 
                      variant="outline" 
                      size="sm"
                      onClick={() => navigate(`/recipe/${recipe.id}/edit`)}
                      className="rounded-full"
                      data-testid="edit-recipe-btn"
                    >
                      <Edit className="w-4 h-4 mr-1" />
                      Edit
                    </Button>
                  )}
                  {canDeleteRecipe && (
                    <Button 
                      variant="destructive" 
                      size="sm"
                      onClick={handleDelete}
                      className="rounded-full"
                      data-testid="delete-recipe-btn"
                    >
                      Delete
                    </Button>
                  )}
                </div>
              )}
            </div>

            <div className="prose prose-lg max-w-none">
              <h2 className="font-serif text-2xl font-semibold mb-4">Instructions</h2>
              <div className="text-foreground whitespace-pre-line leading-relaxed" data-testid="recipe-instructions">
                {recipe.instructions}
              </div>
            </div>

            {/* Recipe Story */}
            {recipe.story && (
              <div className="mt-10 p-6 rounded-2xl bg-primary/5 border border-primary/10" data-testid="recipe-story">
                <h2 className="font-serif text-2xl font-semibold mb-4 flex items-center gap-2">
                  <Heart className="w-5 h-5 text-primary" />
                  The Story
                </h2>
                <div className="text-foreground whitespace-pre-line leading-relaxed italic">
                  "{recipe.story}"
                </div>
                <p className="text-sm text-muted-foreground mt-4">— Shared by {recipe.author_name}</p>
              </div>
            )}

            {/* Holiday Tags */}
            <div className="mt-8">
              <div className="flex items-center justify-between mb-3">
                <h3 className="font-serif text-lg font-semibold flex items-center gap-2">
                  <Calendar className="w-4 h-4 text-primary" />
                  Holiday Tags
                </h3>
                <button
                  onClick={() => setHolidayPickerOpen(!holidayPickerOpen)}
                  className="text-sm text-primary hover:underline flex items-center gap-1"
                >
                  <Tag className="w-3 h-3" />
                  {holidayPickerOpen ? 'Done' : 'Edit tags'}
                </button>
              </div>

              {/* Current tags */}
              {holidayTags.length > 0 && (
                <div className="flex gap-2 flex-wrap mb-3">
                  {holidayTags.map(tag => {
                    const h = HOLIDAY_LIST.find(x => x.name === tag);
                    return (
                      <Badge key={tag} className="text-xs rounded-full bg-primary/10 text-primary border-0 px-3 py-1">
                        {h?.emoji} {tag}
                      </Badge>
                    );
                  })}
                </div>
              )}

              {holidayTags.length === 0 && !holidayPickerOpen && (
                <p className="text-sm text-muted-foreground">No holiday tags yet. Tag this recipe to include it in holiday collections!</p>
              )}

              {/* Holiday picker */}
              {holidayPickerOpen && (
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2 p-4 rounded-xl border bg-card">
                  {HOLIDAY_LIST.map(h => {
                    const isTagged = holidayTags.includes(h.name);
                    return (
                      <button
                        key={h.name}
                        onClick={() => toggleHolidayTag(h.name)}
                        disabled={savingTags}
                        className={`text-left text-xs p-2 rounded-lg border transition-all flex items-center gap-2 ${
                          isTagged
                            ? 'bg-primary/10 border-primary text-primary font-medium'
                            : 'border-border hover:border-primary/50 text-muted-foreground hover:text-foreground'
                        } ${savingTags ? 'opacity-50' : ''}`}
                      >
                        <span>{h.emoji}</span>
                        <span className="truncate">{h.name}</span>
                      </button>
                    );
                  })}
                </div>
              )}
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6 animate-fade-in" style={{ animationDelay: '0.2s' }}>
            {/* Quick Info */}
            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-6 space-y-4">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center">
                    <Clock className="w-5 h-5 text-primary" />
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Cooking Time</p>
                    <p className="font-semibold">{recipe.cooking_time} minutes</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-secondary/10 flex items-center justify-center">
                    <Users className="w-5 h-5 text-secondary" />
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Servings</p>
                    <p className="font-semibold">{recipe.servings} people</p>
                  </div>
                </div>
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-accent/20 flex items-center justify-center">
                    <Utensils className="w-5 h-5 text-accent-foreground" />
                  </div>
                  <div>
                    <p className="text-sm text-muted-foreground">Category</p>
                    <p className="font-semibold">{recipe.category}</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Ingredients */}
            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-6">
                <h3 className="font-serif text-xl font-semibold mb-4">Ingredients</h3>
                <ul className="space-y-2" data-testid="ingredients-list">
                  {recipe.ingredients.map((ingredient, index) => (
                    <li key={index} className="ingredient-item">
                      <span className="w-2 h-2 rounded-full bg-primary shrink-0" />
                      <span>{ingredient}</span>
                    </li>
                  ))}
                </ul>
              </CardContent>
            </Card>

            {/* Legacy Clips */}
            <LegacyClipsSection recipeId={recipe.id} />
          </div>
        </div>

        {/* Comments Section */}
        <div className="max-w-3xl mt-12 animate-fade-in" data-testid="comments-section">
          <h2 className="font-serif text-2xl font-semibold mb-6 flex items-center gap-2">
            <MessageCircle className="w-6 h-6 text-primary" />
            Family Comments ({comments.length})
          </h2>
          
          {/* Add Comment Form */}
          <form onSubmit={handleAddComment} className="mb-8">
            <div className="flex gap-3">
              <div className="flex-1">
                <Input
                  placeholder="Share your thoughts about this recipe..."
                  value={newComment}
                  onChange={(e) => setNewComment(e.target.value)}
                  className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30"
                  data-testid="comment-input"
                />
              </div>
              <Button 
                type="submit" 
                disabled={submittingComment || !newComment.trim()}
                className="rounded-xl bg-primary text-primary-foreground"
                data-testid="submit-comment-btn"
              >
                <Send className="w-4 h-4" />
              </Button>
            </div>
          </form>

          {/* Comments List */}
          <div className="space-y-4">
            {comments.length === 0 ? (
              <p className="text-muted-foreground text-center py-8">No comments yet. Be the first to share your thoughts!</p>
            ) : (
              comments.map((comment) => (
                <div 
                  key={comment.id} 
                  className="p-4 rounded-xl bg-card border border-border/50"
                  data-testid={`comment-${comment.id}`}
                >
                  <div className="flex items-start justify-between gap-3">
                    <div className="flex-1">
                      <div className="flex items-center gap-2 mb-2">
                        <span className="font-semibold text-foreground">{comment.user_name}</span>
                        <span className="text-xs text-muted-foreground">
                          {new Date(comment.created_at).toLocaleDateString('en-US', { 
                            month: 'short', 
                            day: 'numeric',
                            year: 'numeric'
                          })}
                        </span>
                      </div>
                      <p className="text-foreground">{comment.text}</p>
                    </div>
                    {user?.id === comment.user_id && (
                      <button
                        onClick={() => handleDeleteComment(comment.id)}
                        className="p-1 text-muted-foreground hover:text-destructive transition-colors"
                        data-testid={`delete-comment-${comment.id}`}
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    )}
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
};


// ===================== LEGACY CLIPS (Milestone 3.3) =====================

const LegacyClipsSection = ({ recipeId }) => {
  const [clips, setClips] = useState([]);
  const [recording, setRecording] = useState(false);
  const [uploading, setUploading] = useState(false);
  const [playingClip, setPlayingClip] = useState(null);
  const [playingVideo, setPlayingVideo] = useState(null);
  const [caption, setCaption] = useState("");
  const [recordingTime, setRecordingTime] = useState(0);
  const [videoBlob, setVideoBlob] = useState(null);
  const [videoPreview, setVideoPreview] = useState(null);
  const mediaRecorderRef = React.useRef(null);
  const chunksRef = React.useRef([]);
  const timerRef = React.useRef(null);
  const videoInputRef = React.useRef(null);
  const { token, user } = useAuth();

  useEffect(() => {
    fetchClips();
  }, [recipeId]);

  useEffect(() => {
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
    };
  }, []);

  const fetchClips = async () => {
    try {
      const res = await axios.get(`${API}/recipes/${recipeId}/clips`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setClips(res.data.clips);
    } catch (e) {
      console.error("Failed to load clips");
    }
  };

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: "environment", width: { ideal: 720 }, height: { ideal: 720 } },
        audio: true,
      });
      const mediaRecorder = new MediaRecorder(stream, { mimeType: "video/webm" });
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      mediaRecorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: "video/webm" });
        setVideoBlob(blob);
        setVideoPreview(URL.createObjectURL(blob));
        stream.getTracks().forEach(t => t.stop());
      };

      mediaRecorder.start();
      setRecording(true);
      setRecordingTime(0);
      timerRef.current = setInterval(() => {
        setRecordingTime(t => {
          if (t >= 29) {
            stopRecording();
            return 30;
          }
          return t + 1;
        });
      }, 1000);
    } catch (err) {
      toast.error("Could not access camera/microphone");
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state !== "inactive") {
      mediaRecorderRef.current.stop();
    }
    setRecording(false);
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
  };

  const handleFileSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (file.size > 16 * 1024 * 1024) {
      toast.error("Video too large. Please use clips under 30 seconds.");
      return;
    }
    setVideoBlob(file);
    setVideoPreview(URL.createObjectURL(file));
  };

  const handleUpload = async () => {
    if (!videoBlob) return;
    setUploading(true);
    try {
      const reader = new FileReader();
      const base64 = await new Promise((resolve) => {
        reader.onload = () => resolve(reader.result);
        reader.readAsDataURL(videoBlob);
      });

      await axios.post(`${API}/recipes/${recipeId}/clips`, {
        video: base64,
        caption: caption.trim(),
        duration: recordingTime || 0,
      }, {
        headers: { Authorization: `Bearer ${token}` },
        timeout: 120000,
      });

      toast.success("Legacy clip added!");
      setVideoBlob(null);
      setVideoPreview(null);
      setCaption("");
      setRecordingTime(0);
      fetchClips();
    } catch (err) {
      const detail = err.response?.data?.detail;
      toast.error(typeof detail === "string" ? detail : "Failed to upload clip");
    }
    setUploading(false);
  };

  const handlePlayClip = async (clipId) => {
    if (playingClip === clipId) {
      setPlayingClip(null);
      setPlayingVideo(null);
      return;
    }
    try {
      const res = await axios.get(`${API}/recipes/${recipeId}/clips/${clipId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setPlayingClip(clipId);
      setPlayingVideo(res.data.clip.video);
    } catch (e) {
      toast.error("Failed to load clip");
    }
  };

  const handleDeleteClip = async (clipId) => {
    if (!window.confirm("Delete this legacy clip?")) return;
    try {
      await axios.delete(`${API}/recipes/${recipeId}/clips/${clipId}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setClips(clips.filter(c => c.id !== clipId));
      if (playingClip === clipId) {
        setPlayingClip(null);
        setPlayingVideo(null);
      }
      toast.success("Clip deleted");
    } catch (e) {
      toast.error("Failed to delete clip");
    }
  };

  return (
    <Card className="rounded-2xl border-border/50">
      <CardContent className="p-6">
        <h3 className="font-serif text-lg font-semibold mb-3 flex items-center gap-2">
          <Video className="w-5 h-5 text-primary" />
          Legacy Clips
        </h3>

        {/* Existing clips */}
        {clips.length > 0 && (
          <div className="space-y-2 mb-4">
            {clips.map(clip => (
              <div key={clip.id} className="flex items-center gap-3 p-2 rounded-xl bg-muted/50">
                <button
                  onClick={() => handlePlayClip(clip.id)}
                  className="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center flex-shrink-0"
                >
                  <Video className="w-5 h-5 text-primary" />
                </button>
                <div className="min-w-0 flex-1">
                  <p className="text-sm font-medium truncate">{clip.caption || "Legacy clip"}</p>
                  <p className="text-xs text-muted-foreground">by {clip.author_name} · {clip.duration}s</p>
                </div>
                {(clip.author_id === user?.id || user?.role === "keeper") && (
                  <button onClick={() => handleDeleteClip(clip.id)} className="text-muted-foreground hover:text-red-500">
                    <Trash2 className="w-4 h-4" />
                  </button>
                )}
              </div>
            ))}
          </div>
        )}

        {/* Video player */}
        {playingVideo && (
          <div className="mb-4 rounded-xl overflow-hidden bg-black">
            <video src={playingVideo} controls autoPlay className="w-full max-h-64" />
          </div>
        )}

        {/* Record / upload */}
        {!videoBlob ? (
          <div className="flex gap-2">
            <Button onClick={recording ? stopRecording : startRecording} size="sm" variant={recording ? "destructive" : "outline"} className="rounded-full text-xs flex-1">
              {recording ? (
                <><X className="w-3 h-3 mr-1" /> Stop ({30 - recordingTime}s)</>
              ) : (
                <><Video className="w-3 h-3 mr-1" /> Record Clip</>
              )}
            </Button>
            <label>
              <Button size="sm" variant="outline" className="rounded-full text-xs" asChild>
                <span><Upload className="w-3 h-3 mr-1" /> Upload</span>
              </Button>
              <input ref={videoInputRef} type="file" accept="video/*" onChange={handleFileSelect} className="hidden" />
            </label>
          </div>
        ) : (
          <div className="space-y-3">
            <video src={videoPreview} controls className="w-full rounded-xl max-h-48" />
            <Input
              placeholder="Add a caption..."
              value={caption}
              onChange={(e) => setCaption(e.target.value)}
              className="text-sm rounded-full"
              maxLength={200}
            />
            <div className="flex gap-2">
              <Button onClick={handleUpload} disabled={uploading} size="sm" className="rounded-full bg-primary flex-1 text-xs">
                {uploading ? "Uploading..." : "Save Clip"}
              </Button>
              <Button onClick={() => { setVideoBlob(null); setVideoPreview(null); }} size="sm" variant="outline" className="rounded-full text-xs">
                Discard
              </Button>
            </div>
          </div>
        )}

        {clips.length === 0 && !videoBlob && !recording && (
          <p className="text-xs text-muted-foreground mt-2">Record a short memory — share the story behind this dish!</p>
        )}
      </CardContent>
    </Card>
  );
};


// ===================== AI RECIPE SCANNER (Milestone 2.1) =====================

const ScanRecipePage = () => {
  const [image, setImage] = useState(null);
  const [scanning, setScanning] = useState(false);
  const [result, setResult] = useState(null);
  const [cameraActive, setCameraActive] = useState(false);
  const videoRef = React.useRef(null);
  const streamRef = React.useRef(null);
  const { token } = useAuth();
  const { hasCredits, credits } = useSubscription();
  const navigate = useNavigate();

  const handleFileSelect = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = (ev) => setImage(ev.target.result);
    reader.readAsDataURL(file);
  };

  const startCamera = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: "environment", width: { ideal: 1920 }, height: { ideal: 1080 } },
      });
      streamRef.current = stream;
      if (videoRef.current) {
        videoRef.current.srcObject = stream;
        videoRef.current.play();
      }
      setCameraActive(true);
    } catch (err) {
      toast.error("Could not access camera");
    }
  };

  const capturePhoto = () => {
    if (!videoRef.current) return;
    const canvas = document.createElement("canvas");
    canvas.width = videoRef.current.videoWidth;
    canvas.height = videoRef.current.videoHeight;
    canvas.getContext("2d").drawImage(videoRef.current, 0, 0);
    const dataUrl = canvas.toDataURL("image/jpeg", 0.9);
    setImage(dataUrl);
    stopCamera();
  };

  const stopCamera = () => {
    if (streamRef.current) {
      streamRef.current.getTracks().forEach(t => t.stop());
      streamRef.current = null;
    }
    setCameraActive(false);
  };

  useEffect(() => {
    return () => stopCamera();
  }, []);

  const handleScan = async () => {
    if (!image) return;
    setScanning(true);
    try {
      const res = await axios.post(`${API}/ai/scan-recipe`, { image }, {
        headers: { Authorization: `Bearer ${token}` },
        timeout: 60000,
      });
      setResult(res.data.recipe);
      toast.success("Recipe extracted!");
    } catch (err) {
      const detail = err.response?.data?.detail;
      if (typeof detail === "object" && detail.error === "insufficient_credits") {
        toast.error(detail.message);
      } else {
        toast.error(typeof detail === "string" ? detail : "Failed to scan recipe. Try a clearer photo.");
      }
    }
    setScanning(false);
  };

  const handleSaveRecipe = async () => {
    if (!result) return;
    try {
      const payload = {
        title: result.title,
        ingredients: result.ingredients,
        instructions: result.instructions,
        cooking_time: result.cooking_time || 30,
        servings: result.servings || 4,
        category: result.category || "Main Course",
        difficulty: result.difficulty || "easy",
        story: result.story || "",
        photos: image ? [image] : [],
      };
      const res = await axios.post(`${API}/recipes`, payload, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("Recipe saved to your collection!");
      navigate(`/recipe/${res.data.id}`);
    } catch (err) {
      toast.error("Failed to save recipe");
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      <div className="max-w-2xl mx-auto px-4 py-8">
        <button onClick={() => navigate(-1)} className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-6">
          <ChevronLeft className="w-4 h-4" /> Back
        </button>

        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-4">
            <Camera className="w-8 h-8 text-primary" />
          </div>
          <h1 className="font-serif text-3xl font-bold mb-2">Scan a Recipe</h1>
          <p className="text-muted-foreground">Take a photo of a handwritten or printed recipe and AI will digitize it</p>
          {credits && (
            <p className="text-xs text-muted-foreground mt-2">Uses 1 credit · {credits.balance} remaining</p>
          )}
        </div>

        {!result ? (
          <>
            {/* Image capture */}
            {!image ? (
              <div className="space-y-4">
                {cameraActive ? (
                  <div className="relative rounded-2xl overflow-hidden bg-black">
                    <video ref={videoRef} className="w-full" autoPlay playsInline muted />
                    <div className="absolute bottom-4 left-0 right-0 flex justify-center gap-4">
                      <Button onClick={capturePhoto} className="rounded-full bg-white text-black hover:bg-gray-100 px-6">
                        <Camera className="w-5 h-5 mr-2" /> Capture
                      </Button>
                      <Button onClick={stopCamera} variant="outline" className="rounded-full border-white text-white hover:bg-white/20">
                        Cancel
                      </Button>
                    </div>
                  </div>
                ) : (
                  <div className="border-2 border-dashed border-border rounded-2xl p-12 text-center">
                    <Camera className="w-12 h-12 text-muted-foreground/50 mx-auto mb-4" />
                    <div className="flex flex-col sm:flex-row gap-3 justify-center">
                      <Button onClick={startCamera} className="rounded-full bg-primary">
                        <Camera className="w-4 h-4 mr-2" /> Take Photo
                      </Button>
                      <label>
                        <Button variant="outline" className="rounded-full" asChild>
                          <span><Upload className="w-4 h-4 mr-2" /> Upload Photo</span>
                        </Button>
                        <input type="file" accept="image/*" onChange={handleFileSelect} className="hidden" />
                      </label>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <div className="space-y-4">
                <div className="rounded-2xl overflow-hidden border">
                  <img src={image} alt="Recipe to scan" className="w-full max-h-96 object-contain bg-muted" />
                </div>
                <div className="flex gap-3 justify-center">
                  <Button onClick={handleScan} disabled={scanning || !hasCredits(1)} className="rounded-full bg-primary px-8">
                    {scanning ? (
                      <><span className="animate-spin mr-2">⏳</span> Scanning...</>
                    ) : (
                      <><Sparkles className="w-4 h-4 mr-2" /> Scan Recipe</>
                    )}
                  </Button>
                  <Button onClick={() => setImage(null)} variant="outline" className="rounded-full">
                    Retake
                  </Button>
                </div>
              </div>
            )}
          </>
        ) : (
          /* Scanned result */
          <div className="space-y-6">
            <Card>
              <CardContent className="p-6">
                <h2 className="font-serif text-2xl font-bold mb-1">{result.title}</h2>
                <div className="flex gap-3 text-sm text-muted-foreground mb-4">
                  <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {result.cooking_time} min</span>
                  <span>{result.servings} servings</span>
                  <Badge variant="outline" className="text-xs">{result.category}</Badge>
                  <span className={`difficulty-badge difficulty-${result.difficulty}`}>{result.difficulty}</span>
                </div>

                <h3 className="font-semibold mb-2">Ingredients</h3>
                <ul className="space-y-1 mb-4">
                  {result.ingredients.map((ing, i) => (
                    <li key={i} className="text-sm flex items-start gap-2">
                      <span className="text-primary mt-1">•</span> {ing}
                    </li>
                  ))}
                </ul>

                <h3 className="font-semibold mb-2">Instructions</h3>
                <p className="text-sm whitespace-pre-line text-muted-foreground">{result.instructions}</p>

                {result.story && (
                  <div className="mt-4 p-4 rounded-xl bg-primary/5">
                    <h3 className="font-semibold mb-1 flex items-center gap-1">
                      <Heart className="w-4 h-4 text-primary" /> Story
                    </h3>
                    <p className="text-sm italic text-muted-foreground">{result.story}</p>
                  </div>
                )}
              </CardContent>
            </Card>

            <div className="flex gap-3 justify-center">
              <Button onClick={handleSaveRecipe} className="rounded-full bg-primary px-8">
                <Plus className="w-4 h-4 mr-2" /> Save to Collection
              </Button>
              <Button onClick={() => { setResult(null); setImage(null); }} variant="outline" className="rounded-full">
                Scan Another
              </Button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};


// ===================== VOICE-TO-RECIPE (Milestone 2.2) =====================

const VoiceRecipePage = () => {
  const [recording, setRecording] = useState(false);
  const [audioBlob, setAudioBlob] = useState(null);
  const [processing, setProcessing] = useState(false);
  const [result, setResult] = useState(null);
  const [transcription, setTranscription] = useState(null);
  const [recordingTime, setRecordingTime] = useState(0);
  const mediaRecorderRef = React.useRef(null);
  const chunksRef = React.useRef([]);
  const timerRef = React.useRef(null);
  const { token } = useAuth();
  const { hasCredits, credits } = useSubscription();
  const navigate = useNavigate();

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream, { mimeType: "audio/webm" });
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      mediaRecorder.onstop = () => {
        const blob = new Blob(chunksRef.current, { type: "audio/webm" });
        setAudioBlob(blob);
        stream.getTracks().forEach(t => t.stop());
      };

      mediaRecorder.start();
      setRecording(true);
      setRecordingTime(0);
      timerRef.current = setInterval(() => setRecordingTime(t => t + 1), 1000);
    } catch (err) {
      toast.error("Could not access microphone");
    }
  };

  const stopRecording = () => {
    if (mediaRecorderRef.current && mediaRecorderRef.current.state !== "inactive") {
      mediaRecorderRef.current.stop();
    }
    setRecording(false);
    if (timerRef.current) {
      clearInterval(timerRef.current);
      timerRef.current = null;
    }
  };

  useEffect(() => {
    return () => {
      if (timerRef.current) clearInterval(timerRef.current);
      if (mediaRecorderRef.current && mediaRecorderRef.current.state !== "inactive") {
        mediaRecorderRef.current.stop();
      }
    };
  }, []);

  const formatTime = (s) => `${Math.floor(s / 60)}:${String(s % 60).padStart(2, "0")}`;

  const handleProcess = async () => {
    if (!audioBlob) return;
    setProcessing(true);
    try {
      // Convert blob to base64
      const reader = new FileReader();
      const base64 = await new Promise((resolve) => {
        reader.onload = () => resolve(reader.result.split(",")[1]);
        reader.readAsDataURL(audioBlob);
      });

      const res = await axios.post(`${API}/ai/voice-to-recipe`, {
        audio: base64,
        format: "webm",
      }, {
        headers: { Authorization: `Bearer ${token}` },
        timeout: 120000,
      });

      setResult(res.data.recipe);
      setTranscription(res.data.transcription);
      toast.success("Recipe extracted from voice!");
    } catch (err) {
      const detail = err.response?.data?.detail;
      if (typeof detail === "object" && detail.error === "insufficient_credits") {
        toast.error(detail.message);
      } else {
        toast.error(typeof detail === "string" ? detail : "Failed to process audio. Try speaking more clearly.");
      }
    }
    setProcessing(false);
  };

  const handleSaveRecipe = async () => {
    if (!result) return;
    try {
      const payload = {
        title: result.title,
        ingredients: result.ingredients,
        instructions: result.instructions,
        cooking_time: result.cooking_time || 30,
        servings: result.servings || 4,
        category: result.category || "Main Course",
        difficulty: result.difficulty || "easy",
        story: result.story || "",
        photos: [],
      };
      const res = await axios.post(`${API}/recipes`, payload, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("Recipe saved to your collection!");
      navigate(`/recipe/${res.data.id}`);
    } catch (err) {
      toast.error("Failed to save recipe");
    }
  };

  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      <div className="max-w-2xl mx-auto px-4 py-8">
        <button onClick={() => navigate(-1)} className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-6">
          <ChevronLeft className="w-4 h-4" /> Back
        </button>

        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-amber-500/10 flex items-center justify-center mx-auto mb-4">
            <Volume2 className="w-8 h-8 text-amber-600" />
          </div>
          <h1 className="font-serif text-3xl font-bold mb-2">Voice a Recipe</h1>
          <p className="text-muted-foreground">Speak a recipe out loud and AI will transcribe and structure it</p>
          {credits && (
            <p className="text-xs text-muted-foreground mt-2">Uses 2 credits · {credits.balance} remaining</p>
          )}
        </div>

        {!result ? (
          <div className="space-y-6">
            {/* Recording UI */}
            <div className="text-center">
              {!audioBlob ? (
                <div className="space-y-4">
                  <div className={`w-32 h-32 rounded-full mx-auto flex items-center justify-center transition-all ${
                    recording ? 'bg-red-500 animate-pulse shadow-lg shadow-red-500/30' : 'bg-muted hover:bg-muted/80'
                  }`}>
                    {recording ? (
                      <button onClick={stopRecording} className="text-white">
                        <X className="w-12 h-12" />
                      </button>
                    ) : (
                      <button onClick={startRecording} className="text-muted-foreground">
                        <Volume2 className="w-12 h-12" />
                      </button>
                    )}
                  </div>

                  {recording ? (
                    <div>
                      <p className="text-lg font-mono text-red-500">{formatTime(recordingTime)}</p>
                      <p className="text-sm text-muted-foreground">Recording... Tap the button to stop</p>
                    </div>
                  ) : (
                    <p className="text-sm text-muted-foreground">Tap to start recording your recipe</p>
                  )}

                  <div className="p-4 rounded-xl bg-muted/50 text-left max-w-md mx-auto">
                    <p className="text-sm font-semibold mb-2">Tips for best results:</p>
                    <ul className="text-xs text-muted-foreground space-y-1">
                      <li>• Start with the recipe name</li>
                      <li>• List ingredients with quantities</li>
                      <li>• Describe steps in order</li>
                      <li>• Share any family stories — we'll capture those too!</li>
                    </ul>
                  </div>
                </div>
              ) : (
                <div className="space-y-4">
                  <div className="w-32 h-32 rounded-full mx-auto flex items-center justify-center bg-green-500/10">
                    <Volume2 className="w-12 h-12 text-green-600" />
                  </div>
                  <p className="text-sm text-muted-foreground">Recording captured — {formatTime(recordingTime)}</p>
                  <div className="flex gap-3 justify-center">
                    <Button onClick={handleProcess} disabled={processing || !hasCredits(2)} className="rounded-full bg-primary px-8">
                      {processing ? (
                        <><span className="animate-spin mr-2">⏳</span> Processing...</>
                      ) : (
                        <><Sparkles className="w-4 h-4 mr-2" /> Extract Recipe</>
                      )}
                    </Button>
                    <Button onClick={() => { setAudioBlob(null); setRecordingTime(0); }} variant="outline" className="rounded-full">
                      Re-record
                    </Button>
                  </div>
                </div>
              )}
            </div>
          </div>
        ) : (
          /* Voice result */
          <div className="space-y-6">
            {/* Transcription */}
            {transcription && (
              <div className="p-4 rounded-xl bg-muted/50">
                <h3 className="text-sm font-semibold mb-1">What we heard:</h3>
                <p className="text-xs text-muted-foreground italic">"{transcription.length > 200 ? transcription.slice(0, 200) + "..." : transcription}"</p>
              </div>
            )}

            <Card>
              <CardContent className="p-6">
                <h2 className="font-serif text-2xl font-bold mb-1">{result.title}</h2>
                <div className="flex gap-3 text-sm text-muted-foreground mb-4">
                  <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {result.cooking_time} min</span>
                  <span>{result.servings} servings</span>
                  <Badge variant="outline" className="text-xs">{result.category}</Badge>
                </div>

                <h3 className="font-semibold mb-2">Ingredients</h3>
                <ul className="space-y-1 mb-4">
                  {result.ingredients.map((ing, i) => (
                    <li key={i} className="text-sm flex items-start gap-2">
                      <span className="text-primary mt-1">•</span> {ing}
                    </li>
                  ))}
                </ul>

                <h3 className="font-semibold mb-2">Instructions</h3>
                <p className="text-sm whitespace-pre-line text-muted-foreground">{result.instructions}</p>

                {result.story && (
                  <div className="mt-4 p-4 rounded-xl bg-primary/5">
                    <h3 className="font-semibold mb-1 flex items-center gap-1">
                      <Heart className="w-4 h-4 text-primary" /> Story
                    </h3>
                    <p className="text-sm italic text-muted-foreground">{result.story}</p>
                  </div>
                )}
              </CardContent>
            </Card>

            <div className="flex gap-3 justify-center">
              <Button onClick={handleSaveRecipe} className="rounded-full bg-primary px-8">
                <Plus className="w-4 h-4 mr-2" /> Save to Collection
              </Button>
              <Button onClick={() => { setResult(null); setTranscription(null); setAudioBlob(null); setRecordingTime(0); }} variant="outline" className="rounded-full">
                Record Another
              </Button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};


// ===================== SAVE FROM LINK (Milestone 3.2) =====================

const SaveFromLinkPage = () => {
  const [url, setUrl] = useState("");
  const [processing, setProcessing] = useState(false);
  const [result, setResult] = useState(null);
  const [metadata, setMetadata] = useState(null);
  const { token } = useAuth();
  const { hasCredits, credits } = useSubscription();
  const navigate = useNavigate();

  const handleExtract = async () => {
    if (!url.trim()) return;
    setProcessing(true);
    try {
      const res = await axios.post(`${API}/ai/save-from-link`, { url: url.trim() }, {
        headers: { Authorization: `Bearer ${token}` },
        timeout: 60000,
      });
      setResult(res.data.recipe);
      setMetadata(res.data.metadata);
      toast.success("Recipe extracted from link!");
    } catch (err) {
      const detail = err.response?.data?.detail;
      if (typeof detail === "object" && detail.error === "insufficient_credits") {
        toast.error(detail.message);
      } else {
        toast.error(typeof detail === "string" ? detail : "Failed to extract recipe from this link.");
      }
    }
    setProcessing(false);
  };

  const handleSaveRecipe = async () => {
    if (!result) return;
    try {
      const story = [result.story, result.source_url ? `Source: ${result.source_url}` : ""].filter(Boolean).join("\n\n");
      const payload = {
        title: result.title,
        ingredients: result.ingredients,
        instructions: result.instructions,
        cooking_time: result.cooking_time || 30,
        servings: result.servings || 4,
        category: result.category || "Main Course",
        difficulty: result.difficulty || "easy",
        story,
        photos: [],
      };
      const res = await axios.post(`${API}/recipes`, payload, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("Recipe saved to your collection!");
      navigate(`/recipe/${res.data.id}`);
    } catch (err) {
      toast.error("Failed to save recipe");
    }
  };

  const isPasteableUrl = (text) => /^https?:\/\/.+/.test(text.trim());

  return (
    <div className="min-h-screen bg-background">
      <Navigation />
      <div className="max-w-2xl mx-auto px-4 py-8">
        <button onClick={() => navigate(-1)} className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground mb-6">
          <ChevronLeft className="w-4 h-4" /> Back
        </button>

        <div className="text-center mb-8">
          <div className="w-16 h-16 rounded-2xl bg-pink-500/10 flex items-center justify-center mx-auto mb-4">
            <Link2 className="w-8 h-8 text-pink-600" />
          </div>
          <h1 className="font-serif text-3xl font-bold mb-2">Save from Link</h1>
          <p className="text-muted-foreground">Paste a TikTok, Instagram, or YouTube cooking video link</p>
          {credits && (
            <p className="text-xs text-muted-foreground mt-2">Uses 1 credit · {credits.balance} remaining</p>
          )}
        </div>

        {!result ? (
          <div className="space-y-6">
            <div className="space-y-3">
              <Input
                placeholder="https://www.tiktok.com/@chef/video/..."
                value={url}
                onChange={(e) => setUrl(e.target.value)}
                className="text-center rounded-full border-2 py-6 text-base"
              />
              <Button
                onClick={handleExtract}
                disabled={processing || !isPasteableUrl(url) || !hasCredits(1)}
                className="rounded-full bg-primary px-8 w-full sm:w-auto mx-auto block"
              >
                {processing ? (
                  <><span className="animate-spin mr-2">⏳</span> Extracting...</>
                ) : (
                  <><Sparkles className="w-4 h-4 mr-2" /> Extract Recipe</>
                )}
              </Button>
            </div>

            <div className="grid grid-cols-3 gap-3 max-w-sm mx-auto">
              {[
                { name: "TikTok", color: "text-foreground", icon: "🎵" },
                { name: "Instagram", color: "text-pink-500", icon: "📸" },
                { name: "YouTube", color: "text-red-500", icon: "▶️" },
              ].map(p => (
                <div key={p.name} className="text-center p-3 rounded-xl bg-muted/50">
                  <span className="text-xl">{p.icon}</span>
                  <p className={`text-xs mt-1 ${p.color}`}>{p.name}</p>
                </div>
              ))}
            </div>

            <div className="p-4 rounded-xl bg-muted/50 text-sm text-muted-foreground">
              <p className="font-semibold mb-1">How it works:</p>
              <p>Paste any cooking video link and our AI extracts the recipe — title, ingredients, instructions, and all. The original video creator is credited in the story.</p>
            </div>
          </div>
        ) : (
          <div className="space-y-6">
            {/* Source info */}
            {metadata && metadata.thumbnail && (
              <div className="flex items-center gap-4 p-4 rounded-xl bg-muted/50">
                <img src={metadata.thumbnail} alt="" className="w-20 h-20 rounded-lg object-cover" />
                <div className="min-w-0">
                  <p className="text-sm font-semibold truncate">{metadata.title || "Video"}</p>
                  {metadata.author && <p className="text-xs text-muted-foreground">by {metadata.author}</p>}
                </div>
              </div>
            )}

            <Card>
              <CardContent className="p-6">
                <h2 className="font-serif text-2xl font-bold mb-1">{result.title}</h2>
                <div className="flex gap-3 text-sm text-muted-foreground mb-4">
                  <span className="flex items-center gap-1"><Clock className="w-3 h-3" /> {result.cooking_time} min</span>
                  <span>{result.servings} servings</span>
                  <Badge variant="outline" className="text-xs">{result.category}</Badge>
                </div>

                <h3 className="font-semibold mb-2">Ingredients</h3>
                <ul className="space-y-1 mb-4">
                  {result.ingredients.map((ing, i) => (
                    <li key={i} className="text-sm flex items-start gap-2">
                      <span className="text-primary mt-1">•</span> {ing}
                    </li>
                  ))}
                </ul>

                <h3 className="font-semibold mb-2">Instructions</h3>
                <p className="text-sm whitespace-pre-line text-muted-foreground">{result.instructions}</p>

                {result.source_author && (
                  <p className="text-xs text-muted-foreground mt-4 flex items-center gap-1">
                    <Link2 className="w-3 h-3" /> Inspired by {result.source_author}
                  </p>
                )}
              </CardContent>
            </Card>

            <div className="flex gap-3 justify-center">
              <Button onClick={handleSaveRecipe} className="rounded-full bg-primary px-8">
                <Plus className="w-4 h-4 mr-2" /> Save to Collection
              </Button>
              <Button onClick={() => { setResult(null); setMetadata(null); setUrl(""); }} variant="outline" className="rounded-full">
                Try Another Link
              </Button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};


// Cook Mode Page: Full-screen cooking interface with step-by-step instructions, TTS, and timers
const CookModePage = () => {
  const { id } = useParams();
  const { token } = useAuth();
  const navigate = useNavigate();
  const { canAccess } = useSubscription();
  const [recipe, setRecipe] = useState(null);
  const [loading, setLoading] = useState(true);
  const [currentStep, setCurrentStep] = useState(0);
  const [checkedIngredients, setCheckedIngredients] = useState({});
  const [screenAwake, setScreenAwake] = useState(false);
  const wakeLockRef = React.useRef(null);
  const [timerMinutes, setTimerMinutes] = useState(0);
  const [timerSeconds, setTimerSeconds] = useState(0);
  const [timerActive, setTimerActive] = useState(false);
  const [accessDenied, setAccessDenied] = useState(false);
  // TTS state
  const [ttsEnabled, setTtsEnabled] = useState(false);
  const [ttsSpeaking, setTtsSpeaking] = useState(false);
  const [ttsRate, setTtsRate] = useState(0.9);
  const [showIngredients, setShowIngredients] = useState(false);

  // Parse instructions into steps — handles both newline-separated and paragraph-style
  const parseSteps = (instructionsText) => {
    if (!instructionsText) return [];
    // First try splitting by newlines
    const lines = instructionsText.split('\n').filter(line => line.trim());
    if (lines.length > 1) return lines.map(line => line.trim());
    // Single block of text — split by sentences (period followed by space + capital letter, or period at end)
    const text = instructionsText.trim();
    const sentences = text.match(/[^.!?]+[.!?]+(?:\s|$)/g);
    if (sentences && sentences.length > 1) {
      return sentences.map(s => s.trim()).filter(s => s.length > 0);
    }
    // Fallback: return as single step
    return [text];
  };

  useEffect(() => {
    fetchRecipe();
  }, [id]);

  const fetchRecipe = async () => {
    try {
      const response = await axios.get(`${API}/recipes/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setRecipe(response.data);
      setAccessDenied(false);
      setLoading(false);
    } catch (error) {
      if (error.response?.status === 403) {
        setAccessDenied(true);
      } else {
        toast.error("Recipe not found");
        navigate("/home");
      }
      setLoading(false);
    }
  };

  // ---- Text-to-Speech ----
  const speak = React.useCallback((text) => {
    if (!('speechSynthesis' in window)) {
      toast.error("Text-to-speech is not supported on this browser");
      return;
    }
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.rate = ttsRate;
    utterance.pitch = 1;
    utterance.onstart = () => setTtsSpeaking(true);
    utterance.onend = () => setTtsSpeaking(false);
    utterance.onerror = () => setTtsSpeaking(false);
    window.speechSynthesis.speak(utterance);
  }, [ttsRate]);

  const stopSpeaking = () => {
    if ('speechSynthesis' in window) {
      window.speechSynthesis.cancel();
    }
    setTtsSpeaking(false);
  };

  // Auto-read step when TTS is enabled and step changes
  const steps = recipe ? parseSteps(recipe.instructions) : [];
  const currentStepText = steps[currentStep] || "";

  useEffect(() => {
    if (ttsEnabled && currentStepText) {
      speak(currentStepText);
    }
    return () => { if ('speechSynthesis' in window) window.speechSynthesis.cancel(); };
  }, [currentStep, ttsEnabled, currentStepText, speak]);

  // Cleanup TTS on unmount
  useEffect(() => {
    return () => {
      if ('speechSynthesis' in window) window.speechSynthesis.cancel();
    };
  }, []);

  const toggleTts = () => {
    if (ttsEnabled) {
      stopSpeaking();
      setTtsEnabled(false);
    } else {
      setTtsEnabled(true);
      if (currentStepText) speak(currentStepText);
    }
  };

  // ---- Wake Lock ----
  const toggleScreenAwake = async () => {
    if (screenAwake) {
      if (wakeLockRef.current) {
        try { await wakeLockRef.current.release(); } catch {}
        wakeLockRef.current = null;
      }
      setScreenAwake(false);
      toast.success("Screen lock released");
    } else {
      try {
        wakeLockRef.current = await navigator.wakeLock.request('screen');
        setScreenAwake(true);
        toast.success("Screen will stay awake");
        wakeLockRef.current.addEventListener('release', () => {
          setScreenAwake(false);
          wakeLockRef.current = null;
        });
      } catch {
        toast.error("Screen wake lock not supported on this device");
      }
    }
  };

  // Cleanup wake lock on unmount
  useEffect(() => {
    return () => {
      if (wakeLockRef.current) {
        try { wakeLockRef.current.release(); } catch {}
      }
    };
  }, []);

  // ---- Timer ----
  useEffect(() => {
    let interval;
    if (timerActive && (timerMinutes > 0 || timerSeconds > 0)) {
      interval = setInterval(() => {
        setTimerSeconds(prev => {
          if (prev > 0) return prev - 1;
          setTimerMinutes(m => {
            if (m > 0) return m - 1;
            setTimerActive(false);
            toast.success("Timer complete!");
            if (ttsEnabled) speak("Timer is done!");
            return 0;
          });
          return prev > 0 ? prev - 1 : 59;
        });
      }, 1000);
    }
    return () => clearInterval(interval);
  }, [timerActive, timerMinutes, timerSeconds, ttsEnabled, speak]);

  const handleTimerStart = () => {
    if (timerMinutes === 0 && timerSeconds === 0) {
      toast.error("Set a time first");
      return;
    }
    setTimerActive(!timerActive);
  };

  const handleSetTimer = (mins) => {
    setTimerMinutes(mins);
    setTimerSeconds(0);
    setTimerActive(false);
  };

  const toggleIngredient = (index) => {
    setCheckedIngredients(prev => ({ ...prev, [index]: !prev[index] }));
  };

  // ---- Step navigation ----
  const goToStep = (step) => {
    stopSpeaking();
    setCurrentStep(step);
  };

  const goNext = () => goToStep(Math.min(steps.length - 1, currentStep + 1));
  const goPrev = () => goToStep(Math.max(0, currentStep - 1));

  // Keyboard navigation
  useEffect(() => {
    const handleKey = (e) => {
      if (e.key === 'ArrowRight' || e.key === ' ') { e.preventDefault(); goNext(); }
      else if (e.key === 'ArrowLeft') { e.preventDefault(); goPrev(); }
      else if (e.key === 'v' || e.key === 'V') toggleTts();
    };
    window.addEventListener('keydown', handleKey);
    return () => window.removeEventListener('keydown', handleKey);
  });

  // ---- Loading / Access states ----
  if (loading) {
    return (
      <div className="w-screen h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <div className="w-12 h-12 rounded-full bg-primary/20 animate-pulse mx-auto mb-4" />
          <p className="text-muted-foreground">Loading recipe...</p>
        </div>
      </div>
    );
  }

  if (accessDenied) {
    return (
      <div className="w-screen h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <h2 className="font-serif text-2xl font-semibold mb-2">No access to this recipe</h2>
          <p className="text-muted-foreground mb-6">Join the family to cook this recipe</p>
          <Button onClick={() => navigate("/recipe/" + id)} className="rounded-full">Back to Recipe</Button>
        </div>
      </div>
    );
  }

  if (!recipe) return null;

  if (!canAccess("heritage")) {
    return (
      <div className="w-screen h-screen bg-background flex items-center justify-center p-4">
        <div className="text-center max-w-md">
          <Crown className="w-12 h-12 text-primary mx-auto mb-4" />
          <h2 className="font-serif text-2xl font-semibold mb-2">Cook Mode is a Heritage feature</h2>
          <p className="text-muted-foreground mb-6">Upgrade to Heritage Keeper to use the full-screen cooking interface</p>
          <Button onClick={() => navigate("/subscribe")} className="rounded-full bg-primary">Upgrade Now</Button>
        </div>
      </div>
    );
  }

  const progressPct = steps.length > 1 ? ((currentStep) / (steps.length - 1)) * 100 : 100;

  return (
    <div className="w-screen h-screen bg-amber-50 dark:bg-amber-950 flex flex-col overflow-hidden">
      {/* Progress Bar */}
      <div className="h-1.5 bg-amber-200 dark:bg-amber-900">
        <div
          className="h-full bg-amber-600 transition-all duration-300 ease-out"
          style={{ width: `${progressPct}%` }}
        />
      </div>

      {/* Top Bar */}
      <div className="bg-amber-100 dark:bg-amber-900 border-b border-amber-200 dark:border-amber-800 px-4 py-3 flex items-center justify-between gap-3">
        <div className="flex-1 min-w-0">
          <h1 className="font-serif text-lg md:text-xl font-bold text-foreground truncate">
            {recipe.title}
          </h1>
          <p className="text-xs text-muted-foreground">
            {recipe.cooking_time} min  •  {recipe.servings} servings  •  Step {currentStep + 1}/{steps.length}
          </p>
        </div>

        {/* Top bar controls */}
        <div className="flex items-center gap-2">
          {/* TTS toggle */}
          <button
            onClick={toggleTts}
            className={`p-2 rounded-lg transition-colors ${
              ttsEnabled
                ? 'bg-amber-600 text-white'
                : 'hover:bg-amber-200 dark:hover:bg-amber-800 text-foreground'
            }`}
            aria-label={ttsEnabled ? "Turn off voice" : "Read aloud"}
            title={ttsEnabled ? "Voice on (press V)" : "Read aloud (press V)"}
          >
            {ttsEnabled ? <Volume2 className="w-5 h-5" /> : <VolumeX className="w-5 h-5" />}
          </button>

          {/* Screen awake toggle */}
          <button
            onClick={toggleScreenAwake}
            className={`p-2 rounded-lg transition-colors ${
              screenAwake
                ? 'bg-green-600 text-white'
                : 'hover:bg-amber-200 dark:hover:bg-amber-800 text-foreground'
            }`}
            aria-label={screenAwake ? "Screen awake" : "Keep screen on"}
            title={screenAwake ? "Screen staying awake" : "Keep screen on"}
          >
            {screenAwake ? <Sun className="w-5 h-5" /> : <Moon className="w-5 h-5" />}
          </button>

          {/* Ingredients toggle (mobile) */}
          <button
            onClick={() => setShowIngredients(!showIngredients)}
            className="p-2 hover:bg-amber-200 dark:hover:bg-amber-800 rounded-lg transition-colors md:hidden text-foreground"
            aria-label="Toggle ingredients"
          >
            <ChefHat className="w-5 h-5" />
          </button>

          {/* Exit */}
          <button
            onClick={() => navigate(`/recipe/${id}`)}
            className="p-2 hover:bg-amber-200 dark:hover:bg-amber-800 rounded-lg transition-colors"
            aria-label="Exit cook mode"
          >
            <X className="w-5 h-5 text-foreground" />
          </button>
        </div>
      </div>

      {/* TTS speed control (shown when TTS is enabled) */}
      {ttsEnabled && (
        <div className="bg-amber-100/80 dark:bg-amber-900/80 border-b border-amber-200 dark:border-amber-800 px-4 py-2 flex items-center gap-3">
          <span className="text-xs font-medium text-amber-700 dark:text-amber-300">Speed:</span>
          {[0.7, 0.9, 1.0, 1.2].map(rate => (
            <button
              key={rate}
              onClick={() => setTtsRate(rate)}
              className={`px-2.5 py-1 rounded-full text-xs font-medium transition-colors ${
                ttsRate === rate
                  ? 'bg-amber-600 text-white'
                  : 'bg-amber-200/60 dark:bg-amber-800/60 text-amber-700 dark:text-amber-300'
              }`}
            >
              {rate === 0.7 ? 'Slow' : rate === 0.9 ? 'Normal' : rate === 1.0 ? 'Fast' : 'Faster'}
            </button>
          ))}
          {ttsSpeaking && (
            <span className="ml-auto text-xs text-amber-600 dark:text-amber-400 animate-pulse">Speaking...</span>
          )}
        </div>
      )}

      {/* Main Content */}
      <div className="flex-1 overflow-hidden flex flex-col md:flex-row">

        {/* Left: Step display */}
        <div className="flex-1 flex flex-col justify-center p-6 md:p-10 min-h-0">
          {/* Large Step Text */}
          <div className="bg-white dark:bg-slate-800 rounded-2xl p-8 md:p-12 shadow-lg border-2 border-amber-200 dark:border-amber-700 min-h-40 max-h-[50vh] overflow-y-auto flex items-center">
            <p className="font-serif text-2xl md:text-3xl lg:text-4xl font-semibold text-foreground leading-relaxed">
              {currentStepText}
            </p>
          </div>

          {/* Step Navigation */}
          <div className="flex gap-3 mt-6">
            <Button
              onClick={goPrev}
              disabled={currentStep === 0}
              variant="outline"
              className="flex-1 rounded-xl border-2 border-amber-200 dark:border-amber-700 h-14 text-base font-semibold gap-2"
            >
              <ChevronLeft className="w-5 h-5" />
              Previous
            </Button>
            {currentStep === steps.length - 1 ? (
              <Button
                onClick={() => { stopSpeaking(); navigate(`/recipe/${id}`); }}
                className="flex-1 rounded-xl bg-green-600 hover:bg-green-700 text-white h-14 text-base font-semibold"
              >
                Done Cooking!
              </Button>
            ) : (
              <Button
                onClick={goNext}
                className="flex-1 rounded-xl bg-amber-600 hover:bg-amber-700 text-white h-14 text-base font-semibold gap-2"
              >
                Next
                <ChevronRight className="w-5 h-5" />
              </Button>
            )}
          </div>

          {/* Step dots */}
          <div className="flex gap-1.5 justify-center mt-4 flex-wrap">
            {steps.map((_, i) => (
              <button
                key={i}
                onClick={() => goToStep(i)}
                className={`w-2.5 h-2.5 rounded-full transition-all ${
                  i === currentStep
                    ? 'bg-amber-600 scale-125'
                    : i < currentStep
                    ? 'bg-amber-400'
                    : 'bg-amber-200 dark:bg-amber-800'
                }`}
                aria-label={`Go to step ${i + 1}`}
              />
            ))}
          </div>
        </div>

        {/* Right Sidebar: Ingredients & Timer */}
        <div className={`w-full md:w-80 border-l border-amber-200 dark:border-amber-800 bg-amber-100/50 dark:bg-amber-900/30 overflow-y-auto p-4 space-y-4 ${
          showIngredients ? 'block' : 'hidden md:block'
        }`}>

          {/* Ingredients Checklist */}
          <div className="bg-white dark:bg-slate-800 rounded-2xl p-5 shadow border border-amber-200 dark:border-amber-700">
            <h2 className="font-serif text-base font-semibold mb-3 text-foreground flex items-center gap-2">
              <ChefHat className="w-4 h-4" />
              Ingredients
              <span className="ml-auto text-xs text-muted-foreground font-normal">
                {Object.values(checkedIngredients).filter(Boolean).length}/{recipe.ingredients.length}
              </span>
            </h2>
            <div className="space-y-2 max-h-48 overflow-y-auto">
              {recipe.ingredients.map((ingredient, index) => (
                <button
                  key={index}
                  onClick={() => toggleIngredient(index)}
                  className={`w-full text-left p-2.5 rounded-lg transition-all flex items-start gap-2.5 text-sm ${
                    checkedIngredients[index]
                      ? 'bg-green-100 dark:bg-green-900/50 line-through text-muted-foreground'
                      : 'bg-amber-50 dark:bg-amber-900/30 text-foreground hover:bg-amber-100 dark:hover:bg-amber-900/50'
                  }`}
                >
                  <Checkbox checked={checkedIngredients[index] || false} className="mt-0.5" readOnly />
                  <span>{ingredient}</span>
                </button>
              ))}
            </div>
          </div>

          {/* Timer */}
          <div className="bg-white dark:bg-slate-800 rounded-2xl p-5 shadow border border-amber-200 dark:border-amber-700">
            <h2 className="font-serif text-base font-semibold mb-3 text-foreground flex items-center gap-2">
              <Clock className="w-4 h-4" />
              Timer
            </h2>

            <div className={`text-4xl font-bold text-center mb-3 font-mono ${
              timerActive && timerMinutes === 0 && timerSeconds <= 10
                ? 'text-red-600 animate-pulse'
                : 'text-amber-700 dark:text-amber-300'
            }`}>
              {String(timerMinutes).padStart(2, '0')}:{String(timerSeconds).padStart(2, '0')}
            </div>

            <div className="grid grid-cols-4 gap-1.5 mb-3">
              {[1, 5, 10, 15].map(mins => (
                <Button
                  key={mins}
                  onClick={() => handleSetTimer(mins)}
                  variant="outline"
                  size="sm"
                  className="rounded-lg border-amber-200 dark:border-amber-700 text-xs h-8"
                  disabled={timerActive}
                >
                  {mins}m
                </Button>
              ))}
            </div>

            <div className="flex gap-2">
              <Button
                onClick={handleTimerStart}
                className={`flex-1 rounded-lg h-9 text-sm font-semibold ${
                  timerActive
                    ? 'bg-amber-600 hover:bg-amber-700 text-white'
                    : 'bg-amber-200 dark:bg-amber-700 text-foreground hover:bg-amber-300 dark:hover:bg-amber-600'
                }`}
              >
                {timerActive ? 'Pause' : 'Start'}
              </Button>
              <Button
                onClick={() => { setTimerMinutes(0); setTimerSeconds(0); setTimerActive(false); }}
                variant="outline"
                className="rounded-lg h-9 text-sm border-amber-200 dark:border-amber-700"
              >
                Reset
              </Button>
            </div>
          </div>

          {/* Keyboard shortcuts hint */}
          <div className="text-xs text-center text-muted-foreground space-y-0.5 pt-2">
            <p>Arrow keys or space to navigate</p>
            <p>Press V to toggle voice</p>
          </div>
        </div>
      </div>
    </div>
  );
};

// Family page: Create / Join when no family; Family Settings when in a family
const FamilyPage = () => {
  const { user, token, updateUser } = useAuth();
  const navigate = useNavigate();
  const [family, setFamily] = useState(null);
  const [members, setMembers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [createName, setCreateName] = useState("");
  const [createDescription, setCreateDescription] = useState("");
  const [createSubmitting, setCreateSubmitting] = useState(false);
  const [joinCode, setJoinCode] = useState("");
  const [joinSubmitting, setJoinSubmitting] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [editName, setEditName] = useState("");
  const [editDescription, setEditDescription] = useState("");
  const [editSubmitting, setEditSubmitting] = useState(false);
  const [actionLoading, setActionLoading] = useState(null); // 'leave' | 'delete' | 'remove-{id}' | 'transfer-{id}'
  const [seedingDemo, setSeedingDemo] = useState(false);

  const refreshUser = async () => {
    try {
      const res = await axios.get(`${API}/auth/me`, { headers: { Authorization: `Bearer ${token}` } });
      updateUser(res.data);
    } catch {
      toast.error("Failed to refresh profile");
    }
  };

  const fetchFamilyData = useCallback(async () => {
    if (!user?.family_id || !token) return;
    setLoading(true);
    try {
      const [fam, mems] = await Promise.all([
        familiesApi.getFamily(token, user.family_id),
        familiesApi.getFamilyMembers(token, user.family_id),
      ]);
      setFamily(fam);
      setMembers(mems);
      setEditName(fam.name || "");
      setEditDescription(fam.description || "");
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Failed to load family";
      toast.error(msg);
      setFamily(null);
      setMembers([]);
    } finally {
      setLoading(false);
    }
  }, [user?.family_id, token]);

  useEffect(() => {
    if (!user?.family_id) {
      setLoading(false);
      return;
    }
    fetchFamilyData();
  }, [user?.family_id, fetchFamilyData]);

  const handleCreateFamily = async (e) => {
    e.preventDefault();
    if (!createName.trim()) {
      toast.error("Please enter a family name");
      return;
    }
    setCreateSubmitting(true);
    try {
      await familiesApi.createFamily(token, { name: createName.trim(), description: createDescription.trim() || null });
      toast.success("Family created! You're the Keeper.");
      await refreshUser();
      setCreateName("");
      setCreateDescription("");
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Failed to create family";
      toast.error(msg);
    } finally {
      setCreateSubmitting(false);
    }
  };

  const handleJoinFamily = async (e) => {
    e.preventDefault();
    if (!joinCode.trim()) {
      toast.error("Please enter an invite code");
      return;
    }
    setJoinSubmitting(true);
    try {
      await familiesApi.joinFamily(token, { invite_code: joinCode.trim() });
      toast.success("You joined the family!");
      await refreshUser();
      setJoinCode("");
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Invalid or expired invite code";
      toast.error(msg);
    } finally {
      setJoinSubmitting(false);
    }
  };

  const handleCopyInviteCode = () => {
    if (!family?.invite_code) return;
    navigator.clipboard.writeText(family.invite_code);
    toast.success("Invite code copied to clipboard");
  };

  const handleLeaveFamily = async () => {
    if (!user?.family_id || !window.confirm("Are you sure you want to leave this family? You'll lose access to family recipes until you join again.")) return;
    setActionLoading("leave");
    try {
      await familiesApi.leaveFamily(token, user.family_id);
      toast.success("You left the family.");
      await refreshUser();
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Could not leave family";
      toast.error(msg);
    } finally {
      setActionLoading(null);
    }
  };

  const handleDeleteFamily = async () => {
    if (!user?.family_id || !window.confirm("Permanently delete this family? All members will be removed and family recipes will become legacy. This cannot be undone.")) return;
    setActionLoading("delete");
    try {
      await familiesApi.deleteFamily(token, user.family_id);
      toast.success("Family deleted.");
      await refreshUser();
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Could not delete family";
      toast.error(msg);
    } finally {
      setActionLoading(null);
    }
  };

  const handleRemoveMember = async (memberId) => {
    if (!user?.family_id || !window.confirm("Remove this member from the family? They will lose access to family recipes.")) return;
    setActionLoading(`remove-${memberId}`);
    try {
      await familiesApi.removeMember(token, user.family_id, memberId);
      toast.success("Member removed.");
      await fetchFamilyData();
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Could not remove member";
      toast.error(msg);
    } finally {
      setActionLoading(null);
    }
  };

  const handleTransferKeeper = async (newKeeperId) => {
    if (!user?.family_id || !window.confirm("Transfer the Keeper role to this member? You will become a Member and they will manage the family.")) return;
    setActionLoading(`transfer-${newKeeperId}`);
    try {
      await familiesApi.transferKeeper(token, user.family_id, { new_keeper_id: newKeeperId });
      toast.success("Keeper role transferred.");
      await refreshUser();
      await fetchFamilyData();
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Could not transfer role";
      toast.error(msg);
    } finally {
      setActionLoading(null);
    }
  };

  const handleSaveEdit = async (e) => {
    e.preventDefault();
    if (!user?.family_id) return;
    setEditSubmitting(true);
    try {
      await familiesApi.updateFamily(token, user.family_id, { name: editName.trim(), description: editDescription.trim() || null });
      toast.success("Family updated.");
      setEditMode(false);
      await fetchFamilyData();
    } catch (err) {
      const msg = err.response?.data?.message || err.message || "Failed to update family";
      toast.error(msg);
    } finally {
      setEditSubmitting(false);
    }
  };

  const handleSeedSampleFamily = async () => {
    setSeedingDemo(true);
    try {
      await axios.post(`${API}/onboarding/seed-sample-family`, {}, {
        headers: { Authorization: `Bearer ${token}` },
      });
      toast.success("Welcome! Sample recipes have been added.");
      await refreshUser();
      navigate("/home");
    } catch (err) {
      const msg = err.response?.data?.detail || "Could not create sample family";
      toast.error(msg);
    } finally {
      setSeedingDemo(false);
    }
  };

  const isKeeper = user?.role === "keeper";
  const getMemberDisplayName = (m) => m.nickname || m.name || m.email || "Member";

  if (!user?.family_id) {
    return (
      <div className="min-h-screen bg-background" data-testid="family-page">
        <Navigation />
        <div className="max-w-2xl mx-auto px-4 sm:px-6 py-8">
          <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Family</h1>
          <p className="text-muted-foreground mb-8">Create or join a family to share recipes.</p>

          <div className="space-y-6">
            {/* Quick Start with sample recipes */}
            <Card className="rounded-2xl border-amber-300 dark:border-amber-700 bg-gradient-to-br from-amber-50 to-orange-50 dark:from-amber-950/30 dark:to-orange-950/30">
              <CardContent className="p-8">
                <div className="flex items-center gap-3 mb-4">
                  <div className="w-12 h-12 rounded-full bg-amber-100 dark:bg-amber-900/50 flex items-center justify-center">
                    <Sparkles className="w-6 h-6 text-amber-600" />
                  </div>
                  <div>
                    <h2 className="font-serif text-xl font-semibold">Quick Start</h2>
                    <p className="text-sm text-muted-foreground">See what Legacy Table can do</p>
                  </div>
                </div>
                <p className="text-sm text-muted-foreground mb-4">
                  We'll create your family and add a few sample recipes so you can explore
                  the app right away. You can always delete or replace them later.
                </p>
                <Button
                  onClick={handleSeedSampleFamily}
                  disabled={seedingDemo}
                  className="rounded-full bg-amber-600 hover:bg-amber-700 text-white"
                >
                  {seedingDemo ? "Setting up…" : "Start with sample recipes"}
                </Button>
              </CardContent>
            </Card>

            <div className="relative flex items-center justify-center my-2">
              <div className="absolute inset-0 flex items-center"><div className="w-full border-t border-border/50" /></div>
              <span className="relative bg-background px-4 text-sm text-muted-foreground">or set up manually</span>
            </div>

            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-8">
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center">
                    <UserPlus className="w-6 h-6 text-primary" />
                  </div>
                  <h2 className="font-serif text-xl font-semibold">Create a family</h2>
                </div>
                <form onSubmit={handleCreateFamily} className="space-y-4">
                  <div>
                    <Label htmlFor="create-name">Family name</Label>
                    <Input
                      id="create-name"
                      placeholder="e.g. Smith Family"
                      value={createName}
                      onChange={(e) => setCreateName(e.target.value)}
                      className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 mt-1"
                      data-testid="create-family-name"
                    />
                  </div>
                  <div>
                    <Label htmlFor="create-desc">Description (optional)</Label>
                    <Textarea
                      id="create-desc"
                      placeholder="Our family recipe collection"
                      value={createDescription}
                      onChange={(e) => setCreateDescription(e.target.value)}
                      className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 mt-1 min-h-[80px]"
                      data-testid="create-family-description"
                    />
                  </div>
                  <Button type="submit" className="rounded-full" disabled={createSubmitting} data-testid="create-family-btn">
                    {createSubmitting ? "Creating…" : "Create family"}
                  </Button>
                </form>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-8">
                <div className="flex items-center gap-3 mb-6">
                  <div className="w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center">
                    <Users className="w-6 h-6 text-primary" />
                  </div>
                  <h2 className="font-serif text-xl font-semibold">Join with invite code</h2>
                </div>
                <form onSubmit={handleJoinFamily} className="space-y-4">
                  <div>
                    <Label htmlFor="join-code">Invite code</Label>
                    <Input
                      id="join-code"
                      placeholder="Enter code from your family Keeper"
                      value={joinCode}
                      onChange={(e) => setJoinCode(e.target.value)}
                      className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 mt-1 font-mono"
                      data-testid="join-family-code"
                    />
                  </div>
                  <Button type="submit" variant="outline" className="rounded-full border-2 border-primary text-primary" disabled={joinSubmitting} data-testid="join-family-btn">
                    {joinSubmitting ? "Joining…" : "Join family"}
                  </Button>
                </form>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background" data-testid="family-page">
      <Navigation />
      <div className="max-w-2xl mx-auto px-4 sm:px-6 py-8">
        <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Family settings</h1>
        <p className="text-muted-foreground mb-8">Manage your family and invite code.</p>

        {loading ? (
          <div className="flex justify-center py-12">
            <div className="animate-spin rounded-full h-12 w-12 border-4 border-primary border-t-transparent" />
          </div>
        ) : family ? (
          <div className="space-y-6">
            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-6">
                {editMode ? (
                  <form onSubmit={handleSaveEdit} className="space-y-4">
                    <Label>Family name</Label>
                    <Input
                      value={editName}
                      onChange={(e) => setEditName(e.target.value)}
                      className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30"
                      data-testid="edit-family-name"
                    />
                    <Label>Description (optional)</Label>
                    <Textarea
                      value={editDescription}
                      onChange={(e) => setEditDescription(e.target.value)}
                      className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 min-h-[80px]"
                      data-testid="edit-family-description"
                    />
                    <div className="flex gap-2">
                      <Button type="submit" disabled={editSubmitting} data-testid="save-family-edit">
                        {editSubmitting ? "Saving…" : "Save"}
                      </Button>
                      <Button type="button" variant="outline" onClick={() => { setEditMode(false); setEditName(family.name); setEditDescription(family.description || ""); }}>
                        Cancel
                      </Button>
                    </div>
                  </form>
                ) : (
                  <>
                    <div className="flex items-center justify-between flex-wrap gap-2">
                      <h2 className="font-serif text-xl font-semibold">{family.name}</h2>
                      {isKeeper && (
                        <Button variant="outline" size="sm" onClick={() => setEditMode(true)} className="rounded-full" data-testid="edit-family-btn">
                          <Edit className="w-4 h-4 mr-1" /> Edit
                        </Button>
                      )}
                    </div>
                    {family.description && <p className="text-muted-foreground text-sm mt-1">{family.description}</p>}
                  </>
                )}
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-6">
                <h3 className="font-semibold mb-2">Invite code</h3>
                <div className="flex items-center gap-2 flex-wrap">
                  <code className="px-3 py-2 rounded-lg bg-muted font-mono text-sm">{family.invite_code}</code>
                  <Button variant="outline" size="sm" onClick={handleCopyInviteCode} className="rounded-full" data-testid="copy-invite-code">
                    <Copy className="w-4 h-4 mr-1" /> Copy
                  </Button>
                </div>
                <p className="text-xs text-muted-foreground mt-2">Share this code so others can join your family.</p>
              </CardContent>
            </Card>

            <Card className="rounded-2xl border-border/50">
              <CardContent className="p-6">
                <h3 className="font-semibold mb-4">Members</h3>
                <ul className="space-y-3">
                  {members.map((m) => (
                    <li key={m.id} className="flex items-center justify-between gap-2 flex-wrap py-2 border-b border-border/50 last:border-0">
                      <div className="flex items-center gap-2">
                        {m.avatar ? (
                          <img src={m.avatar} alt="" className="w-8 h-8 rounded-full object-cover" />
                        ) : (
                          <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center text-sm font-medium text-primary">
                            {getMemberDisplayName(m).charAt(0).toUpperCase()}
                          </div>
                        )}
                        <span className="font-medium">{getMemberDisplayName(m)}</span>
                        {m.role === "keeper" && <Crown className="w-4 h-4 text-primary" title="Keeper" />}
                        <Badge variant="secondary" className="capitalize text-xs">{m.role}</Badge>
                      </div>
                      {isKeeper && m.id !== user.id && (
                        <div className="flex items-center gap-1">
                          {m.role === "member" && (
                            <Button
                              variant="outline"
                              size="sm"
                              className="rounded-full text-xs"
                              disabled={!!actionLoading}
                              onClick={() => handleTransferKeeper(m.id)}
                              data-testid={`transfer-keeper-${m.id}`}
                            >
                              {actionLoading === `transfer-${m.id}` ? "…" : "Make Keeper"}
                            </Button>
                          )}
                          <Button
                            variant="ghost"
                            size="sm"
                            className="text-destructive hover:text-destructive rounded-full text-xs"
                            disabled={!!actionLoading}
                            onClick={() => handleRemoveMember(m.id)}
                            data-testid={`remove-member-${m.id}`}
                          >
                            {actionLoading === `remove-${m.id}` ? "…" : "Remove"}
                          </Button>
                        </div>
                      )}
                    </li>
                  ))}
                </ul>
              </CardContent>
            </Card>

            <div className="flex flex-col sm:flex-row gap-3">
              <Button
                variant="outline"
                className="rounded-full border-destructive text-destructive hover:bg-destructive/10"
                disabled={!!actionLoading}
                onClick={handleLeaveFamily}
                data-testid="leave-family-btn"
              >
                {actionLoading === "leave" ? "Leaving…" : "Leave family"}
              </Button>
              {isKeeper && (
                <Button
                  variant="outline"
                  className="rounded-full border-destructive text-destructive hover:bg-destructive/10"
                  disabled={!!actionLoading}
                  onClick={handleDeleteFamily}
                  data-testid="delete-family-btn"
                >
                  {actionLoading === "delete" ? "Deleting…" : "Delete family"}
                </Button>
              )}
            </div>
          </div>
        ) : (
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-8 text-center text-muted-foreground">
              Could not load family. You may have left or been removed.
            </CardContent>
          </Card>
        )}
      </div>
    </div>
  );
};

// Settings Page (Profile Management)
const SettingsPage = () => {
  const { user, token, updateUser, getDisplayName } = useAuth();
  const [nickname, setNickname] = useState(user?.nickname || "");
  const [avatar, setAvatar] = useState(user?.avatar || "");
  const [saving, setSaving] = useState(false);
  const [badges, setBadges] = useState([]);
  const [badgesLoading, setBadgesLoading] = useState(true);
  const [exporting, setExporting] = useState(false);
  const navigate = useNavigate();

  // Fetch badges
  useEffect(() => {
    const fetchBadges = async () => {
      try {
        const res = await axios.get(`${API}/badges`, {
          headers: { Authorization: `Bearer ${token}` },
        });
        setBadges(res.data.badges || []);
      } catch { setBadges([]); }
      setBadgesLoading(false);
    };
    if (token) fetchBadges();
  }, [token]);

  // Export recipes as JSON backup
  const handleExportRecipes = async () => {
    setExporting(true);
    try {
      const res = await axios.get(`${API}/export/recipes`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      const blob = new Blob([JSON.stringify(res.data, null, 2)], { type: 'application/json' });
      const url = URL.createObjectURL(blob);
      const link = document.createElement('a');
      link.href = url;
      const familyName = res.data.family?.name?.replace(/\s+/g, '_') || 'recipes';
      link.download = `legacy_table_${familyName}_backup_${new Date().toISOString().slice(0,10)}.json`;
      link.click();
      URL.revokeObjectURL(url);
      toast.success(`Exported ${res.data.recipe_count} recipes!`);
    } catch (err) {
      const msg = err.response?.data?.detail || "Failed to export recipes";
      toast.error(msg);
    }
    setExporting(false);
  };

  // Badge icon mapping
  const badgeIcons = {
    'flame': Flame,
    'chef-hat': ChefHat,
    'book-open': BookOpen,
    'crown': Crown,
    'users': Users,
  };

  const handleAvatarUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (event) => {
        setAvatar(event.target.result);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      const response = await axios.put(`${API}/auth/profile`, {
        nickname: nickname.trim() || null,
        avatar: avatar || null
      }, {
        headers: { Authorization: `Bearer ${token}` },
      });
      updateUser(response.data);
      toast.success("Profile updated successfully!");
    } catch (error) {
      toast.error("Failed to update profile");
    }
    setSaving(false);
  };

  return (
    <div className="min-h-screen bg-background" data-testid="settings-page">
      <Navigation />
      
      <div className="max-w-2xl mx-auto px-4 sm:px-6 py-8">
        <div className="mb-8 animate-fade-in">
          <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Profile Settings</h1>
          <p className="text-muted-foreground">Customize how you appear to the family</p>
        </div>

        <div className="space-y-8 animate-slide-up">
          {/* Avatar Section */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4">Profile Picture</h3>
              <div className="flex items-center gap-6">
                <div className="relative">
                  {avatar ? (
                    <img 
                      src={avatar} 
                      alt="Profile" 
                      className="w-24 h-24 rounded-full object-cover border-4 border-border"
                      data-testid="avatar-preview"
                    />
                  ) : (
                    <div className="w-24 h-24 rounded-full bg-primary/10 flex items-center justify-center border-4 border-border">
                      <span className="text-3xl font-bold text-primary">{getDisplayName().charAt(0).toUpperCase()}</span>
                    </div>
                  )}
                  <label className="absolute bottom-0 right-0 w-8 h-8 bg-primary text-primary-foreground rounded-full flex items-center justify-center cursor-pointer hover:bg-primary/90 transition-colors">
                    <Upload className="w-4 h-4" />
                    <input 
                      type="file" 
                      accept="image/*" 
                      className="hidden" 
                      onChange={handleAvatarUpload}
                      data-testid="avatar-input"
                    />
                  </label>
                </div>
                <div className="flex-1">
                  <p className="text-sm text-muted-foreground mb-2">Upload a photo to personalize your profile</p>
                  {avatar && (
                    <Button 
                      variant="outline" 
                      size="sm" 
                      onClick={() => setAvatar("")}
                      className="rounded-full"
                      data-testid="remove-avatar-btn"
                    >
                      Remove photo
                    </Button>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Nickname Section */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4">Display Name</h3>
              <div className="space-y-4">
                <div>
                  <Label className="text-sm text-muted-foreground">Full Name</Label>
                  <p className="text-foreground font-medium">{user?.name}</p>
                </div>
                <div className="space-y-2">
                  <Label htmlFor="nickname" className="text-sm text-muted-foreground">Nickname (optional)</Label>
                  <Input
                    id="nickname"
                    placeholder="Enter a nickname..."
                    value={nickname}
                    onChange={(e) => setNickname(e.target.value)}
                    className="rounded-xl border-2 border-border/50 bg-background/50 dark:bg-muted/30 max-w-sm"
                    data-testid="nickname-input"
                  />
                  <p className="text-xs text-muted-foreground">
                    Your nickname will be shown instead of your full name on recipes and comments.
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Family & Role */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4">Family & Role</h3>
              <div className="space-y-3">
                {user?.role && (
                  <div>
                    <Label className="text-sm text-muted-foreground">Role</Label>
                    <p className="text-foreground">
                      <span className="inline-flex items-center px-2 py-0.5 rounded-full text-sm font-medium bg-primary/10 text-primary capitalize">
                        {user.role}
                      </span>
                    </p>
                  </div>
                )}
                <div>
                  <Label className="text-sm text-muted-foreground">Family</Label>
                  {user?.family_id ? (
                    <p className="text-foreground flex items-center gap-2 flex-wrap">
                      <span>You're in a family.</span>
                      <Button variant="link" className="p-0 h-auto text-primary font-medium" onClick={() => navigate("/family")} data-testid="settings-family-link">
                        Family settings →
                      </Button>
                    </p>
                  ) : (
                    <p className="text-foreground flex items-center gap-2 flex-wrap">
                      <span>You're not in a family.</span>
                      <Button variant="link" className="p-0 h-auto text-primary font-medium" onClick={() => navigate("/family")} data-testid="settings-join-family-link">
                        Create or join a family →
                      </Button>
                    </p>
                  )}
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Subscription */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4">Subscription</h3>
              <div className="space-y-3">
                <div>
                  <Label className="text-sm text-muted-foreground">Current Plan</Label>
                  <p className="text-foreground font-medium capitalize">Free Plan</p>
                </div>
                <div className="flex flex-wrap gap-3">
                  <Button
                    variant="default"
                    size="sm"
                    className="rounded-full bg-primary text-primary-foreground"
                    onClick={() => navigate("/subscribe")}
                    data-testid="settings-upgrade-btn"
                  >
                    <Crown className="w-4 h-4 mr-2" />
                    Upgrade Plan
                  </Button>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Account Info */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4">Account Information</h3>
              <div className="space-y-3">
                <div>
                  <Label className="text-sm text-muted-foreground">Email</Label>
                  <p className="text-foreground">{user?.email}</p>
                </div>
                <div>
                  <Label className="text-sm text-muted-foreground">Member Since</Label>
                  <p className="text-foreground">
                    {new Date(user?.created_at).toLocaleDateString('en-US', { 
                      year: 'numeric', 
                      month: 'long', 
                      day: 'numeric' 
                    })}
                  </p>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Badges */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4 flex items-center gap-2">
                <Flame className="w-5 h-5 text-amber-500" />
                Badges
              </h3>
              {badgesLoading ? (
                <p className="text-sm text-muted-foreground">Loading badges...</p>
              ) : badges.length === 0 ? (
                <p className="text-sm text-muted-foreground">Keep adding recipes to earn badges!</p>
              ) : (
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                  {badges.map(badge => {
                    const IconComponent = badgeIcons[badge.icon] || Flame;
                    return (
                      <div
                        key={badge.id}
                        className="flex flex-col items-center text-center p-4 rounded-xl border border-border/50 bg-muted/30"
                      >
                        <div
                          className="w-12 h-12 rounded-full flex items-center justify-center mb-2"
                          style={{ backgroundColor: badge.color + '20' }}
                        >
                          <IconComponent className="w-6 h-6" style={{ color: badge.color }} />
                        </div>
                        <p className="text-sm font-semibold text-foreground">{badge.name}</p>
                        <p className="text-xs text-muted-foreground mt-0.5">{badge.description}</p>
                      </div>
                    );
                  })}
                </div>
              )}
            </CardContent>
          </Card>

          {/* Backup & Export */}
          <Card className="rounded-2xl border-border/50">
            <CardContent className="p-6">
              <h3 className="font-semibold text-lg mb-4 flex items-center gap-2">
                <Download className="w-5 h-5 text-primary" />
                Backup & Export
              </h3>
              <p className="text-sm text-muted-foreground mb-4">
                Download all your family's recipes as a JSON file. This backup includes every recipe's ingredients, instructions, and stories.
              </p>
              <Button
                onClick={handleExportRecipes}
                disabled={exporting || !user?.family_id}
                variant="outline"
                className="rounded-full"
              >
                <Download className="w-4 h-4 mr-2" />
                {exporting ? "Exporting..." : "Download Recipe Backup"}
              </Button>
              {!user?.family_id && (
                <p className="text-xs text-muted-foreground mt-2">Join a family first to export recipes.</p>
              )}
            </CardContent>
          </Card>

          {/* Save Button */}
          <div className="flex gap-4">
            <Button
              variant="outline"
              onClick={() => navigate(-1)}
              className="rounded-full px-6"
              data-testid="settings-cancel-btn"
            >
              Cancel
            </Button>
            <Button
              onClick={handleSave}
              disabled={saving}
              className="rounded-full bg-primary text-primary-foreground px-8"
              data-testid="settings-save-btn"
            >
              {saving ? "Saving..." : "Save Changes"}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

// Profile Page (My Recipes)
const ProfilePage = () => {
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  const { token, user } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    fetchMyRecipes();
  }, []);

  const fetchMyRecipes = async () => {
    try {
      const response = await axios.get(`${API}/recipes?author_id=${user.id}`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setRecipes(response.data);
    } catch (error) {
      toast.error("Failed to load your recipes");
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-background" data-testid="profile-page">
      <Navigation />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8 animate-fade-in">
          <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">My Recipes</h1>
          <p className="text-muted-foreground">Recipes you've shared with the family</p>
        </div>

        {loading ? (
          <div className="recipe-grid">
            {[...Array(3)].map((_, i) => (
              <div key={i} className="rounded-2xl overflow-hidden">
                <div className="skeleton aspect-[4/5]" />
                <div className="p-5 space-y-3">
                  <div className="skeleton h-6 w-3/4" />
                  <div className="skeleton h-4 w-1/2" />
                </div>
              </div>
            ))}
          </div>
        ) : recipes.length > 0 ? (
          <div className="recipe-grid" data-testid="my-recipes-grid">
            {recipes.map((recipe, index) => (
              <div key={recipe.id} className="animate-fade-in" style={{ animationDelay: `${index * 0.1}s` }}>
                <RecipeCard 
                  recipe={recipe} 
                  onClick={() => navigate(`/recipe/${recipe.id}`)}
                />
              </div>
            ))}
          </div>
        ) : (
          <div className="empty-state" data-testid="empty-my-recipes">
            <div className="empty-state-icon">
              <ChefHat className="w-10 h-10" />
            </div>
            <h3 className="font-serif text-2xl font-semibold mb-2">No recipes yet</h3>
            <p className="text-muted-foreground mb-6">Share your first recipe with the family!</p>
            <Button 
              onClick={() => navigate("/add-recipe")}
              className="rounded-full bg-primary text-primary-foreground"
              data-testid="profile-add-recipe-btn"
            >
              <Plus className="w-4 h-4 mr-2" />
              Add Recipe
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

// Family Cookbook Page with PDF Export
const CookbookPage = () => {
  const [recipes, setRecipes] = useState([]);
  const [selectedRecipes, setSelectedRecipes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [generating, setGenerating] = useState(false);
  const { token } = useAuth();
  const navigate = useNavigate();

  useEffect(() => {
    fetchAllRecipes();
  }, []);

  const fetchAllRecipes = async () => {
    try {
      const response = await axios.get(`${API}/recipes`, {
        headers: { Authorization: `Bearer ${token}` },
      });
      setRecipes(response.data);
    } catch (error) {
      toast.error("Failed to load recipes");
    }
    setLoading(false);
  };

  const toggleRecipeSelection = (recipeId) => {
    setSelectedRecipes(prev => 
      prev.includes(recipeId) 
        ? prev.filter(id => id !== recipeId)
        : [...prev, recipeId]
    );
  };

  const selectAll = () => {
    if (selectedRecipes.length === recipes.length) {
      setSelectedRecipes([]);
    } else {
      setSelectedRecipes(recipes.map(r => r.id));
    }
  };

  const generatePDF = async () => {
    if (selectedRecipes.length === 0) {
      toast.error("Please select at least one recipe");
      return;
    }

    setGenerating(true);
    toast.info("Generating your cookbook...");

    try {
      const doc = new jsPDF();
      const pageWidth = doc.internal.pageSize.getWidth();
      const pageHeight = doc.internal.pageSize.getHeight();
      const margin = 20;
      const contentWidth = pageWidth - (margin * 2);

      // Cover Page
      doc.setFillColor(248, 245, 241); // Linen background
      doc.rect(0, 0, pageWidth, pageHeight, 'F');
      
      // Decorative border
      doc.setDrawColor(218, 127, 96); // Terracotta
      doc.setLineWidth(2);
      doc.rect(10, 10, pageWidth - 20, pageHeight - 20);
      doc.setLineWidth(0.5);
      doc.rect(15, 15, pageWidth - 30, pageHeight - 30);

      // Title
      doc.setFont("helvetica", "bold");
      doc.setFontSize(36);
      doc.setTextColor(74, 58, 51); // Warm charcoal
      doc.text("Legacy Table", pageWidth / 2, 80, { align: "center" });
      doc.setFontSize(28);
      doc.text("Family Cookbook", pageWidth / 2, 100, { align: "center" });
      
      // Decorative line
      doc.setDrawColor(74, 122, 94); // Sage
      doc.setLineWidth(1);
      doc.line(60, 115, pageWidth - 60, 115);
      
      // Subtitle
      doc.setFont("helvetica", "italic");
      doc.setFontSize(14);
      doc.setTextColor(128, 118, 110);
      doc.text("Recipes passed down with love", pageWidth / 2, 135, { align: "center" });
      
      // Recipe count
      doc.setFont("helvetica", "normal");
      doc.setFontSize(12);
      doc.text(`${selectedRecipes.length} cherished recipes`, pageWidth / 2, 155, { align: "center" });
      
      // Date
      const today = new Date().toLocaleDateString('en-US', { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric' 
      });
      doc.text(`Created on ${today}`, pageWidth / 2, 175, { align: "center" });
      
      // Footer quote
      doc.setFont("helvetica", "italic");
      doc.setFontSize(11);
      doc.setTextColor(128, 118, 110);
      doc.text('"The fondest memories are made when gathered around the table."', pageWidth / 2, pageHeight - 40, { align: "center" });

      // Table of Contents
      doc.addPage();
      doc.setFillColor(248, 245, 241);
      doc.rect(0, 0, pageWidth, pageHeight, 'F');
      
      doc.setFont("helvetica", "bold");
      doc.setFontSize(24);
      doc.setTextColor(74, 58, 51);
      doc.text("Table of Contents", pageWidth / 2, 30, { align: "center" });
      
      doc.setDrawColor(218, 127, 96);
      doc.setLineWidth(0.5);
      doc.line(margin, 40, pageWidth - margin, 40);

      let tocY = 55;
      const selectedRecipesList = recipes.filter(r => selectedRecipes.includes(r.id));
      
      doc.setFont("helvetica", "normal");
      doc.setFontSize(12);
      selectedRecipesList.forEach((recipe, index) => {
        if (tocY > pageHeight - 30) {
          doc.addPage();
          doc.setFillColor(248, 245, 241);
          doc.rect(0, 0, pageWidth, pageHeight, 'F');
          tocY = 30;
        }
        doc.setTextColor(74, 58, 51);
        doc.text(`${index + 1}. ${recipe.title}`, margin, tocY);
        doc.setTextColor(128, 118, 110);
        doc.text(`by ${recipe.author_name}`, margin + 10, tocY + 5);
        tocY += 18;
      });

      // Recipe Pages
      for (const recipe of selectedRecipesList) {
        doc.addPage();
        doc.setFillColor(248, 245, 241);
        doc.rect(0, 0, pageWidth, pageHeight, 'F');
        
        let y = 25;

        // Recipe title
        doc.setFont("helvetica", "bold");
        doc.setFontSize(22);
        doc.setTextColor(74, 58, 51);
        const titleLines = doc.splitTextToSize(recipe.title, contentWidth);
        doc.text(titleLines, margin, y);
        y += titleLines.length * 10 + 5;

        // Category badge
        doc.setFillColor(74, 122, 94);
        doc.roundedRect(margin, y, 40, 8, 2, 2, 'F');
        doc.setFont("helvetica", "bold");
        doc.setFontSize(8);
        doc.setTextColor(255, 255, 255);
        doc.text(recipe.category.toUpperCase(), margin + 4, y + 5.5);
        
        // Difficulty
        const diffColors = {
          easy: [74, 122, 94],
          medium: [218, 175, 96],
          hard: [218, 127, 96]
        };
        const dc = diffColors[recipe.difficulty] || diffColors.easy;
        doc.setFillColor(dc[0], dc[1], dc[2]);
        doc.roundedRect(margin + 45, y, 25, 8, 2, 2, 'F');
        doc.text(recipe.difficulty.toUpperCase(), margin + 49, y + 5.5);
        y += 15;

        // Meta info
        doc.setFont("helvetica", "normal");
        doc.setFontSize(10);
        doc.setTextColor(128, 118, 110);
        doc.text(`By ${recipe.author_name}  •  ${recipe.cooking_time} min  •  ${recipe.servings} servings`, margin, y);
        y += 15;

        // Decorative line
        doc.setDrawColor(218, 127, 96);
        doc.setLineWidth(0.3);
        doc.line(margin, y, pageWidth - margin, y);
        y += 10;

        // Ingredients section
        doc.setFont("helvetica", "bold");
        doc.setFontSize(14);
        doc.setTextColor(74, 58, 51);
        doc.text("Ingredients", margin, y);
        y += 8;

        doc.setFont("helvetica", "normal");
        doc.setFontSize(10);
        doc.setTextColor(74, 58, 51);
        
        for (const ingredient of recipe.ingredients) {
          if (y > pageHeight - 30) {
            doc.addPage();
            doc.setFillColor(248, 245, 241);
            doc.rect(0, 0, pageWidth, pageHeight, 'F');
            y = 25;
          }
          doc.setFillColor(218, 127, 96);
          doc.circle(margin + 2, y - 1.5, 1.5, 'F');
          const ingredientLines = doc.splitTextToSize(ingredient, contentWidth - 10);
          doc.text(ingredientLines, margin + 8, y);
          y += ingredientLines.length * 5 + 3;
        }
        y += 8;

        // Instructions section
        if (y > pageHeight - 60) {
          doc.addPage();
          doc.setFillColor(248, 245, 241);
          doc.rect(0, 0, pageWidth, pageHeight, 'F');
          y = 25;
        }

        doc.setFont("helvetica", "bold");
        doc.setFontSize(14);
        doc.setTextColor(74, 58, 51);
        doc.text("Instructions", margin, y);
        y += 8;

        doc.setFont("helvetica", "normal");
        doc.setFontSize(10);
        
        const instructionLines = doc.splitTextToSize(recipe.instructions, contentWidth);
        for (const line of instructionLines) {
          if (y > pageHeight - 20) {
            doc.addPage();
            doc.setFillColor(248, 245, 241);
            doc.rect(0, 0, pageWidth, pageHeight, 'F');
            y = 25;
          }
          doc.text(line, margin, y);
          y += 5;
        }

        // Recipe Story (if exists)
        if (recipe.story) {
          y += 10;
          if (y > pageHeight - 60) {
            doc.addPage();
            doc.setFillColor(248, 245, 241);
            doc.rect(0, 0, pageWidth, pageHeight, 'F');
            y = 25;
          }

          doc.setFont("helvetica", "bolditalic");
          doc.setFontSize(12);
          doc.setTextColor(218, 127, 96); // Terracotta
          doc.text("The Story", margin, y);
          y += 8;

          doc.setFont("helvetica", "italic");
          doc.setFontSize(10);
          doc.setTextColor(74, 58, 51);
          
          const storyLines = doc.splitTextToSize(`"${recipe.story}"`, contentWidth);
          for (const line of storyLines) {
            if (y > pageHeight - 20) {
              doc.addPage();
              doc.setFillColor(248, 245, 241);
              doc.rect(0, 0, pageWidth, pageHeight, 'F');
              y = 25;
            }
            doc.text(line, margin, y);
            y += 5;
          }
          
          doc.setFont("helvetica", "normal");
          doc.setFontSize(9);
          doc.setTextColor(128, 118, 110);
          y += 3;
          doc.text(`— Shared by ${recipe.author_name}`, margin, y);
        }
      }

      // Save PDF
      doc.save("Legacy_Table_Family_Cookbook.pdf");
      toast.success("Cookbook generated successfully!");
    } catch (error) {
      console.error("PDF generation error:", error);
      toast.error("Failed to generate cookbook");
    }
    setGenerating(false);
  };

  return (
    <div className="min-h-screen bg-background" data-testid="cookbook-page">
      <Navigation />
      
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8 animate-fade-in">
          <div className="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
            <div>
              <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Family Cookbook</h1>
              <p className="text-muted-foreground">Select recipes to create a printable PDF cookbook</p>
            </div>
            <div className="flex gap-3">
              <Button
                variant="outline"
                onClick={selectAll}
                className="rounded-full"
                data-testid="select-all-btn"
              >
                {selectedRecipes.length === recipes.length ? "Deselect All" : "Select All"}
              </Button>
              <Button
                onClick={generatePDF}
                disabled={selectedRecipes.length === 0 || generating}
                className="rounded-full bg-primary text-primary-foreground hover:bg-primary/90 shadow-lg shadow-primary/20"
                data-testid="generate-pdf-btn"
              >
                <Download className="w-4 h-4 mr-2" />
                {generating ? "Generating..." : `Export PDF (${selectedRecipes.length})`}
              </Button>
            </div>
          </div>
        </div>

        {/* Selection Info Banner */}
        {selectedRecipes.length > 0 && (
          <div className="mb-6 p-4 rounded-2xl bg-primary/10 border border-primary/20 animate-fade-in" data-testid="selection-banner">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <BookOpen className="w-5 h-5 text-primary" />
                <span className="font-medium text-foreground">
                  {selectedRecipes.length} recipe{selectedRecipes.length !== 1 ? 's' : ''} selected for your cookbook
                </span>
              </div>
              <button 
                onClick={() => setSelectedRecipes([])}
                className="text-sm text-muted-foreground hover:text-foreground"
              >
                Clear selection
              </button>
            </div>
          </div>
        )}

        {loading ? (
          <div className="recipe-grid">
            {[...Array(6)].map((_, i) => (
              <div key={i} className="rounded-2xl overflow-hidden">
                <div className="skeleton aspect-[4/5]" />
                <div className="p-5 space-y-3">
                  <div className="skeleton h-6 w-3/4" />
                  <div className="skeleton h-4 w-1/2" />
                </div>
              </div>
            ))}
          </div>
        ) : recipes.length > 0 ? (
          <div className="recipe-grid" data-testid="cookbook-grid">
            {recipes.map((recipe, index) => (
              <div 
                key={recipe.id} 
                className="animate-fade-in relative" 
                style={{ animationDelay: `${index * 0.05}s` }}
              >
                {/* Selection Checkbox */}
                <button
                  onClick={(e) => {
                    e.stopPropagation();
                    toggleRecipeSelection(recipe.id);
                  }}
                  className={`absolute top-3 left-3 z-10 w-8 h-8 rounded-full border-2 flex items-center justify-center transition-all ${
                    selectedRecipes.includes(recipe.id)
                      ? 'bg-primary border-primary text-white'
                      : 'bg-white/80 border-border hover:border-primary'
                  }`}
                  data-testid={`select-recipe-${recipe.id}`}
                >
                  {selectedRecipes.includes(recipe.id) && (
                    <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                    </svg>
                  )}
                </button>
                <RecipeCard 
                  recipe={recipe} 
                  onClick={() => navigate(`/recipe/${recipe.id}`)}
                />
              </div>
            ))}
          </div>
        ) : (
          <div className="empty-state" data-testid="empty-cookbook">
            <div className="empty-state-icon">
              <BookOpen className="w-10 h-10" />
            </div>
            <h3 className="font-serif text-2xl font-semibold mb-2">No recipes to compile</h3>
            <p className="text-muted-foreground mb-6">Add some recipes first to create your family cookbook!</p>
            <Button 
              onClick={() => navigate("/add-recipe")}
              className="rounded-full bg-primary text-primary-foreground"
              data-testid="cookbook-add-recipe-btn"
            >
              <Plus className="w-4 h-4 mr-2" />
              Add Recipe
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};

// Delete Account Page
const DeleteAccountPage = () => {
  const [email, setEmail] = useState("");
  const [confirmEmail, setConfirmEmail] = useState("");
  const [understood, setUnderstood] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [loading, setLoading] = useState(false);
  const [touched, setTouched] = useState({ email: false, confirmEmail: false });
  const { user } = useAuth();

  const emailTrimmed = email.trim();
  const confirmTrimmed = confirmEmail.trim();
  const emailValid = isValidEmail(emailTrimmed);
  const confirmEmailValid = isValidEmail(confirmTrimmed);
  const emailsMatch = emailTrimmed.toLowerCase() === confirmTrimmed.toLowerCase();
  const canSubmit = emailValid && confirmEmailValid && understood && emailsMatch;

  const showEmailError = touched.email && emailTrimmed && !emailValid;
  const showConfirmError = touched.confirmEmail && confirmTrimmed && !confirmEmailValid;
  const showMatchError = touched.confirmEmail && confirmTrimmed && confirmEmailValid && !emailsMatch;

  const handleRequestDeletion = (e) => {
    e.preventDefault();
    setTouched({ email: true, confirmEmail: true });
    if (!emailValid || !confirmEmailValid) {
      toast.error("Please enter valid email addresses.");
      return;
    }
    if (!emailsMatch) {
      toast.error("Email addresses do not match.");
      return;
    }
    if (!understood) {
      toast.error("Please confirm that you understand this action is permanent.");
      return;
    }
    setShowConfirm(true);
  };

  const handleConfirm = async () => {
    setLoading(true);
    try {
      await axios.post(`${API}/delete-account`, { email: email.trim().toLowerCase() });
      toast.success("Your deletion request has been received. We will process it within 7 business days and notify you by email.");
      setEmail("");
      setConfirmEmail("");
      setUnderstood(false);
      setShowConfirm(false);
    } catch (err) {
      toast.error(err.response?.data?.detail || "Request failed");
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen bg-background flex flex-col" data-testid="delete-account-page">
      {user ? <Navigation /> : (
        <header className="border-b border-border/50 bg-card/50 sticky top-0 z-30">
          <div className="max-w-3xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
            <FamilyLogo size="sm" showText={true} />
            <Link to="/login" className="text-sm font-medium text-primary hover:underline">Back to Login</Link>
          </div>
        </header>
      )}

      <main className="flex-1 w-full max-w-2xl mx-auto px-4 sm:px-6 py-8 sm:py-10">
        <h1 className="font-serif text-3xl font-bold text-foreground mb-8">Delete Account – Legacy Table</h1>

        <section className="mb-8 animate-fade-in">
          <h2 className="font-serif text-xl font-bold text-foreground mb-2">Request Account Deletion</h2>
          <p className="text-muted-foreground text-base leading-relaxed">
            If you would like to delete your Legacy Table account, you can submit a request below.
          </p>
        </section>

        <section className="mb-8">
          <h2 className="font-serif text-xl font-bold text-foreground mb-3">What This Means</h2>
          <p className="text-muted-foreground text-sm mb-2">By requesting account deletion:</p>
          <ul className="list-disc pl-6 space-y-1 text-muted-foreground text-sm">
            <li>Your account will be permanently deleted</li>
            <li>Your personal information will be removed</li>
            <li>You will no longer be able to log in</li>
            <li>This action cannot be undone</li>
          </ul>
        </section>

        <section className="mb-8">
          <h2 className="font-serif text-xl font-bold text-foreground mb-3">Deletion Timeline</h2>
          <ul className="list-disc pl-6 space-y-1 text-muted-foreground text-sm">
            <li>Requests are processed within 7 business days</li>
            <li>You will receive a confirmation email once completed</li>
          </ul>
        </section>

        <section className="bg-card border border-border rounded-2xl p-6 sm:p-8 shadow-lg mb-8">
          <h2 className="font-serif text-xl font-bold text-foreground mb-5">Delete Account Form</h2>
          <form onSubmit={handleRequestDeletion} className="space-y-5">
            <div className="space-y-2">
              <Label htmlFor="delete-email" className="text-sm font-semibold text-foreground">Email Address</Label>
              <Input
                id="delete-email"
                type="email"
                placeholder="your@email.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                onBlur={() => setTouched((t) => ({ ...t, email: true }))}
                className={`rounded-xl border-2 bg-background px-4 py-3 text-foreground focus:border-primary ${showEmailError ? "border-destructive" : "border-border/50"}`}
                required
                aria-invalid={showEmailError}
              />
              {showEmailError && (
                <p className="text-destructive text-sm">Please enter a valid email address.</p>
              )}
            </div>
            <div className="space-y-2">
              <Label htmlFor="delete-confirm-email" className="text-sm font-semibold text-foreground">Confirm Email Address</Label>
              <Input
                id="delete-confirm-email"
                type="email"
                placeholder="your@email.com"
                value={confirmEmail}
                onChange={(e) => setConfirmEmail(e.target.value)}
                onBlur={() => setTouched((t) => ({ ...t, confirmEmail: true }))}
                className={`rounded-xl border-2 bg-background px-4 py-3 text-foreground focus:border-primary ${showConfirmError || showMatchError ? "border-destructive" : "border-border/50"}`}
                required
                aria-invalid={showConfirmError || showMatchError}
              />
              {showConfirmError && (
                <p className="text-destructive text-sm">Please enter a valid email address.</p>
              )}
              {showMatchError && !showConfirmError && (
                <p className="text-destructive text-sm">Email addresses do not match.</p>
              )}
            </div>
            <div className="flex items-start gap-3">
              <Checkbox
                id="delete-understood"
                checked={understood}
                onCheckedChange={(checked) => setUnderstood(checked === true)}
                className="mt-0.5 border-2 border-border"
              />
              <Label htmlFor="delete-understood" className="text-sm text-foreground cursor-pointer leading-tight">
                I understand that deleting my account is permanent and cannot be undone.
              </Label>
            </div>
            <Button
              type="submit"
              variant="destructive"
              className="w-full rounded-full px-8 py-6 text-lg font-serif"
              disabled={!canSubmit}
            >
              Request Account Deletion
            </Button>
          </form>
        </section>

        <section className="border-t border-border pt-6">
          <h2 className="font-serif text-lg font-bold text-foreground mb-2">Need Help?</h2>
          <p className="text-muted-foreground text-sm">
            Contact us at:{" "}
            <a href="mailto:support@cookinglegacy.online" className="text-primary font-medium hover:underline">
              support@cookinglegacy.online
            </a>
          </p>
        </section>
      </main>

      <AlertDialog open={showConfirm} onOpenChange={setShowConfirm}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle className="text-foreground">Confirm deletion request</AlertDialogTitle>
            <AlertDialogDescription className="text-muted-foreground">
              Submit a deletion request for <strong className="text-foreground">{email}</strong>? We will process it within 7 business days and notify you by email.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel className="text-foreground">Cancel</AlertDialogCancel>
            <Button
              type="button"
              variant="destructive"
              onClick={handleConfirm}
              disabled={loading}
            >
              {loading ? "Submitting…" : "Confirm"}
            </Button>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
};

// Invite Landing Page
// Displayed when the App Link verification has not auto-opened the app
// (e.g., desktop browser, app not installed, or first install before verification).
// On Android with verified App Links, Android opens the app directly and this page is never seen.
const InviteLandingPage = () => {
  const { code } = useParams();

  // Auto-attempt to deep-link into the app via the custom scheme.
  // If the app is installed, this opens it. If not, the browser stays here.
  React.useEffect(() => {
    if (code) {
      window.location.href = `legacytable://invite/${code}`;
    }
  }, [code]);

  const tryOpenApp = () => {
    if (code) window.location.href = `legacytable://invite/${code}`;
  };

  return (
    <div className="min-h-screen bg-background flex flex-col" data-testid="invite-landing-page">
      <header className="border-b border-border/50 bg-card/50 sticky top-0 z-30">
        <div className="max-w-3xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
          <FamilyLogo size="sm" showText={true} />
        </div>
      </header>
      <main className="flex-1 flex items-center justify-center px-4 py-12">
        <div className="max-w-md w-full text-center space-y-6">
          <h1 className="text-3xl font-bold">You've been invited to a Legacy Table</h1>
          <p className="text-muted-foreground">
            Open the Legacy Table app to view this invite. If you don't have the app yet,
            install it first and the invite will be waiting for you.
          </p>
          <div className="space-y-3">
            <Button onClick={tryOpenApp} className="w-full" data-testid="invite-open-app-btn">
              Open in Legacy Table
            </Button>
            <div className="flex gap-3 justify-center pt-4">
              <a
                href="https://play.google.com/store/apps/details?id=com.htrecipes.family_recipe_app"
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm font-medium text-primary hover:underline"
                data-testid="invite-play-store-link"
              >
                Get it on Google Play
              </a>
              <a
                href="https://apps.apple.com/app/legacy-table"
                target="_blank"
                rel="noopener noreferrer"
                className="text-sm font-medium text-primary hover:underline"
                data-testid="invite-app-store-link"
              >
                Download on the App Store
              </a>
            </div>
          </div>
          {code && (
            <p className="text-xs text-muted-foreground pt-6">
              Invite code: <span className="font-mono">{code}</span>
            </p>
          )}
        </div>
      </main>
    </div>
  );
};

// Privacy Policy Page
const PrivacyPolicyPage = () => {
  const navigate = useNavigate();
  const { user } = useAuth();

  return (
    <div className="min-h-screen bg-background" data-testid="privacy-policy-page">
      {user ? <Navigation /> : (
        <header className="border-b border-border/50 bg-card/50 sticky top-0 z-30">
          <div className="max-w-3xl mx-auto px-4 sm:px-6 py-4 flex items-center justify-between">
            <FamilyLogo size="sm" showText={true} />
            <Link to="/login" className="text-sm font-medium text-primary hover:underline">Back to Login</Link>
          </div>
        </header>
      )}

      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="mb-8 animate-fade-in">
          <h1 className="font-serif text-3xl md:text-4xl font-bold text-foreground mb-2">Privacy Policy</h1>
          <p className="text-muted-foreground">Effective Date: February 3, 2025</p>
        </div>

        <div className="space-y-6 text-foreground animate-slide-up">
          <p className="text-base leading-relaxed text-muted-foreground">
            Legacy Table (&quot;Legacy Table,&quot; &quot;we,&quot; &quot;our,&quot; or &quot;us&quot;) is a private, invite-only family app designed to help families preserve recipes, photos, and food traditions together. We are committed to protecting your privacy and handling your data with care.
          </p>
          <p className="text-base leading-relaxed text-muted-foreground">
            This Privacy Policy explains how information is collected, used, and protected when you use the Legacy Table mobile application and related services.
          </p>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">1. Information We Collect</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-3">We collect only the information necessary to provide the core functionality of the app.</p>
            <h3 className="font-semibold text-lg text-foreground mb-2">Information You Provide</h3>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground mb-4">
              <li><strong className="text-foreground">Account information:</strong> name, email address, and password</li>
              <li><strong className="text-foreground">Family content:</strong> recipes, photos, comments, notes, and cookbook collections</li>
              <li><strong className="text-foreground">Invitations:</strong> email addresses or invite codes used to add family members</li>
            </ul>
            <h3 className="font-semibold text-lg text-foreground mb-2">Automatically Collected Information</h3>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground mb-2">
              <li><strong className="text-foreground">App usage data:</strong> basic interactions such as feature usage and performance</li>
              <li><strong className="text-foreground">Device information:</strong> device type, operating system version, and app version</li>
            </ul>
            <p className="text-base leading-relaxed text-muted-foreground">We do not collect precise location data.</p>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">2. How We Use Information</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">We use your information solely to operate and improve Legacy Table, including to:</p>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground mb-2">
              <li>Create and manage private family spaces</li>
              <li>Enable recipe sharing, comments, and photo uploads</li>
              <li>Authenticate users and manage invitations</li>
              <li>Maintain app performance, reliability, and security</li>
              <li>Respond to support requests</li>
            </ul>
            <p className="text-base leading-relaxed text-muted-foreground">We do not use your data for advertising purposes.</p>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">3. Private, Invite-Only Design</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">Legacy Table is private by default.</p>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground">
              <li>Family content is visible only to invited members of that family</li>
              <li>There are no public profiles, public feeds, or searchable family content</li>
              <li>Content is not shared outside your family unless you explicitly choose to export it</li>
            </ul>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">4. Data Sharing</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">We do not sell, rent, or trade personal or family data.</p>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">We may share limited data only:</p>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground">
              <li>With trusted service providers who help operate the app (such as cloud hosting and image storage), under strict confidentiality agreements</li>
              <li>If required by law or to protect the safety and rights of users and the platform</li>
            </ul>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">5. Data Storage and Security</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">We take reasonable measures to protect your information, including:</p>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground mb-2">
              <li>Secure authentication</li>
              <li>Encrypted data transmission</li>
              <li>Restricted access to user data</li>
            </ul>
            <p className="text-base leading-relaxed text-muted-foreground">No system is perfectly secure, but we design Legacy Table with privacy and care as core principles.</p>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">6. Data Retention and Deletion</h2>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground">
              <li>Your data is retained for as long as your account is active</li>
              <li>You may request account deletion at any time</li>
              <li>When an account is deleted, associated personal data is removed or anonymized in accordance with applicable laws</li>
            </ul>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">7. Children&apos;s Privacy</h2>
            <p className="text-base leading-relaxed text-muted-foreground">Legacy Table is intended for family use. We do not knowingly collect personal information from children under 13 without parental or guardian consent.</p>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">8. Your Rights</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">Depending on your location, you may have rights to:</p>
            <ul className="list-disc pl-6 space-y-1 text-base text-muted-foreground mb-2">
              <li>Access your personal data</li>
              <li>Request correction or deletion</li>
              <li>Withdraw consent where applicable</li>
            </ul>
            <p className="text-base leading-relaxed text-muted-foreground">To make a request, contact us using the information below.</p>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">9. Changes to This Policy</h2>
            <p className="text-base leading-relaxed text-muted-foreground">We may update this Privacy Policy from time to time. Any changes will be posted on this page with an updated effective date.</p>
          </section>

          <section>
            <h2 className="font-serif text-xl font-bold text-foreground mb-3">10. Contact Us</h2>
            <p className="text-base leading-relaxed text-muted-foreground mb-2">If you have questions or concerns about this Privacy Policy or your data, contact us at:</p>
            <p className="text-base leading-relaxed text-foreground font-medium">Email: <a href="mailto:support@legacytable.app" className="text-primary hover:underline">support@legacytable.app</a></p>
          </section>
        </div>

        {!user && (
          <div className="mt-10 text-center">
            <Button onClick={() => navigate("/login")} variant="outline" className="rounded-full">Back to Login</Button>
          </div>
        )}
      </div>
    </div>
  );
};

function App() {
  return (
    <div className="App">
      <ThemeProvider>
        <AuthProvider>
          <BrowserRouter>
            <SubscriptionProvider>
              <Routes>
                <Route path="/login" element={<LoginPage />} />
                <Route path="/privacy-policy" element={<PrivacyPolicyPage />} />
                <Route path="/delete-account" element={<DeleteAccountPage />} />
                <Route path="/invite/:code" element={<InviteLandingPage />} />
                <Route path="/subscribe" element={<ProtectedRoute><PricingPage /></ProtectedRoute>} />
                <Route path="/subscription-success" element={<ProtectedRoute><SubscriptionSuccessPage /></ProtectedRoute>} />
                <Route path="/" element={<LandingPage />} />
                <Route path="/home" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
                <Route path="/add-recipe" element={<ProtectedRoute><AddRecipePage /></ProtectedRoute>} />
                <Route path="/scan-recipe" element={<ProtectedRoute><ScanRecipePage /></ProtectedRoute>} />
                <Route path="/voice-recipe" element={<ProtectedRoute><VoiceRecipePage /></ProtectedRoute>} />
                <Route path="/save-from-link" element={<ProtectedRoute><SaveFromLinkPage /></ProtectedRoute>} />
                <Route path="/recipe/:id" element={<ProtectedRoute><RecipeDetailPage /></ProtectedRoute>} />
                <Route path="/recipe/:id/edit" element={<ProtectedRoute><EditRecipePage /></ProtectedRoute>} />
                <Route path="/recipe/:id/cook" element={<ProtectedRoute><CookModePage /></ProtectedRoute>} />
                <Route path="/profile" element={<ProtectedRoute><ProfilePage /></ProtectedRoute>} />
                <Route path="/settings" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
                <Route path="/family" element={<ProtectedRoute><FamilyPage /></ProtectedRoute>} />
                <Route path="/cookbook" element={<ProtectedRoute><CookbookPage /></ProtectedRoute>} />
              </Routes>
            </SubscriptionProvider>
          </BrowserRouter>
          <Toaster position="top-center" richColors />
        </AuthProvider>
      </ThemeProvider>
      <div className="grain-overlay" />
    </div>
  );
}

export default App;
