import { useState, type FormEvent } from "react";
import { Link, Navigate, useNavigate } from "react-router-dom";
import { Zap } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useAuth } from "@/hooks/useAuth";
import { ApiRequestError } from "@/api/client";

type Field = "username" | "email" | "password";

function fieldError(error: string): { field: Field | null; message: string } {
  const lower = error.toLowerCase();
  if (lower.includes("username")) return { field: "username", message: error };
  if (lower.includes("email")) return { field: "email", message: error };
  if (lower.includes("password")) return { field: "password", message: error };
  return { field: null, message: error };
}

export function RegisterPage() {
  const { user, register } = useAuth();
  const navigate = useNavigate();
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<{ field: string | null; message: string } | null>(null);
  const [submitting, setSubmitting] = useState(false);

  if (user) return <Navigate to="/" replace />;

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      await register({ username, email, password });
      navigate("/", { replace: true });
    } catch (err) {
      if (err instanceof ApiRequestError) {
        setError(fieldError(err.message));
      } else {
        setError({ field: null, message: "Something went wrong. Please try again." });
      }
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="flex min-h-[70vh] items-center justify-center px-4">
      <Card className="w-full max-w-sm">
        <CardHeader className="text-center">
          <div className="mx-auto mb-2 flex size-10 items-center justify-center rounded-lg bg-primary">
            <Zap className="size-5 text-primary-foreground" />
          </div>
          <CardTitle className="text-2xl">Create an account</CardTitle>
          <CardDescription>Start solving daily challenges</CardDescription>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="grid gap-4">
            {error && !error.field && (
              <p className="rounded-md bg-destructive/10 px-3 py-2 text-sm text-destructive">
                {error.message}
              </p>
            )}
            <div className="grid gap-2">
              <Label htmlFor="username">Username</Label>
              <Input
                id="username"
                required
                autoComplete="username"
                value={username}
                onChange={(e) => { setUsername(e.target.value); setError(null); }}
                placeholder="coolhacker42"
                aria-invalid={error?.field === "username" || undefined}
              />
              {error?.field === "username" && (
                <p className="text-sm text-destructive">{error.message}</p>
              )}
            </div>
            <div className="grid gap-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                required
                autoComplete="email"
                value={email}
                onChange={(e) => { setEmail(e.target.value); setError(null); }}
                placeholder="you@example.com"
                aria-invalid={error?.field === "email" || undefined}
              />
              {error?.field === "email" && (
                <p className="text-sm text-destructive">{error.message}</p>
              )}
            </div>
            <div className="grid gap-2">
              <Label htmlFor="password">Password</Label>
              <Input
                id="password"
                type="password"
                required
                minLength={8}
                autoComplete="new-password"
                value={password}
                onChange={(e) => { setPassword(e.target.value); setError(null); }}
                aria-invalid={error?.field === "password" || undefined}
              />
              {error?.field === "password" ? (
                <p className="text-sm text-destructive">{error.message}</p>
              ) : (
                <p className="text-sm text-muted-foreground">At least 8 characters</p>
              )}
            </div>
            <Button type="submit" disabled={submitting} className="w-full">
              {submitting ? "Creating account..." : "Sign up"}
            </Button>
          </form>
          <p className="mt-4 text-center text-sm text-muted-foreground">
            Already have an account?{" "}
            <Link to="/login" className="text-primary underline-offset-4 hover:underline">
              Log in
            </Link>
          </p>
        </CardContent>
      </Card>
    </div>
  );
}
