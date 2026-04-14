import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kCompleteKey = 'tour_complete';
const _kStepKey = 'tour_step';
const _kSkippedKey = 'tour_skipped';

final interactiveTourProvider =
    ChangeNotifierProvider<InteractiveTourController>((ref) {
  return InteractiveTourController();
});

/// Tracks the interactive in-app tour for new users.
class InteractiveTourController extends ChangeNotifier {
  bool _isComplete = false;
  bool _isSkipped = false;
  bool _isLoaded = false;
  int _step = 0;

  bool get isComplete => _isComplete;
  bool get isSkipped => _isSkipped;
  bool get isLoaded => _isLoaded;
  int get step => _step;
  bool get shouldRun => _isLoaded && !_isComplete && !_isSkipped;

  InteractiveTourController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isComplete = prefs.getBool(_kCompleteKey) ?? false;
    _isSkipped = prefs.getBool(_kSkippedKey) ?? false;
    _step = prefs.getInt(_kStepKey) ?? 0;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setStep(int step) async {
    _step = step;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kStepKey, _step);
  }

  Future<void> complete() async {
    _isComplete = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCompleteKey, true);
  }

  Future<void> skip() async {
    _isSkipped = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSkippedKey, true);
  }

  Future<void> reset() async {
    _isComplete = false;
    _isSkipped = false;
    _step = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCompleteKey);
    await prefs.remove(_kSkippedKey);
    await prefs.remove(_kStepKey);
  }
}
