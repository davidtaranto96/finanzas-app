import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Estado global de búsqueda en la pestaña de Movimientos
final txSearchActiveProvider = StateProvider<bool>((ref) => false);
final txSearchQueryProvider = StateProvider<String>((ref) => '');
