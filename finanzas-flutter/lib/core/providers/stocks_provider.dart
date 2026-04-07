import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Precio de acción/índice
class StockPrice {
  final String symbol;      // 'AAPL', 'GOOGL', 'MERVAL'
  final String name;        // 'Apple', 'Google', 'Merval'
  final double price;
  final double change;      // absolute change
  final double changePercent; // % change
  final String currency;    // 'USD' or 'ARS'

  const StockPrice({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    this.currency = 'USD',
  });
}

/// Acciones/índices disponibles para seguir
const kAvailableStocks = {
  'MERVAL':  ('📊', 'Merval',     'Índice'),
  'AAPL':    ('🍎', 'Apple',      'CEDEAR'),
  'GOOGL':   ('🔍', 'Google',     'CEDEAR'),
  'MSFT':    ('💻', 'Microsoft',  'CEDEAR'),
  'AMZN':    ('📦', 'Amazon',     'CEDEAR'),
  'TSLA':    ('🚗', 'Tesla',      'CEDEAR'),
  'MELI':    ('🛒', 'MercadoLibre', 'CEDEAR'),
  'META':    ('👤', 'Meta',       'CEDEAR'),
  'NVDA':    ('🎮', 'Nvidia',     'CEDEAR'),
  'GGAL':    ('🏦', 'Galicia',    'Acción'),
  'YPF':     ('⛽', 'YPF',        'Acción'),
};

const _defaultStocks = ['MERVAL', 'AAPL', 'MELI', 'GGAL'];
const _prefsKey = 'selected_stocks';

// ── Selected stocks preferences ──

final selectedStocksProvider =
    StateNotifierProvider<SelectedStocksNotifier, List<String>>((ref) {
  return SelectedStocksNotifier();
});

class SelectedStocksNotifier extends StateNotifier<List<String>> {
  SelectedStocksNotifier() : super(_defaultStocks) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  Future<void> toggle(String symbol) async {
    final current = List<String>.from(state);
    if (current.contains(symbol)) {
      if (current.length <= 1) return;
      current.remove(symbol);
    } else {
      current.add(symbol);
    }
    state = current;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, current);
  }
}

// ── Stock prices provider ──

const _cacheStocksKey = 'stock_prices_cache';
const _cacheStocksTsKey = 'stock_prices_timestamp';
const _cacheTtlMin = 10; // stocks update less frequently

final _stocksRefreshCounter = StateProvider<int>((ref) => 0);

final stockPricesProvider = FutureProvider.autoDispose<List<StockPrice>>((ref) {
  ref.watch(_stocksRefreshCounter);
  final selected = ref.watch(selectedStocksProvider);
  return _fetchStockPrices(selected);
});

void refreshStockPrices(WidgetRef ref) {
  _clearStocksCache();
  ref.read(_stocksRefreshCounter.notifier).state++;
}

Future<void> _clearStocksCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_cacheStocksKey);
  await prefs.remove(_cacheStocksTsKey);
}

Future<List<StockPrice>> _fetchStockPrices(List<String> symbols) async {
  if (symbols.isEmpty) return [];

  final prefs = await SharedPreferences.getInstance();

  // Cache check
  final tsStr = prefs.getString(_cacheStocksTsKey);
  if (tsStr != null) {
    final ts = DateTime.tryParse(tsStr);
    if (ts != null && DateTime.now().difference(ts).inMinutes < _cacheTtlMin) {
      final cached = prefs.getString(_cacheStocksKey);
      if (cached != null) {
        return _parseStockPrices(cached, symbols);
      }
    }
  }

  // Fetch from multiple sources
  final results = <StockPrice>[];

  // 1. Argentine stocks from dolarapi.com/v1/ambito/acciones
  try {
    final argRes = await http
        .get(Uri.parse('https://dolarapi.com/v1/ambito/acciones/merval'))
        .timeout(const Duration(seconds: 10));
    if (argRes.statusCode == 200) {
      final data = jsonDecode(argRes.body);
      if (data is Map<String, dynamic>) {
        final price = (data['valor'] as num?)?.toDouble() ?? (data['compra'] as num?)?.toDouble() ?? 0;
        final change = (data['variacion'] as num?)?.toDouble() ?? 0;
        if (price > 0 && symbols.contains('MERVAL')) {
          results.add(StockPrice(
            symbol: 'MERVAL',
            name: 'Merval',
            price: price,
            change: 0,
            changePercent: change,
            currency: 'ARS',
          ));
        }
      }
    }
  } catch (_) {}

  // 2. For international stocks: use a simple mock/static approach
  //    since free real-time stock APIs require keys
  //    We show the symbol + label from kAvailableStocks
  for (final sym in symbols) {
    if (sym == 'MERVAL') continue; // already handled
    if (!results.any((r) => r.symbol == sym)) {
      final info = kAvailableStocks[sym];
      if (info != null) {
        // Try fetching from alternative free source
        try {
          final ticker = sym.toLowerCase();
          final uri = Uri.parse(
            'https://query1.finance.yahoo.com/v8/finance/chart/$ticker?interval=1d&range=1d',
          );
          final res = await http.get(uri, headers: {
            'User-Agent': 'Mozilla/5.0',
          }).timeout(const Duration(seconds: 8));

          if (res.statusCode == 200) {
            final json = jsonDecode(res.body) as Map<String, dynamic>;
            final chart = json['chart']?['result']?[0] as Map<String, dynamic>?;
            if (chart != null) {
              final meta = chart['meta'] as Map<String, dynamic>?;
              final currentPrice = (meta?['regularMarketPrice'] as num?)?.toDouble() ?? 0;
              final prevClose = (meta?['previousClose'] as num?)?.toDouble() ?? 0;
              final diff = currentPrice - prevClose;
              final pct = prevClose > 0 ? (diff / prevClose * 100) : 0.0;

              results.add(StockPrice(
                symbol: sym,
                name: info.$2,
                price: currentPrice,
                change: diff,
                changePercent: pct,
                currency: meta?['currency'] as String? ?? 'USD',
              ));
              continue;
            }
          }
        } catch (_) {}

        // Fallback: show symbol with no price
        results.add(StockPrice(
          symbol: sym,
          name: info.$2,
          price: 0,
          change: 0,
          changePercent: 0,
        ));
      }
    }
  }

  // Cache results
  final cacheData = jsonEncode(results.map((r) => {
    'symbol': r.symbol,
    'name': r.name,
    'price': r.price,
    'change': r.change,
    'changePercent': r.changePercent,
    'currency': r.currency,
  }).toList());
  await prefs.setString(_cacheStocksKey, cacheData);
  await prefs.setString(_cacheStocksTsKey, DateTime.now().toIso8601String());

  // Sort by user preference
  results.sort((a, b) {
    final ai = symbols.indexOf(a.symbol);
    final bi = symbols.indexOf(b.symbol);
    return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
  });

  return results;
}

List<StockPrice> _parseStockPrices(String body, List<String> symbols) {
  final list = jsonDecode(body) as List<dynamic>;
  final results = list.map((e) {
    final json = e as Map<String, dynamic>;
    return StockPrice(
      symbol: json['symbol'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      change: (json['change'] as num?)?.toDouble() ?? 0,
      changePercent: (json['changePercent'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
    );
  }).toList();

  results.sort((a, b) {
    final ai = symbols.indexOf(a.symbol);
    final bi = symbols.indexOf(b.symbol);
    return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
  });

  return results;
}
