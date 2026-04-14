import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notification_listener_service/notification_event.dart';
import 'package:notification_listener_service/notification_listener_service.dart';
import '../logic/notification_expense_parser.dart';
import '../providers/feedback_provider.dart';

// ── Prefs keys ──
const _kAutoDetectEnabled = 'notif_auto_detect_enabled';

// ── Notification ID for detected expenses ──
const _kDetectedExpenseBaseId = 5000;
int _detectedExpenseCounter = 0;

/// Provider for the toggle
final autoDetectExpensesProvider =
    StateNotifierProvider<BoolPrefNotifier, bool>(
  (ref) => BoolPrefNotifier(_kAutoDetectEnabled, defaultValue: false),
);

/// Stream of detected expenses from financial app notifications.
final detectedExpenseProvider =
    StateNotifierProvider<DetectedExpenseNotifier, ParsedExpense?>(
  (ref) => DetectedExpenseNotifier(),
);

class DetectedExpenseNotifier extends StateNotifier<ParsedExpense?> {
  DetectedExpenseNotifier() : super(null);

  void set(ParsedExpense expense) => state = expense;
  void clear() => state = null;
}

/// Service that listens to system notifications from financial apps
/// and suggests recording them as expenses.
class ExpenseDetectorService {
  StreamSubscription? _subscription;
  final FlutterLocalNotificationsPlugin _notifPlugin;

  ExpenseDetectorService(this._notifPlugin);

  /// Check if notification listener permission is granted.
  static Future<bool> hasPermission() async {
    if (!Platform.isAndroid) return false;
    return await NotificationListenerService.isPermissionGranted();
  }

  /// Request the notification listener permission (opens system settings).
  static Future<void> requestPermission() async {
    if (!Platform.isAndroid) return;
    await NotificationListenerService.requestPermission();
  }

  /// Start listening for financial notifications.
  void start({required void Function(ParsedExpense) onExpenseDetected}) {
    if (!Platform.isAndroid) return;

    _subscription?.cancel();
    _subscription = NotificationListenerService.notificationsStream.listen(
      (ServiceNotificationEvent event) {
        final packageName = event.packageName;
        if (packageName == null) return;
        if (!NotificationExpenseParser.isFinancialApp(packageName)) return;

        final parsed = NotificationExpenseParser.parse(
          packageName: packageName,
          title: event.title,
          text: event.content,
        );

        if (parsed != null) {
          onExpenseDetected(parsed);
          _showSuggestionNotification(parsed);
        }
      },
    );
  }

  /// Stop listening.
  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Show a local notification suggesting to record the detected expense.
  Future<void> _showSuggestionNotification(ParsedExpense expense) async {
    final id = _kDetectedExpenseBaseId + (_detectedExpenseCounter++ % 100);
    final formatted = expense.amount.toStringAsFixed(
        expense.amount.truncateToDouble() == expense.amount ? 0 : 2);

    await _notifPlugin.show(
      id,
      '${expense.appName}: \$$formatted',
      '¿Registrar "${expense.description}" como gasto?',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'expense_detection',
          'Gastos detectados',
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          color: Color(0xFF6C63FF),
          actions: [
            AndroidNotificationAction(
              'record_detected',
              'Registrar',
              showsUserInterface: true,
            ),
            AndroidNotificationAction(
              'dismiss_detected',
              'Ignorar',
              cancelNotification: true,
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider for the expense detector service.
final expenseDetectorServiceProvider = Provider<ExpenseDetectorService>((ref) {
  return ExpenseDetectorService(
    FlutterLocalNotificationsPlugin(),
  );
});
