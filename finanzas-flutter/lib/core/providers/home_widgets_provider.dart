import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All available home widgets with display info
const kHomeWidgets = {
  'balance':     (label: 'Balance general',      icon: Icons.account_balance_wallet_rounded),
  'spending':    (label: 'Gastos del día',        icon: Icons.calendar_today_rounded),
  'currency':    (label: 'Cotizaciones',          icon: Icons.currency_exchange_rounded),
  'crypto':      (label: 'Criptomonedas',         icon: Icons.currency_bitcoin_rounded),
  'stocks':      (label: 'Acciones',              icon: Icons.show_chart_rounded),
  'alerts':      (label: 'Alertas',               icon: Icons.warning_rounded),
  'debts':       (label: 'Deudas pendientes',     icon: Icons.people_outline_rounded),
  'accounts':    (label: 'Mis cuentas',           icon: Icons.credit_card_rounded),
  'mp':          (label: 'Mercado Pago',          icon: Icons.account_balance_outlined),
  'transactions':(label: 'Últimos movimientos',   icon: Icons.receipt_long_rounded),
};

/// Default widget order (all visible)
const kDefaultHomeWidgets = [
  'balance', 'spending', 'currency', 'crypto', 'stocks',
  'alerts', 'debts', 'accounts', 'mp', 'transactions',
];

/// Widgets that are always visible and can't be hidden
const kAlwaysVisibleWidgets = {'balance', 'transactions'};

const _prefsOrderKey = 'home_widgets_order';
const _prefsHiddenKey = 'home_widgets_hidden';

/// Stores the order AND visibility of home widgets
class HomeWidgetConfig {
  final List<String> order;     // all widget IDs in display order
  final Set<String> hidden;     // IDs of hidden widgets

  const HomeWidgetConfig({
    required this.order,
    required this.hidden,
  });

  List<String> get visibleWidgets =>
      order.where((id) => !hidden.contains(id)).toList();

  bool isVisible(String id) => !hidden.contains(id);
}

final homeWidgetConfigProvider =
    StateNotifierProvider<HomeWidgetConfigNotifier, HomeWidgetConfig>((ref) {
  return HomeWidgetConfigNotifier();
});

class HomeWidgetConfigNotifier extends StateNotifier<HomeWidgetConfig> {
  HomeWidgetConfigNotifier()
      : super(HomeWidgetConfig(
            order: List.from(kDefaultHomeWidgets),
            hidden: const {})) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedOrder = prefs.getStringList(_prefsOrderKey);
    final savedHidden = prefs.getStringList(_prefsHiddenKey);

    // Merge saved with defaults (add new widgets that weren't saved)
    final order = <String>[];
    if (savedOrder != null) {
      for (final id in savedOrder) {
        if (kHomeWidgets.containsKey(id)) order.add(id);
      }
      // Add any new widgets not in saved order
      for (final id in kDefaultHomeWidgets) {
        if (!order.contains(id)) order.add(id);
      }
    } else {
      order.addAll(kDefaultHomeWidgets);
    }

    final hidden = savedHidden?.toSet() ?? {};
    // Ensure always-visible widgets are not hidden
    hidden.removeAll(kAlwaysVisibleWidgets);

    state = HomeWidgetConfig(order: order, hidden: hidden);
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsOrderKey, state.order);
    await prefs.setStringList(_prefsHiddenKey, state.hidden.toList());
  }

  void setOrder(List<String> newOrder) {
    state = HomeWidgetConfig(order: newOrder, hidden: state.hidden);
    _save();
  }

  void toggleVisibility(String id) {
    if (kAlwaysVisibleWidgets.contains(id)) return;
    final hidden = Set<String>.from(state.hidden);
    if (hidden.contains(id)) {
      hidden.remove(id);
    } else {
      hidden.add(id);
    }
    state = HomeWidgetConfig(order: state.order, hidden: hidden);
    _save();
  }

  void reset() {
    state = HomeWidgetConfig(
      order: List.from(kDefaultHomeWidgets),
      hidden: const {},
    );
    _save();
  }
}
