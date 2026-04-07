import 'package:flutter_test/flutter_test.dart';
import 'package:sencillo/core/providers/currency_provider.dart';
import 'package:sencillo/core/utils/currency_utils.dart';

void main() {
  final mockRates = [
    CurrencyRate(
      casa: 'blue',
      label: 'Blue',
      compra: 1300,
      venta: 1350,
      updatedAt: DateTime.now(),
    ),
    CurrencyRate(
      casa: 'oficial',
      label: 'Oficial',
      compra: 1000,
      venta: 1060,
      updatedAt: DateTime.now(),
    ),
    CurrencyRate(
      casa: 'mep',
      label: 'MEP',
      compra: 1250,
      venta: 1280,
      updatedAt: DateTime.now(),
    ),
  ];

  group('convertToArs', () {
    test('ARS returns same amount', () {
      final result = convertToArs(
        amount: 1000,
        fromCurrency: 'ARS',
        rates: mockRates,
        preferredRate: 'blue',
      );
      expect(result, 1000);
    });

    test('USD converts using blue rate', () {
      final result = convertToArs(
        amount: 100,
        fromCurrency: 'USD',
        rates: mockRates,
        preferredRate: 'blue',
      );
      expect(result, 100 * 1350); // 100 * venta blue
    });

    test('USD converts using oficial rate', () {
      final result = convertToArs(
        amount: 100,
        fromCurrency: 'USD',
        rates: mockRates,
        preferredRate: 'oficial',
      );
      expect(result, 100 * 1060);
    });

    test('USD converts using mep rate', () {
      final result = convertToArs(
        amount: 50,
        fromCurrency: 'USD',
        rates: mockRates,
        preferredRate: 'mep',
      );
      expect(result, 50 * 1280);
    });

    test('EUR estimates via USD', () {
      final result = convertToArs(
        amount: 100,
        fromCurrency: 'EUR',
        rates: mockRates,
        preferredRate: 'blue',
      );
      // EUR ≈ 1.08 USD, then * venta blue
      expect(result, closeTo(100 * 1.08 * 1350, 1));
    });

    test('BRL estimates via USD', () {
      final result = convertToArs(
        amount: 1000,
        fromCurrency: 'BRL',
        rates: mockRates,
        preferredRate: 'blue',
      );
      expect(result, closeTo(1000 * 0.18 * 1350, 1));
    });

    test('unknown currency returns null', () {
      final result = convertToArs(
        amount: 100,
        fromCurrency: 'GBP',
        rates: mockRates,
        preferredRate: 'blue',
      );
      expect(result, isNull);
    });

    test('empty rates returns null for USD', () {
      final result = convertToArs(
        amount: 100,
        fromCurrency: 'USD',
        rates: [],
        preferredRate: 'blue',
      );
      expect(result, isNull);
    });
  });
}
