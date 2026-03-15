import { Navigate, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";

// Game pages should not be remembered as redirect targets —
// after login the user always lands on the hub and picks a game.
const GAME_PREFIXES = ["/trivia", "/code-output"];

function shouldRememberPath(pathname: string): boolean {
  if (pathname === "/") return false;
  return !GAME_PREFIXES.some(
    (p) => pathname === p || pathname.startsWith(p + "/"),
  );
}

export function ProtectedRoute() {
  const { user, loading } = useAuth();
  const location = useLocation();

  if (loading) {
    return (
      <div className="flex min-h-[60vh] items-center justify-center">
        <div className="size-8 animate-spin rounded-full border-2 border-muted border-t-primary" />
      </div>
    );
  }

  if (!user) {
    const from = shouldRememberPath(location.pathname)
      ? location.pathname
      : undefined;
    return <Navigate to="/login" state={{ from }} replace />;
  }

  return <Outlet />;
}
