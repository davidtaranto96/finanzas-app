import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kPrefix = 'coach_seen_';

final pageCoachProvider =
    ChangeNotifierProvider<PageCoachController>((ref) {
  return PageCoachController();
});

/// Tracks which per-page coaches the user has already seen.
/// Flag is stored in SharedPreferences under `coach_seen_<pageId>`.
class PageCoachController extends ChangeNotifier {
  final Set<String> _seen = {};
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;

  PageCoachController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_kPrefix) && (prefs.getBool(key) ?? false)) {
        _seen.add(key.substring(_kPrefix.length));
      }
    }
    _isLoaded = true;
    notifyListeners();
  }

  bool hasSeen(String pageId) => _seen.contains(pageId);

  Future<void> markSeen(String pageId) async {
    if (_seen.add(pageId)) notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_kPrefix$pageId', true);
  }

  Future<void> resetAll() async {
    _seen.clear();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys()) {
      if (key.startsWith(_kPrefix)) {
        await prefs.remove(key);
      }
    }
  }
}
