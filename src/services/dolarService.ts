export type DolarRate = {
  moneda: string;
  casa: string;
  nombre: string;
  compra: number;
  venta: number;
  fechaActualizacion: string;
};

const API_URL = 'https://dolarapi.com/v1/dolares';
const TIMEOUT_MS = 5000;

/**
 * Obtiene cotizaciones del dólar desde dolarapi.com
 * Retorna array con todas las cotizaciones (blue, oficial, bolsa/MEP, etc.)
 */
export async function fetchDolarRates(): Promise<DolarRate[]> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), TIMEOUT_MS);

  try {
    const response = await fetch(API_URL, { signal: controller.signal });
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    const data: DolarRate[] = await response.json();
    return data;
  } catch (error: any) {
    if (error.name === 'AbortError') {
      throw new Error('Timeout: no se pudo conectar');
    }
    throw new Error(error.message || 'Error al obtener cotizaciones');
  } finally {
    clearTimeout(timeout);
  }
}
