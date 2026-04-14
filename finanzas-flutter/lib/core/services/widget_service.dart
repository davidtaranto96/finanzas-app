import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../database/app_database.dart';
import '../database/database_providers.dart' show databaseProvider;
import '../providers/currency_provider.dart';
import '../providers/crypto_provider.dart';
import '../providers/stocks_provider.dart';

const _kInfoWidgetAndroid = 'ExpenseInfoWidgetProvider';
const _kQuickWidgetAndroid = 'QuickExpenseWidgetProvider';
const _kDollarWidgetAndroid = 'DollarRateWidgetProvider';
const _kCryptoWidgetAndroid = 'CryptoWidgetProvider';
const _kStocksWidgetAndroid = 'StocksWidgetProvider';

final widgetServiceProvider = Provider<WidgetService>((ref) {
  final db = ref.watch(databaseProvider);
  return WidgetService(db, ref);
});

class WidgetService {
  final AppDatabase _db;
  final Ref _ref;

  WidgetService(this._db, this._ref);

  /// Refrescar todos los widgets con datos frescos.
  Future<void> refresh() async {
    if (!Platform.isAndroid) return;

    await _refreshExpenseWidgets();
    await _refreshDollarWidget();
    await _refreshCryptoWidget();
    await _refreshStocksWidget();
  }

  // ─── Gastos del mes ─────────────────────────────

  Future<void> _refreshExpenseWidgets() async {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    // Semana = últimos 7 días completos (incluye hoy)
    final startOfWeek = startOfToday.subtract(const Duration(days: 6));
    final startOfMonth = DateTime(now.year, now.month);
    final endOfMonth = DateTime(now.year, now.month + 1);

    final allTxs = await (_db.select(_db.transactionsTable)
          ..where((t) => t.type.equals('expense')))
        .get();

    double sumIn(Iterable<TransactionEntity> rows) =>
        rows.fold(0.0, (s, t) => s + t.amount);

    final todayRows =
        allTxs.where((t) => !t.date.isBefore(startOfToday)).toList();
    final weekRows =
        allTxs.where((t) => !t.date.isBefore(startOfWeek)).toList();
    final monthRows = allTxs
        .where((t) =>
            !t.date.isBefore(startOfMonth) && t.date.isBefore(endOfMonth))
        .toList();

    final todayTotal = sumIn(todayRows);
    final weekTotal = sumIn(weekRows);
    final monthTotal = sumIn(monthRows);

    String subtitleFor(String scope, int count) {
      if (count == 0) return 'Sin gastos $scope';
      return '$count gasto${count == 1 ? '' : 's'} $scope';
    }

    await HomeWidget.saveWidgetData('expense_today', _formatCurrency(todayTotal));
    await HomeWidget.saveWidgetData('expense_week', _formatCurrency(weekTotal));
    await HomeWidget.saveWidgetData('expense_month', _formatCurrency(monthTotal));

    await HomeWidget.saveWidgetData(
        'expense_today_count', subtitleFor('hoy', todayRows.length));
    await HomeWidget.saveWidgetData(
        'expense_week_count', subtitleFor('en la semana', weekRows.length));
    await HomeWidget.saveWidgetData(
        'expense_month_count', subtitleFor('este mes', monthRows.length));

    // Legacy keys (mantenidos por retrocompatibilidad)
    await HomeWidget.saveWidgetData('monthly_expense', _formatCurrency(monthTotal));
    await HomeWidget.saveWidgetData(
      'widget_subtitle',
      subtitleFor('este mes', monthRows.length),
    );

    await HomeWidget.updateWidget(androidName: _kInfoWidgetAndroid);
    await HomeWidget.updateWidget(androidName: _kQuickWidgetAndroid);
  }

  // ─── Cotización dólar ───────────────────────────

  Future<void> _refreshDollarWidget() async {
    try {
      final rates = await _ref.read(currencyRatesProvider.future);
      if (rates.isEmpty) return;
      // Preferir Blue, si no hay tomar el primero
      final blue = rates.firstWhere(
        (r) => r.casa == 'blue',
        orElse: () => rates.first,
      );
      final oficial = rates.firstWhere(
        (r) => r.casa == 'oficial',
        orElse: () => blue,
      );
      final tarjeta = rates.firstWhere(
        (r) => r.casa == 'tarjeta',
        orElse: () => oficial,
      );
      await HomeWidget.saveWidgetData('dollar_label', 'Dólar Blue');
      await HomeWidget.saveWidgetData(
          'dollar_venta', '\$${blue.venta.toStringAsFixed(0)}');
      await HomeWidget.saveWidgetData(
          'dollar_compra', 'compra \$${blue.compra.toStringAsFixed(0)}');
      await HomeWidget.saveWidgetData(
          'dollar_oficial', '\$${oficial.venta.toStringAsFixed(0)}');
      await HomeWidget.saveWidgetData(
          'dollar_tarjeta', '\$${tarjeta.venta.toStringAsFixed(0)}');
      await HomeWidget.updateWidget(androidName: _kDollarWidgetAndroid);
    } catch (_) {
      // Sin red → dejamos el último valor guardado
    }
  }

  // ─── Crypto ─────────────────────────────────────

  Future<void> _refreshCryptoWidget() async {
    try {
      final selected = _ref.read(selectedCryptosProvider);
      if (selected.isEmpty) return;
      final prices = await _ref.read(cryptoPricesProvider.future);
      if (prices.isEmpty) return;

      // Save up to 5 slots so the widget can cycle through them via prev/next
      final top = prices.take(5).toList();
      await HomeWidget.saveWidgetData('crypto_count', top.length.toString());
      for (var i = 0; i < top.length; i++) {
        final p = top[i];
        final changeStr =
            '${p.change24h >= 0 ? '+' : ''}${p.change24h.toStringAsFixed(2)}%';
        await HomeWidget.saveWidgetData('crypto_symbol_$i', p.symbol);
        await HomeWidget.saveWidgetData('crypto_name_$i', p.name);
        await HomeWidget.saveWidgetData(
            'crypto_price_$i', 'US\$${_formatPrice(p.priceUsd)}');
        await HomeWidget.saveWidgetData('crypto_change_$i', changeStr);
        await HomeWidget.saveWidgetData(
            'crypto_change_positive_$i', p.change24h >= 0 ? '1' : '0');
      }

      // Legacy keys (fallback)
      final first = top.first;
      final changeStr =
          '${first.change24h >= 0 ? '+' : ''}${first.change24h.toStringAsFixed(2)}%';
      await HomeWidget.saveWidgetData('crypto_symbol', first.symbol);
      await HomeWidget.saveWidgetData('crypto_name', first.name);
      await HomeWidget.saveWidgetData(
          'crypto_price', 'US\$${_formatPrice(first.priceUsd)}');
      await HomeWidget.saveWidgetData('crypto_change', changeStr);
      await HomeWidget.saveWidgetData(
          'crypto_change_positive', first.change24h >= 0 ? '1' : '0');

      await HomeWidget.updateWidget(androidName: _kCryptoWidgetAndroid);
    } catch (_) {}
  }

  // ─── Acciones ───────────────────────────────────

  Future<void> _refreshStocksWidget() async {
    try {
      final selected = _ref.read(selectedStocksProvider);
      if (selected.isEmpty) return;
      final prices = await _ref.read(stockPricesProvider.future);
      if (prices.isEmpty) return;

      final top = prices.take(5).toList();
      await HomeWidget.saveWidgetData('stock_count', top.length.toString());
      for (var i = 0; i < top.length; i++) {
        final p = top[i];
        final meta = kAvailableStocks[p.symbol];
        final changeStr =
            '${p.changePercent >= 0 ? '+' : ''}${p.changePercent.toStringAsFixed(2)}%';
        await HomeWidget.saveWidgetData('stock_symbol_$i', p.symbol);
        await HomeWidget.saveWidgetData('stock_name_$i', meta?.$2 ?? p.name);
        await HomeWidget.saveWidgetData(
            'stock_price_$i',
            '${p.currency == 'USD' ? 'US\$' : '\$'}${_formatPrice(p.price)}');
        await HomeWidget.saveWidgetData('stock_change_$i', changeStr);
        await HomeWidget.saveWidgetData(
            'stock_change_positive_$i', p.changePercent >= 0 ? '1' : '0');
      }

      final first = top.first;
      final meta = kAvailableStocks[first.symbol];
      final changeStr =
          '${first.changePercent >= 0 ? '+' : ''}${first.changePercent.toStringAsFixed(2)}%';
      await HomeWidget.saveWidgetData('stock_symbol', first.symbol);
      await HomeWidget.saveWidgetData('stock_name', meta?.$2 ?? first.name);
      await HomeWidget.saveWidgetData(
          'stock_price',
          '${first.currency == 'USD' ? 'US\$' : '\$'}${_formatPrice(first.price)}');
      await HomeWidget.saveWidgetData('stock_change', changeStr);
      await HomeWidget.saveWidgetData(
          'stock_change_positive', first.changePercent >= 0 ? '1' : '0');

      await HomeWidget.updateWidget(androidName: _kStocksWidgetAndroid);
    } catch (_) {}
  }

  // ─── Helpers ────────────────────────────────────

  String _formatCurrency(double amount) {
    if (amount == 0) return '\$0';
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '\$${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  String _formatPrice(double amount) {
    if (amount >= 10000) return amount.toStringAsFixed(0);
    if (amount >= 100) return amount.toStringAsFixed(1);
    if (amount >= 1) return amount.toStringAsFixed(2);
    return amount.toStringAsFixed(4);
  }
}
