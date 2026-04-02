import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Nota: sqlite3_flutter_libs se carga automáticamente al importar.
  // En versiones 0.6.0+, applyWorkaroundToOpenSqliteOnOldAndroidVersions() fue removido.
  // El import del paquete es suficiente para garantizar que libsqlite3.so se empaquete correctamente.

  // Inicializar localización en español
  await initializeDateFormatting('es', null);

  // Barra de sistema transparente (edge-to-edge)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  runApp(
    const ProviderScope(
      child: FinanzasApp(),
    ),
  );
}
