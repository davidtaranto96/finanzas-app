import { useCallback } from 'react';
import { useFocusEffect } from 'expo-router';
import { useFabStore, FabConfig } from '@/src/stores/fabStore';

/**
 * Registra la configuración del FAB para la pantalla activa.
 * Al entrar en foco → setConfig (FAB aparece con animación).
 * No limpia en blur — el próximo tab sobreescribe o llama useNoFab.
 */
export function useFab(config: FabConfig) {
  const setConfig = useFabStore((s) => s.setConfig);

  useFocusEffect(
    useCallback(() => {
      setConfig(config);
      // Sin cleanup: el próximo tab se encarga de su propia config
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );
}

/**
 * Para tabs que NO quieren FAB (Más, Presupuesto).
 * Oculta el FAB con animación al entrar en foco.
 */
export function useNoFab() {
  const clearConfig = useFabStore((s) => s.clearConfig);

  useFocusEffect(
    useCallback(() => {
      clearConfig();
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );
}
