import { create } from 'zustand';
import { User } from 'firebase/auth';
import { signInWithGoogleToken, signOut as authSignOut, onAuthChange, getUserProfile } from '@/src/services/authService';

type UserProfile = {
  displayName: string;
  email: string;
  photoUrl?: string;
  appCode: string;
};

type AuthState = {
  user: User | null;
  profile: UserProfile | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
  signInWithGoogle: (idToken: string) => Promise<void>;
  signOut: () => Promise<void>;
  init: () => () => void; // returns unsubscribe function
};

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  profile: null,
  isAuthenticated: false,
  isLoading: true,
  error: null,

  signInWithGoogle: async (idToken: string) => {
    set({ isLoading: true, error: null });
    try {
      const user = await signInWithGoogleToken(idToken);
      const profile = await getUserProfile(user.uid) as UserProfile | null;
      set({ user, profile, isAuthenticated: true, isLoading: false });
    } catch (e: any) {
      set({ error: e.message || 'Error al iniciar sesión', isLoading: false });
    }
  },

  signOut: async () => {
    try {
      await authSignOut();
      set({ user: null, profile: null, isAuthenticated: false });
    } catch (e: any) {
      set({ error: e.message });
    }
  },

  init: () => {
    // Escucha cambios de auth (login/logout/token refresh)
    const unsubscribe = onAuthChange(async (user) => {
      if (user) {
        const profile = await getUserProfile(user.uid) as UserProfile | null;
        set({ user, profile, isAuthenticated: true, isLoading: false });
      } else {
        set({ user: null, profile: null, isAuthenticated: false, isLoading: false });
      }
    });
    return unsubscribe;
  },
}));
