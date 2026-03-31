import { Platform } from 'react-native';
import * as SQLite from 'expo-sqlite';

// Singleton — una sola conexión abierta para toda la app
// Evita NullPointerException en Android al reabrir la BD constantemente
let _db: SQLite.SQLiteDatabase | null = null;

export function getDb(): SQLite.SQLiteDatabase {
  if (Platform.OS === 'web') throw new Error('SQLite not available on web');
  if (!_db) {
    _db = SQLite.openDatabaseSync('finanzas.db');
  }
  return _db;
}
