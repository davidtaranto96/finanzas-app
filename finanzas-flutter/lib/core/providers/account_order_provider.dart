import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kAccountOrder = 'account_order';
const _kAccountSortMode = 'account_sort_mode';

/// 'auto' = grouped by type, sorted by balance
/// 'manual' = user-defined drag order
enum AccountSortMode { auto, manual }

class AccountOrderNotifier extends StateNotifier<List<String>> {
  AccountOrderNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final order = prefs.getStringList(_kAccountOrder);
    if (order != null) state = order;
  }

  Future<void> setOrder(List<String> ids) async {
    state = ids;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kAccountOrder, ids);
  }

  Future<void> clear() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccountOrder);
  }
}

final accountOrderProvider =
    StateNotifierProvider<AccountOrderNotifier, List<String>>(
        (ref) => AccountOrderNotifier());

/// Sort mode provider
final accountSortModeProvider =
    StateNotifierProvider<_SortModeNotifier, AccountSortMode>(
        (ref) => _SortModeNotifier());

class _SortModeNotifier extends StateNotifier<AccountSortMode> {
  _SortModeNotifier() : super(AccountSortMode.auto) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString(_kAccountSortMode);
    if (mode == 'manual') state = AccountSortMode.manual;
  }

  Future<void> setMode(AccountSortMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccountSortMode, mode.name);
  }
}
