import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/app_database.dart';
import '../database/database_providers.dart' show databaseProvider;
import '../providers/feedback_provider.dart';

// ── Notification IDs ──
const _kCardDueChannel = 'card_due_dates';
const _kDebtReminderChannel = 'debt_reminders';
const _kGeneralChannel = 'general';

// Notification ID ranges
const _kCardDueBaseId = 1000;
const _kDebtReminderBaseId = 2000;

// Prefs keys
const _kNotifCardDueEnabled = 'notif_card_due_enabled';
const _kNotifDebtRemindEnabled = 'notif_debt_remind_enabled';
const _kNotifCardDueDaysBefore = 'notif_card_due_days_before';
const _kNotifDebtRemindDays = 'notif_debt_remind_days';

/// Global plugin instance
final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

/// Provider for the notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final db = ref.watch(databaseProvider);
  return NotificationService(db);
});

/// Settings providers
final notifCardDueEnabledProvider =
    StateNotifierProvider<BoolPrefNotifier, bool>(
  (ref) => BoolPrefNotifier(_kNotifCardDueEnabled, defaultValue: true),
);

final notifDebtRemindEnabledProvider =
    StateNotifierProvider<BoolPrefNotifier, bool>(
  (ref) => BoolPrefNotifier(_kNotifDebtRemindEnabled, defaultValue: true),
);

final notifCardDueDaysBeforeProvider =
    StateNotifierProvider<IntPrefNotifier, int>(
  (ref) => IntPrefNotifier(_kNotifCardDueDaysBefore, defaultValue: 3),
);

final notifDebtRemindDaysProvider =
    StateNotifierProvider<IntPrefNotifier, int>(
  (ref) => IntPrefNotifier(_kNotifDebtRemindDays, defaultValue: 7),
);

/// Int-backed pref notifier
class IntPrefNotifier extends StateNotifier<int> {
  final String key;
  IntPrefNotifier(this.key, {int defaultValue = 0}) : super(defaultValue) {
    _load();
  }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getInt(key) ?? state;
  }
  Future<void> set(int value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, state);
  }
}

/// In-app notification model (for the notification center)
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'card_due', 'debt_remind', 'general'
  final DateTime createdAt;
  final bool read;
  final String? relatedId; // accountId or personId

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.read = false,
    this.relatedId,
  });

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        createdAt: createdAt,
        read: read ?? this.read,
        relatedId: relatedId,
      );
}

/// In-app notification center state
final notificationCenterProvider =
    StateNotifierProvider<NotificationCenterNotifier, List<AppNotification>>(
  (ref) => NotificationCenterNotifier(),
);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationCenterProvider);
  return notifications.where((n) => !n.read).length;
});

class NotificationCenterNotifier extends StateNotifier<List<AppNotification>> {
  NotificationCenterNotifier() : super([]);

  void add(AppNotification notification) {
    state = [notification, ...state];
    // Keep max 50 notifications
    if (state.length > 50) {
      state = state.sublist(0, 50);
    }
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(read: true) else n,
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(read: true)];
  }

  void remove(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void clear() {
    state = [];
  }
}

class NotificationService {
  final AppDatabase _db;

  NotificationService(this._db);

  /// Initialize the notification plugin
  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    // Create notification channels on Android
    if (Platform.isAndroid) {
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _kCardDueChannel,
            'Vencimientos de tarjetas',
            description: 'Recordatorios de fechas de cierre y vencimiento',
            importance: Importance.high,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _kDebtReminderChannel,
            'Recordatorios de deudas',
            description: 'Recordatorios de deudas pendientes con amigos',
            importance: Importance.defaultImportance,
          ),
        );
        await androidPlugin.createNotificationChannel(
          const AndroidNotificationChannel(
            _kGeneralChannel,
            'General',
            description: 'Notificaciones generales de Sencillo',
            importance: Importance.defaultImportance,
          ),
        );
      }
    }
  }

  /// Request notification permissions (Android 13+, iOS)
  static Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final iosPlugin =
          _plugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  /// Schedule card due date reminders based on closing days
  Future<void> scheduleCardDueReminders({
    required int daysBefore,
  }) async {
    // Cancel existing card reminders
    await cancelCardDueReminders();

    final accounts = await _db.select(_db.accountsTable).get();
    final creditCards = accounts.where(
      (a) => a.type == 'credit' && a.closingDay != null,
    );

    int idx = 0;
    for (final card in creditCards) {
      final closingDay = card.closingDay!;
      final now = DateTime.now();

      // Calculate next closing date
      DateTime nextClosing;
      if (now.day <= closingDay) {
        nextClosing = DateTime(now.year, now.month, closingDay);
      } else {
        final nextMonth = now.month == 12 ? 1 : now.month + 1;
        final nextYear = now.month == 12 ? now.year + 1 : now.year;
        nextClosing = DateTime(nextYear, nextMonth, closingDay);
      }

      // Schedule reminder X days before closing
      final reminderDate = nextClosing.subtract(Duration(days: daysBefore));
      if (reminderDate.isAfter(now)) {
        final scheduledDate = tz.TZDateTime.from(
          DateTime(reminderDate.year, reminderDate.month, reminderDate.day, 10, 0),
          tz.local,
        );

        await _plugin.zonedSchedule(
          _kCardDueBaseId + idx,
          '💳 Vencimiento próximo',
          '${card.name} cierra en $daysBefore días (día $closingDay)',
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _kCardDueChannel,
              'Vencimientos de tarjetas',
              icon: '@mipmap/ic_launcher',
              importance: Importance.high,
              priority: Priority.high,
              color: const Color(0xFF6C63FF),
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        );
      }
      idx++;
    }
  }

  /// Schedule debt reminders for people who owe money
  Future<void> scheduleDebtReminders({
    required int everyDays,
  }) async {
    // Cancel existing debt reminders
    await cancelDebtReminders();

    final persons = await _db.select(_db.personsTable).get();
    final withDebt = persons.where((p) => p.totalBalance.abs() > 0);

    int idx = 0;
    for (final person in withDebt) {
      final now = DateTime.now();
      final reminderDate = now.add(Duration(days: everyDays));
      final scheduledDate = tz.TZDateTime.from(
        DateTime(reminderDate.year, reminderDate.month, reminderDate.day, 11, 0),
        tz.local,
      );

      final owesMe = person.totalBalance > 0;
      final amount = person.totalBalance.abs();
      final amountStr = '\$${amount.toStringAsFixed(0)}';

      await _plugin.zonedSchedule(
        _kDebtReminderBaseId + idx,
        owesMe ? '🔔 Te deben plata' : '🔔 Deuda pendiente',
        owesMe
            ? '${person.name} te debe $amountStr'
            : 'Le debés $amountStr a ${person.name}',
        scheduledDate,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _kDebtReminderChannel,
            'Recordatorios de deudas',
            icon: '@mipmap/ic_launcher',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            color: const Color(0xFF6C63FF),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      idx++;
    }
  }

  /// Show an immediate notification (for in-app events)
  static Future<void> showNow({
    required int id,
    required String title,
    required String body,
    String channel = _kGeneralChannel,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          channel == _kCardDueChannel
              ? 'Vencimientos de tarjetas'
              : channel == _kDebtReminderChannel
                  ? 'Recordatorios de deudas'
                  : 'General',
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          color: const Color(0xFF6C63FF),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<void> cancelCardDueReminders() async {
    for (int i = 0; i < 20; i++) {
      await _plugin.cancel(_kCardDueBaseId + i);
    }
  }

  Future<void> cancelDebtReminders() async {
    for (int i = 0; i < 100; i++) {
      await _plugin.cancel(_kDebtReminderBaseId + i);
    }
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Refresh all scheduled notifications based on current settings
  Future<void> refreshAll(WidgetRef ref) async {
    final cardDueEnabled = ref.read(notifCardDueEnabledProvider);
    final debtEnabled = ref.read(notifDebtRemindEnabledProvider);
    final cardDueDays = ref.read(notifCardDueDaysBeforeProvider);
    final debtDays = ref.read(notifDebtRemindDaysProvider);

    if (cardDueEnabled) {
      await scheduleCardDueReminders(daysBefore: cardDueDays);
    } else {
      await cancelCardDueReminders();
    }

    if (debtEnabled) {
      await scheduleDebtReminders(everyDays: debtDays);
    } else {
      await cancelDebtReminders();
    }
  }
}
