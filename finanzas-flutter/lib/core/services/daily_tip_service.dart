import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// B8: Tips rotativos del día que se muestran en un banner dismissible del Home.
///
/// Cada día aparece un tip distinto (seleccionado por índice day-of-year % length).
/// El usuario puede descartar el banner con la X y no se vuelve a mostrar ese día.
class DailyTip {
  final String emoji;
  final String title;
  final String body;
  const DailyTip(this.emoji, this.title, this.body);
}

const List<DailyTip> kDailyTips = [
  DailyTip('🎤', 'Voz directa',
      'Mantené apretado el botón + para abrir el dictado sin tocar menú.'),
  DailyTip('🧠', 'IA + contexto',
      'Decí "dividí 5000 de pizza con Juan" y la IA crea el gasto + la deuda en 1 paso.'),
  DailyTip('🔁', 'Duplicar gasto',
      'Tocá 2 veces una transacción para duplicarla — ideal para gastos recurrentes.'),
  DailyTip('🍕', 'Emoji = categoría',
      'Empezá tu gasto con 🍕 o 🚗 y ya se asigna la categoría correcta.'),
  DailyTip('📷', 'Escaneá tickets',
      'Sacá foto del ticket y la IA extrae total, comercio y categoría.'),
  DailyTip('💳', 'Resumen PDF',
      'Subí el PDF de tu tarjeta y los gastos se cargan solos.'),
  DailyTip('📊', 'Presupuestos alerta',
      'Cuando cruzás 80% de un presupuesto, te avisamos al cargar el gasto.'),
  DailyTip('🏠', 'Widget en el home',
      'Poné el widget Gastos en tu pantalla — ves el total + cargás con un tap.'),
  DailyTip('☁️', 'Backup automático',
      'Con Google conectado, tus datos se respaldan solos cada día.'),
  DailyTip('🔍', 'Deslizá para borrar',
      'En la lista de movimientos, deslizá ← una tx para eliminarla.'),
  DailyTip('🎯', 'Metas visuales',
      'Creá metas de ahorro — cada aporte te muestra progreso visual.'),
  DailyTip('👥', 'Deudas con amigos',
      'Registrá a tus amigos y te llevamos el saldo de quién debe a quién.'),
  DailyTip('💰', 'Cuentas múltiples',
      'Separá efectivo, débito, crédito y ahorros — cada una con su balance.'),
  DailyTip('📈', 'Cotizaciones live',
      'El Home te muestra Dólar Blue/Oficial/Tarjeta en tiempo real.'),
  DailyTip('🪙', 'Crypto y acciones',
      'Seguí BTC, ETH o tus acciones favoritas sin salir de la app.'),
  DailyTip('🔔', 'Recordatorio diario',
      'Elegí a qué hora te recordamos cargar tus gastos desde Ajustes.'),
  DailyTip('⚡', 'Gastos recurrentes',
      'Configurá alquiler, streaming y servicios — se cargan solos cada mes.'),
  DailyTip('🎁', 'Wishlist',
      'Anotá lo que querés comprar con precio + prioridad y decidí mejor.'),
  DailyTip('📅', 'Cierres de tarjeta',
      'Te avisamos 5 días antes de cada cierre para que planifiques.'),
  DailyTip('🧮', 'Resumen del mes',
      'Mirá la pestaña "Resumen" para ver tu mes en barras + categorías.'),
  DailyTip('🤫', 'Deshacer',
      'Si te equivocás al cargar, tocá "Deshacer" en la barra verde (8 seg).'),
];

const _dismissedKey = 'daily_tip_dismissed_day';

/// Provider del tip del día. Devuelve null si el usuario ya lo descartó hoy.
final dailyTipProvider = FutureProvider<DailyTip?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final today = _todayKey();
  final dismissedDay = prefs.getString(_dismissedKey);
  if (dismissedDay == today) return null;

  // Tip determinístico por día del año (mismo tip todo el día, rota día a día)
  final dayOfYear = _dayOfYear(DateTime.now());
  return kDailyTips[dayOfYear % kDailyTips.length];
});

/// Descartar el tip del día. No se muestra más hoy.
Future<void> dismissTodaysTip(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_dismissedKey, _todayKey());
  ref.invalidate(dailyTipProvider);
}

String _todayKey() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
}

int _dayOfYear(DateTime date) {
  return date.difference(DateTime(date.year)).inDays;
}
