import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kCompleteKey = 'setup_wizard_complete';
const _kStepKey = 'setup_wizard_step';

final setupWizardProvider =
    ChangeNotifierProvider<SetupWizardController>((ref) {
  return SetupWizardController();
});

/// Tracks the post-login setup wizard (name, profile, goals, notifications).
class SetupWizardController extends ChangeNotifier {
  bool _isComplete = false;
  bool _isLoaded = false;
  int _step = 0;

  // In-memory collected data (persisted to DB/prefs on finish)
  String? userName;
  bool? hasCreditCards;
  double? monthlyIncome;
  int? payDay;
  String? financialGoal;
  bool? notificationsEnabled;

  bool get isComplete => _isComplete;
  bool get isLoaded => _isLoaded;
  int get step => _step;

  SetupWizardController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isComplete = prefs.getBool(_kCompleteKey) ?? false;
    _step = prefs.getInt(_kStepKey) ?? 0;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> nextStep() async {
    _step++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kStepKey, _step);
  }

  Future<void> prevStep() async {
    if (_step > 0) _step--;
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
    // Skipping counts as complete to avoid re-prompting
    await complete();
  }

  Future<void> reset() async {
    _isComplete = false;
    _step = 0;
    userName = null;
    hasCreditCards = null;
    monthlyIncome = null;
    payDay = null;
    financialGoal = null;
    notificationsEnabled = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kCompleteKey);
    await prefs.remove(_kStepKey);
  }
}
