import { useEffect, useRef, useState } from "react";
import { Link, useLocation, useNavigate } from "react-router-dom";
import {
  CalendarDays,
  Flame,
  Lightbulb,
  Menu,
  Moon,
  Sun,
  Terminal,
  Trophy,
  Zap,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { useAuth } from "@/hooks/useAuth";
import { useTheme } from "@/hooks/useTheme";
import { Sidebar } from "./Sidebar";

export function Navbar() {
  const { user } = useAuth();
  const { theme, toggleTheme } = useTheme();
  const { pathname } = useLocation();
  const navigate = useNavigate();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [archiveOpen, setArchiveOpen] = useState(false);
  const archiveRef = useRef<HTMLDivElement>(null);

  // Close archive dropdown on outside click or Escape
  useEffect(() => {
    if (!archiveOpen) return;
    function onClick(e: MouseEvent) {
      if (archiveRef.current && !archiveRef.current.contains(e.target as Node))
        setArchiveOpen(false);
    }
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") setArchiveOpen(false);
    }
    document.addEventListener("mousedown", onClick);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("mousedown", onClick);
      document.removeEventListener("keydown", onKey);
    };
  }, [archiveOpen]);

  const streak = (() => {
    if (!user) return 0;
    if (pathname === "/code-output" || pathname.startsWith("/code-output/"))
      return user.code_output_stats.current_streak;
    if (pathname === "/trivia" || pathname.startsWith("/trivia/"))
      return user.trivia_stats.current_streak;
    return Math.max(
      user.trivia_stats.current_streak,
      user.code_output_stats.current_streak,
    );
  })();

  return (
    <>
      <header className="sticky top-0 z-50 border-b bg-background/80 backdrop-blur-sm">
        <div className="flex h-14 items-center justify-between px-4">
          {/* Left: hamburger | archive | leaderboard */}
          <div className="flex items-center">
            <button
              onClick={() => setSidebarOpen(true)}
              aria-label="Open menu"
              className="flex size-11 items-center justify-center rounded-lg text-foreground transition-all duration-150 hover:bg-muted active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
            >
              <Menu className="size-6" strokeWidth={2.5} />
            </button>

            <div className="mx-1 h-4 w-px bg-border" />

            {/* Shortcut icons */}
            <div className="flex items-center gap-1">

            {/* Archive dropdown */}
            <div ref={archiveRef} className="relative">
              <button
                onClick={() => setArchiveOpen((v) => !v)}
                title="Archive"
                aria-label="Archive"
                className="flex size-11 items-center justify-center rounded-lg text-foreground transition-all duration-150 hover:bg-muted active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
              >
                <CalendarDays className="size-6" strokeWidth={2.5} />
              </button>

              {archiveOpen && (
                <div className="absolute left-0 top-full mt-1 w-56 animate-[fade-in_150ms_ease] rounded-lg border border-border bg-background p-1 shadow-lg">
                  <Link
                    to="/trivia/archive"
                    onClick={() => setArchiveOpen(false)}
                    className="flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium text-foreground transition-colors hover:bg-muted"
                  >
                    <Lightbulb className="size-4 shrink-0 text-amber-500" />
                    Daily Trivia Archive
                  </Link>
                  <Link
                    to="/code-output/archive"
                    onClick={() => setArchiveOpen(false)}
                    className="flex items-center gap-3 rounded-md px-3 py-2.5 text-sm font-medium text-foreground transition-colors hover:bg-muted"
                  >
                    <Terminal className="size-4 shrink-0 text-emerald-500" />
                    What's the Output? Archive
                  </Link>
                </div>
              )}
            </div>

            {/* Leaderboard shortcut */}
            <button
              onClick={() => navigate("/leaderboard")}
              title="Leaderboard"
              aria-label="Leaderboard"
              className="flex size-11 items-center justify-center rounded-lg text-foreground transition-all duration-150 hover:bg-muted active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
            >
              <Trophy className="size-6" strokeWidth={2.5} />
            </button>

            </div>
          </div>

          {/* Center: brand */}
          <Link
            to="/"
            className="absolute left-1/2 flex -translate-x-1/2 items-center gap-2 rounded-lg px-2 py-1 text-lg font-bold tracking-tight transition-all duration-150 hover:opacity-70 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
          >
            <Zap className="size-5 text-primary" />
            BrainForge
          </Link>

          {/* Right: streak + theme + user */}
          <div className="flex items-center gap-2">
            {user && streak > 0 && (
              <div className="flex items-center gap-1.5 rounded-md bg-amber-500/10 px-2.5 py-1 text-sm font-medium dark:bg-muted">
                <Flame className="size-4 text-orange-500" />
                <span>{streak}</span>
              </div>
            )}

            <Button variant="ghost" size="icon" onClick={toggleTheme}>
              {theme === "dark" ? (
                <Sun className="size-4" />
              ) : (
                <Moon className="size-4" />
              )}
            </Button>

            {user ? (
              <Link to="/settings" className="rounded-full focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50 focus-visible:ring-offset-2 focus-visible:ring-offset-background">
                <Avatar className="size-8 transition-all duration-150 hover:opacity-70 active:scale-95">
                  <AvatarFallback className="text-xs">
                    {user.username.slice(0, 2).toUpperCase()}
                  </AvatarFallback>
                </Avatar>
              </Link>
            ) : (
              <div className="flex items-center gap-2">
                <Button variant="ghost" size="sm" asChild>
                  <Link to="/login">Log in</Link>
                </Button>
                <Button size="sm" asChild>
                  <Link to="/register">Sign up</Link>
                </Button>
              </div>
            )}
          </div>
        </div>
      </header>

      <Sidebar open={sidebarOpen} onClose={() => setSidebarOpen(false)} />
    </>
  );
}