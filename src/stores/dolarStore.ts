import { create } from 'zustand';
import { DolarRate, fetchDolarRates } from '@/src/services/dolarService';

type DolarState = {
  rates: DolarRate[];
  lastUpdated: Date | null;
  isLoading: boolean;
  error: string | null;
  fetch: () => Promise<void>;
  startAutoRefresh: () => void;
  stopAutoRefresh: () => void;
};

let refreshInterval: ReturnType<typeof setInterval> | null = null;
const REFRESH_MS = 15 * 60 * 1000; // 15 minutos

export const useDolarStore = create<DolarState>((set, get) => ({
  rates: [],
  lastUpdated: null,
  isLoading: false,
  error: null,

  fetch: async () => {
    set({ isLoading: true, error: null });
    try {
      const data = await fetchDolarRates();
      set({ rates: data, lastUpdated: new Date(), isLoading: false });
    } catch (e: any) {
      set({ error: e.message || 'Error desconocido', isLoading: false });
    }
  },

  startAutoRefresh: () => {
    if (refreshInterval) return; // ya corriendo
    refreshInterval = setInterval(() => {
      get().fetch();
    }, REFRESH_MS);
  },

  stopAutoRefresh: () => {
    if (refreshInterval) {
      clearInterval(refreshInterval);
      refreshInterval = null;
    }
  },
}));
