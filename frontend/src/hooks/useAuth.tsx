import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import * as authApi from "@/api/auth";
import { ApiRequestError } from "@/api/client";
import type {
  LoginRequest,
  RegisterRequest,
  UserWithStats,
} from "@/api/types";

interface AuthState {
  user: UserWithStats | null;
  loading: boolean;
}

interface AuthContextValue extends AuthState {
  login: (data: LoginRequest) => Promise<void>;
  register: (data: RegisterRequest) => Promise<void>;
  logout: () => Promise<void>;
  refresh: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<AuthState>({
    user: null,
    loading: true,
  });

  const refresh = useCallback(async () => {
    try {
      const user = await authApi.getMe();
      setState({ user, loading: false });
    } catch (err) {
      if (err instanceof ApiRequestError && err.status === 401) {
        // Access token missing or expired — try refreshing once
        try {
          await authApi.refresh();
          const user = await authApi.getMe();
          setState({ user, loading: false });
        } catch {
          // Refresh also failed — user is not logged in
          setState({ user: null, loading: false });
        }
      } else {
        setState({ user: null, loading: false });
      }
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const login = useCallback(async (data: LoginRequest) => {
    await authApi.login(data);
    const fullUser = await authApi.getMe();
    setState({ user: fullUser, loading: false });
  }, []);

  const register = useCallback(async (data: RegisterRequest) => {
    await authApi.register(data);
    const fullUser = await authApi.getMe();
    setState({ user: fullUser, loading: false });
  }, []);

  const logout = useCallback(async () => {
    try {
      await authApi.logout();
    } catch {
      // Clear local state regardless — the user wants to log out
    }
    setState({ user: null, loading: false });
  }, []);

  const value = useMemo<AuthContextValue>(
    () => ({ ...state, login, register, logout, refresh }),
    [state, login, register, logout, refresh],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return ctx;
}
