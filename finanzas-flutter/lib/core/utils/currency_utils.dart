import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/currency_provider.dart';

const _kPreferredRateKey = 'preferred_conversion_rate';

/// Which dollar rate to use for converting USD → ARS (default: blue)
final preferredConversionRateProvider =
    StateNotifierProvider<_PreferredRateNotifier, String>((ref) {
  return _PreferredRateNotifier();
});

class _PreferredRateNotifier extends StateNotifier<String> {
  _PreferredRateNotifier() : super('blue') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString(_kPreferredRateKey) ?? 'blue';
  }

  Future<void> set(String value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPreferredRateKey, value);
  }
}

/// Converts an amount from a foreign currency to ARS using fetched rates.
/// Returns null if rates are unavailable.
double? convertToArs({
  required double amount,
  required String fromCurrency,
  required List<CurrencyRate> rates,
  required String preferredRate,
}) {
  if (fromCurrency == 'ARS') return amount;

  // For USD-based currencies, use the preferred rate
  if (fromCurrency == 'USD') {
    final rate = rates
        .where((r) => r.casa == preferredRate)
        .firstOrNull;
    if (rate == null || rate.venta == 0) return null;
    return amount * rate.venta;
  }

  // For EUR/BRL, estimate via USD (rough but functional)
  // EUR ≈ 1.08 USD, BRL ≈ 0.18 USD (approximate fixed multipliers)
  final usdRate = rates
      .where((r) => r.casa == preferredRate)
      .firstOrNull;
  if (usdRate == null || usdRate.venta == 0) return null;

  final toUsd = switch (fromCurrency) {
    'EUR' => amount * 1.08,
    'BRL' => amount * 0.18,
    _ => null,
  };
  if (toUsd == null) return null;
  return toUsd * usdRate.venta;
}
