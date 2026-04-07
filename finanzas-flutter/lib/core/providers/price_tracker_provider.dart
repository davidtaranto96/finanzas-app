import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/meli_price_service.dart';
import '../../features/wishlist/domain/models/wishlist_item.dart';

/// A single price data point for a wishlist item.
class PriceEntry {
  final double price;
  final DateTime date;
  final String? source; // 'manual', 'meli'

  const PriceEntry({required this.price, required this.date, this.source});

  Map<String, dynamic> toJson() => {
    'price': price,
    'date': date.toIso8601String(),
    'source': source,
  };

  factory PriceEntry.fromJson(Map<String, dynamic> json) => PriceEntry(
    price: (json['price'] as num).toDouble(),
    date: DateTime.parse(json['date'] as String),
    source: json['source'] as String?,
  );
}

/// Price history for a wishlist item.
class PriceHistory {
  final String itemId;
  final List<PriceEntry> entries;

  const PriceHistory({required this.itemId, this.entries = const []});

  double? get latestPrice => entries.isNotEmpty ? entries.last.price : null;
  double? get lowestPrice => entries.isNotEmpty
      ? entries.map((e) => e.price).reduce((a, b) => a < b ? a : b)
      : null;
  double? get highestPrice => entries.isNotEmpty
      ? entries.map((e) => e.price).reduce((a, b) => a > b ? a : b)
      : null;

  /// Price trend: negative = dropped, positive = increased, null = no data.
  double? get trend {
    if (entries.length < 2) return null;
    return entries.last.price - entries[entries.length - 2].price;
  }

  bool get hasDrop {
    if (entries.length < 2) return false;
    return entries.last.price < entries[entries.length - 2].price;
  }
}

/// Items that had a price drop during the last auto-check.
class PriceDropAlert {
  final String itemId;
  final String itemTitle;
  final double oldPrice;
  final double newPrice;

  const PriceDropAlert({
    required this.itemId,
    required this.itemTitle,
    required this.oldPrice,
    required this.newPrice,
  });

  double get savings => oldPrice - newPrice;
  double get percent => oldPrice > 0 ? (savings / oldPrice * 100) : 0;
}

const _storageKey = 'price_tracker_data';
const _lastAutoCheckKey = 'price_tracker_last_auto_check';
const _autoCheckCooldownHours = 6;

class PriceTrackerNotifier extends StateNotifier<Map<String, PriceHistory>> {
  PriceTrackerNotifier() : super({}) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null) return;
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final result = <String, PriceHistory>{};
    for (final entry in map.entries) {
      final list = (entry.value as List<dynamic>)
          .map((e) => PriceEntry.fromJson(e as Map<String, dynamic>))
          .toList();
      result[entry.key] = PriceHistory(itemId: entry.key, entries: list);
    }
    state = result;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final map = <String, dynamic>{};
    for (final entry in state.entries) {
      map[entry.key] = entry.value.entries.map((e) => e.toJson()).toList();
    }
    await prefs.setString(_storageKey, jsonEncode(map));
  }

  /// Log a new price for a wishlist item.
  Future<void> logPrice(String itemId, double price, {String? source}) async {
    final current = state[itemId] ?? PriceHistory(itemId: itemId);
    final newEntries = [
      ...current.entries,
      PriceEntry(price: price, date: DateTime.now(), source: source ?? 'manual'),
    ];
    // Keep last 30 entries per item
    final trimmed = newEntries.length > 30
        ? newEntries.sublist(newEntries.length - 30)
        : newEntries;

    state = {
      ...state,
      itemId: PriceHistory(itemId: itemId, entries: trimmed),
    };
    await _save();
  }

  /// Get price history for a single item.
  PriceHistory? getHistory(String itemId) => state[itemId];

  /// Remove price history for an item.
  Future<void> clearHistory(String itemId) async {
    final newState = Map<String, PriceHistory>.from(state);
    newState.remove(itemId);
    state = newState;
    await _save();
  }

  /// Auto-check prices for all wishlist items that have MeLi URLs.
  /// Returns list of items that dropped in price.
  Future<List<PriceDropAlert>> autoCheckPrices(List<WishlistItem> items) async {
    // Cooldown check
    final prefs = await SharedPreferences.getInstance();
    final lastCheck = prefs.getString(_lastAutoCheckKey);
    if (lastCheck != null) {
      final lastDt = DateTime.tryParse(lastCheck);
      if (lastDt != null &&
          DateTime.now().difference(lastDt).inHours < _autoCheckCooldownHours) {
        return [];
      }
    }

    final drops = <PriceDropAlert>[];

    for (final item in items) {
      if (item.isPurchased) continue;
      if (item.url == null || item.url!.isEmpty) continue;

      final result = await MeliPriceService.fetchPriceFromUrl(item.url!);
      if (result == null) continue;

      final history = state[item.id];
      final previousPrice = history?.latestPrice ?? item.estimatedCost;

      // Log the new price
      await logPrice(item.id, result.price, source: 'meli');

      // Check if it dropped
      if (result.price < previousPrice) {
        drops.add(PriceDropAlert(
          itemId: item.id,
          itemTitle: item.title,
          oldPrice: previousPrice,
          newPrice: result.price,
        ));
      }

      // Small delay between API calls to be polite
      await Future.delayed(const Duration(milliseconds: 300));
    }

    await prefs.setString(_lastAutoCheckKey, DateTime.now().toIso8601String());
    return drops;
  }

  /// Check a single item's price from its MeLi URL, or search by title as fallback.
  Future<MeliPriceResult?> checkSinglePrice(WishlistItem item) async {
    // Try direct URL fetch first
    if (item.url != null && item.url!.isNotEmpty) {
      final result = await MeliPriceService.fetchPriceFromUrl(item.url!);
      if (result != null) {
        await logPrice(item.id, result.price, source: 'meli');
        return result;
      }
    }

    // Fallback: search by title (search endpoint doesn't need auth)
    if (item.title.isNotEmpty) {
      final searchResults = await MeliPriceService.search(item.title, limit: 1);
      if (searchResults.isNotEmpty) {
        final top = searchResults.first;
        // Use search result directly instead of calling /items/ again (avoids 403)
        final result = MeliPriceResult(
          itemId: top.itemId,
          title: top.title,
          price: top.price,
          originalPrice: top.originalPrice,
          thumbnail: top.thumbnail,
          permalink: top.permalink,
          checkedAt: DateTime.now(),
        );
        await logPrice(item.id, result.price, source: 'meli');
        return result;
      }
    }

    return null;
  }
}

final priceTrackerProvider =
    StateNotifierProvider<PriceTrackerNotifier, Map<String, PriceHistory>>(
  (ref) => PriceTrackerNotifier(),
);

/// Holds the latest price drop alerts from auto-check.
final priceDropAlertsProvider = StateProvider<List<PriceDropAlert>>((ref) => []);
