import { useEffect, useRef, useState } from "react";
import { Link, useLocation } from "react-router-dom";
import {
  Calendar,
  Home,
  Lightbulb,
  LogOut,
  Settings,
  Terminal,
  Trophy,
  X,
} from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { cn } from "@/lib/utils";

interface SidebarProps {
  open: boolean;
  onClose: () => void;
}

function SidebarLink({
  to,
  icon: Icon,
  children,
  onClose,
}: {
  to: string;
  icon: React.ElementType;
  children: React.ReactNode;
  onClose: () => void;
}) {
  const { pathname } = useLocation();
  const active = pathname === to;

  return (
    <Link
      to={to}
      onClick={onClose}
      className={cn(
        "flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium transition-all duration-150 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50 active:scale-[0.98]",
        active
          ? "bg-primary/10 text-primary"
          : "text-muted-foreground hover:bg-muted hover:text-foreground",
      )}
    >
      <Icon className="size-4 shrink-0" />
      {children}
    </Link>
  );
}

export function Sidebar({ open, onClose }: SidebarProps) {
  const { user, logout } = useAuth();
  const panelRef = useRef<HTMLDivElement>(null);
  const [closing, setClosing] = useState(false);

  function handleClose() {
    setClosing(true);
    setTimeout(() => {
      setClosing(false);
      onClose();
    }, 250);
  }

  // Close on Escape
  useEffect(() => {
    if (!open) return;
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") handleClose();
    }
    document.addEventListener("keydown", onKey);
    return () => document.removeEventListener("keydown", onKey);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open]);

  // Prevent body scroll when open
  useEffect(() => {
    if (open) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
    return () => {
      document.body.style.overflow = "";
    };
  }, [open]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-[60]">
      {/* Backdrop */}
      <div
        className={cn(
          "absolute inset-0 bg-black/60 backdrop-blur-sm",
          closing
            ? "animate-[fade-out_250ms_ease]"
            : "animate-[fade-in_250ms_ease]",
        )}
        onClick={handleClose}
      />

      {/* Panel */}
      <div
        ref={panelRef}
        className={cn(
          "absolute inset-y-0 left-0 flex w-72 flex-col border-r border-border bg-background shadow-2xl",
          closing
            ? "animate-[slide-out-left_250ms_ease]"
            : "animate-[slide-in-left_300ms_ease]",
        )}
      >
        {/* Header */}
        <div className="flex items-center justify-between border-b border-border px-4 py-4">
          <span className="text-lg font-bold tracking-tight">BrainForge</span>
          <button
            onClick={handleClose}
            className="rounded-md p-1.5 text-muted-foreground transition-all duration-150 hover:bg-muted hover:text-foreground active:scale-95 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
          >
            <X className="size-5" />
          </button>
        </div>

        {/* Nav links */}
        <nav className="flex-1 space-y-1 overflow-y-auto px-3 py-4">
          <SidebarLink to="/" icon={Home} onClose={handleClose}>
            Home
          </SidebarLink>

          <p className="px-3 pb-1 pt-5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            Games
          </p>
          <SidebarLink to="/trivia" icon={Lightbulb} onClose={handleClose}>
            Daily Trivia
          </SidebarLink>
          <SidebarLink to="/code-output" icon={Terminal} onClose={handleClose}>
            What's the Output?
          </SidebarLink>

          <p className="px-3 pb-1 pt-5 text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            Archives
          </p>
          <SidebarLink
            to="/trivia/archive"
            icon={Calendar}
            onClose={handleClose}
          >
            Trivia Archive
          </SidebarLink>
          <SidebarLink
            to="/code-output/archive"
            icon={Calendar}
            onClose={handleClose}
          >
            Code Output Archive
          </SidebarLink>

          <div className="my-3 border-t border-border" />

          <SidebarLink to="/leaderboard" icon={Trophy} onClose={handleClose}>
            Leaderboard
          </SidebarLink>
          {user && (
            <SidebarLink to="/settings" icon={Settings} onClose={handleClose}>
              Settings
            </SidebarLink>
          )}
        </nav>

        {/* Footer */}
        {user && (
          <div className="border-t border-border px-3 py-4">
            <div className="mb-3 px-3">
              <p className="text-sm font-medium">{user.username}</p>
              <p className="text-xs text-muted-foreground">{user.email}</p>
            </div>
            <button
              onClick={() => {
                handleClose();
                logout();
              }}
              className="flex w-full items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium text-muted-foreground transition-all duration-150 hover:bg-destructive/10 hover:text-destructive active:scale-[0.98] focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring/50"
            >
              <LogOut className="size-4" />
              Log out
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
