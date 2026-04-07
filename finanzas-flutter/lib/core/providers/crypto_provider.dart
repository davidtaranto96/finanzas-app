import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Precio de criptomoneda
class CryptoPrice {
  final String id;        // 'bitcoin', 'ethereum', etc.
  final String symbol;    // 'BTC', 'ETH'
  final String name;      // 'Bitcoin', 'Ethereum'
  final double priceUsd;
  final double change24h; // % cambio 24h
  final String? imageUrl;

  const CryptoPrice({
    required this.id,
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.change24h,
    this.imageUrl,
  });

  factory CryptoPrice.fromJson(Map<String, dynamic> json) {
    return CryptoPrice(
      id: json['id'] as String? ?? '',
      symbol: (json['symbol'] as String? ?? '').toUpperCase(),
      name: json['name'] as String? ?? '',
      priceUsd: (json['current_price'] as num?)?.toDouble() ?? 0,
      change24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image'] as String?,
    );
  }
}

/// Cryptos disponibles para seguir
const kAvailableCryptos = {
  'bitcoin':    ('₿', 'Bitcoin',   'BTC'),
  'ethereum':   ('Ξ', 'Ethereum',  'ETH'),
  'tether':     ('₮', 'Tether',    'USDT'),
  'solana':     ('◎', 'Solana',    'SOL'),
  'ripple':     ('✕', 'XRP',       'XRP'),
  'cardano':    ('₳', 'Cardano',   'ADA'),
  'dogecoin':   ('Ð', 'Dogecoin',  'DOGE'),
  'litecoin':   ('Ł', 'Litecoin',  'LTC'),
};

const _defaultCryptos = ['bitcoin', 'ethereum', 'tether', 'solana'];
const _prefsKey = 'selected_cryptos';

// ── Selected cryptos preferences ──

final selectedCryptosProvider =
    StateNotifierProvider<SelectedCryptosNotifier, List<String>>((ref) {
  return SelectedCryptosNotifier();
});

class SelectedCryptosNotifier extends StateNotifier<List<String>> {
  SelectedCryptosNotifier() : super(_defaultCryptos) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefsKey);
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  Future<void> toggle(String id) async {
    final current = List<String>.from(state);
    if (current.contains(id)) {
      if (current.length <= 1) return; // keep at least 1
      current.remove(id);
    } else {
      current.add(id);
    }
    state = current;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, current);
  }
}

// ── Crypto prices provider ──

const _cacheCryptoKey = 'crypto_prices_cache';
const _cacheCryptoTsKey = 'crypto_prices_timestamp';
const _cacheTtlMin = 5;

final _cryptoRefreshCounter = StateProvider<int>((ref) => 0);

final cryptoPricesProvider = FutureProvider.autoDispose<List<CryptoPrice>>((ref) {
  ref.watch(_cryptoRefreshCounter);
  final selected = ref.watch(selectedCryptosProvider);
  return _fetchCryptoPrices(selected);
});

void refreshCryptoPrices(WidgetRef ref) {
  _clearCryptoCache();
  ref.read(_cryptoRefreshCounter.notifier).state++;
}

Future<void> _clearCryptoCache() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_cacheCryptoKey);
  await prefs.remove(_cacheCryptoTsKey);
}

Future<List<CryptoPrice>> _fetchCryptoPrices(List<String> ids) async {
  if (ids.isEmpty) return [];

  final prefs = await SharedPreferences.getInstance();

  // Cache check
  final tsStr = prefs.getString(_cacheCryptoTsKey);
  if (tsStr != null) {
    final ts = DateTime.tryParse(tsStr);
    if (ts != null && DateTime.now().difference(ts).inMinutes < _cacheTtlMin) {
      final cached = prefs.getString(_cacheCryptoKey);
      if (cached != null) {
        return _parseCryptoRates(cached, ids);
      }
    }
  }

  // Fetch from CoinGecko (free, no auth)
  final idsParam = ids.join(',');
  final uri = Uri.parse(
    'https://api.coingecko.com/api/v3/coins/markets'
    '?vs_currency=usd&ids=$idsParam&order=market_cap_desc'
    '&per_page=${ids.length}&page=1&sparkline=false'
    '&price_change_percentage=24h',
  );

  final response = await http.get(uri).timeout(const Duration(seconds: 15));
  if (response.statusCode != 200) {
    throw Exception('CoinGecko HTTP ${response.statusCode}');
  }

  await prefs.setString(_cacheCryptoKey, response.body);
  await prefs.setString(_cacheCryptoTsKey, DateTime.now().toIso8601String());

  return _parseCryptoRates(response.body, ids);
}

List<CryptoPrice> _parseCryptoRates(String body, List<String> ids) {
  final list = jsonDecode(body) as List<dynamic>;
  final prices = list
      .map((e) => CryptoPrice.fromJson(e as Map<String, dynamic>))
      .toList();

  // Sort by user's preferred order
  prices.sort((a, b) {
    final ai = ids.indexOf(a.id);
    final bi = ids.indexOf(b.id);
    return (ai == -1 ? 999 : ai).compareTo(bi == -1 ? 999 : bi);
  });

  return prices;
}
