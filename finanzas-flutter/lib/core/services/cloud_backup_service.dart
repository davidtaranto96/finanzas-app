import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

class CloudBackupService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String uid;

  CloudBackupService({required this.uid});

  Reference get _backupRef => _storage.ref('users/$uid/finanzas_app.sqlite');

  /// Sube el archivo SQLite local a Firebase Storage.
  Future<DateTime> uploadBackup() async {
    final dbFile = await _dbFile();
    if (!await dbFile.exists()) {
      throw Exception('No se encontró la base de datos local.');
    }

    await _backupRef.putFile(
      dbFile,
      SettableMetadata(
        contentType: 'application/octet-stream',
        customMetadata: {'createdAt': DateTime.now().toIso8601String()},
      ),
    );

    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_backup_ts', now.toIso8601String());
    return now;
  }

  /// Descarga el backup de Firebase Storage y reemplaza la DB local.
  /// ⚠️ La app debe reiniciarse para que Drift use la nueva DB.
  Future<void> downloadBackup() async {
    final dbFile = await _dbFile();
    final tempFile = File('${dbFile.path}.tmp');

    await _backupRef.writeToFile(tempFile);

    if (await tempFile.exists()) {
      if (await dbFile.exists()) await dbFile.delete();
      await tempFile.rename(dbFile.path);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_restore_ts', DateTime.now().toIso8601String());
    } else {
      throw Exception('No se pudo descargar el backup.');
    }
  }

  /// Check if a remote backup exists in Firebase Storage.
  /// Returns the creation date if found, null if not.
  Future<DateTime?> remoteBackupDate() async {
    try {
      final metadata = await _backupRef.getMetadata();
      final createdAt = metadata.customMetadata?['createdAt'];
      if (createdAt != null) return DateTime.tryParse(createdAt);
      return metadata.updated ?? metadata.timeCreated;
    } catch (_) {
      // File doesn't exist or no permission
      return null;
    }
  }

  /// Devuelve la fecha del último backup local, o null.
  Future<DateTime?> lastBackupDate() async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getString('last_backup_ts');
    return ts != null ? DateTime.tryParse(ts) : null;
  }

  Future<File> _dbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'finanzas_app.sqlite'));
  }
}
