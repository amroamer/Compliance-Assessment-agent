"use client";

import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useState,
} from "react";
import { api } from "@/lib/api";
import type { User, TokenResponse } from "@/types";

interface AuthContextType {
  user: User | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType>({
  user: null,
  loading: true,
  login: async () => {},
  logout: () => {},
});

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);

  const fetchUser = useCallback(async () => {
    try {
      let token = localStorage.getItem("token");

      // If no token, attempt SSO auto-login via HTTP-only cookie
      if (!token) {
        try {
          const ssoRes = await fetch(
            "/AICompAgent/api/auth/sso",
            { method: "POST", credentials: "include" }
          );
          if (ssoRes.ok) {
            const ssoData = await ssoRes.json();
            localStorage.setItem("token", ssoData.access_token);
            token = ssoData.access_token;
          }
        } catch {
          // SSO failed, will show login form
        }
      }

      if (!token) {
        setLoading(false);
        return;
      }

      const data = await api.get<User>("/auth/me");
      setUser(data);
    } catch {
      localStorage.removeItem("token");
      setUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchUser();
  }, [fetchUser]);

  const login = async (email: string, password: string) => {
    const data = await api.post<TokenResponse>("/auth/login", {
      email,
      password,
    });
    localStorage.setItem("token", data.access_token);
    await fetchUser();
  };

  const logout = () => {
    localStorage.removeItem("token");
    setUser(null);
    window.location.href = "/login";
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => useContext(AuthContext);
