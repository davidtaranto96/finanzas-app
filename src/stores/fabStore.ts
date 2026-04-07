import { create } from 'zustand';

export type FabAction = {
  icon: string;
  label: string;
  onPress: () => void;
  style?: object;
};

export type FabConfig = {
  icon?: string;
  onPress?: () => void;
  actions?: FabAction[];
};

type FabState = {
  isActive: boolean;
  icon: string;
  onPress?: () => void;
  actions: FabAction[];
  groupOpen: boolean;
  /** Incrementa cada vez que cambia la config, para triggear animación */
  configVersion: number;
  setConfig: (config: FabConfig) => void;
  clearConfig: () => void;
  setGroupOpen: (open: boolean) => void;
};

export const useFabStore = create<FabState>((set, get) => ({
  isActive: false,
  icon: 'plus',
  onPress: undefined,
  actions: [],
  groupOpen: false,
  configVersion: 0,
  setConfig: (config) =>
    set({
      isActive: true,
      icon: config.icon ?? 'plus',
      onPress: config.onPress,
      actions: config.actions ?? [],
      groupOpen: false,
      configVersion: get().configVersion + 1,
    }),
  clearConfig: () =>
    set({
      isActive: false,
      groupOpen: false,
      configVersion: get().configVersion + 1,
    }),
  setGroupOpen: (open) => set({ groupOpen: open }),
}));
