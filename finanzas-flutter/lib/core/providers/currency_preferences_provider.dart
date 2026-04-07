import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _key = 'selected_currencies';
const _defaultCurrencies = ['blue', 'oficial', 'tarjeta', 'mep', 'ccl'];

/// Which currency types are visible in the rates card.
class SelectedCurrenciesNotifier extends StateNotifier<List<String>> {
  SelectedCurrenciesNotifier() : super(_defaultCurrencies) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_key);
    if (saved != null && saved.isNotEmpty) {
      state = saved;
    }
  }

  Future<void> toggle(String casa) async {
    final current = List<String>.from(state);
    if (current.contains(casa)) {
      if (current.length <= 1) return; // keep at least one
      current.remove(casa);
    } else {
      current.add(casa);
    }
    state = current;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, current);
  }

  bool isSelected(String casa) => state.contains(casa);
}

final selectedCurrenciesProvider =
    StateNotifierProvider<SelectedCurrenciesNotifier, List<String>>(
  (ref) => SelectedCurrenciesNotifier(),
);
