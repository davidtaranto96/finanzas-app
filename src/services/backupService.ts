import { ref, uploadBytes, getDownloadURL, getMetadata } from 'firebase/storage';
import { storage } from '@/src/lib/firebase';
import * as FileSystem from 'expo-file-system';

const DB_NAME = 'finanzas.db';

/**
 * Sube el archivo SQLite a Firebase Storage
 */
export async function uploadBackup(uid: string): Promise<{ url: string; timestamp: Date }> {
  const dbPath = `${FileSystem.documentDirectory}SQLite/${DB_NAME}`;

  // Verificar que existe
  const info = await FileSystem.getInfoAsync(dbPath);
  if (!info.exists) throw new Error('No se encontró la base de datos');

  // Leer como base64
  const base64 = await FileSystem.readAsStringAsync(dbPath, {
    encoding: FileSystem.EncodingType.Base64,
  });

  // Convertir a Uint8Array
  const binaryString = atob(base64);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }

  // Subir a Storage
  const storageRef = ref(storage, `users/${uid}/backup.sqlite`);
  await uploadBytes(storageRef, bytes.buffer as ArrayBuffer, {
    contentType: 'application/x-sqlite3',
  });

  const url = await getDownloadURL(storageRef);
  return { url, timestamp: new Date() };
}

/**
 * Descarga el backup de Firebase Storage y reemplaza la DB local
 */
export async function downloadBackup(uid: string): Promise<void> {
  const storageRef = ref(storage, `users/${uid}/backup.sqlite`);
  const url = await getDownloadURL(storageRef);

  const dbPath = `${FileSystem.documentDirectory}SQLite/${DB_NAME}`;

  // Descargar archivo
  const download = await FileSystem.downloadAsync(url, dbPath);
  if (download.status !== 200) {
    throw new Error('Error al descargar el backup');
  }
}

/**
 * Obtiene la fecha del último backup
 */
export async function getLastBackupDate(uid: string): Promise<Date | null> {
  try {
    const storageRef = ref(storage, `users/${uid}/backup.sqlite`);
    const metadata = await getMetadata(storageRef);
    return metadata.updated ? new Date(metadata.updated) : null;
  } catch {
    return null; // No hay backup
  }
}
