import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingKey = 'onboarding_v1_complete';
const _kSkipAuthKey = 'skip_auth';
const _kNeedsInAppTourKey = 'needs_in_app_tour';

final onboardingProvider =
    ChangeNotifierProvider<OnboardingController>((ref) {
  return OnboardingController();
});

/// Whether the user chose to skip Google login
final skipAuthProvider =
    ChangeNotifierProvider<SkipAuthController>((ref) {
  return SkipAuthController();
});

/// Whether the user needs an in-app tour (new account, no data)
final needsInAppTourProvider =
    ChangeNotifierProvider<InAppTourController>((ref) {
  return InAppTourController();
});

/// Tracks whether the user has completed the onboarding flow.
class OnboardingController extends ChangeNotifier {
  bool _isComplete = false;
  bool _isLoaded = false;

  bool get isComplete => _isComplete;
  bool get isLoaded => _isLoaded;

  OnboardingController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _isComplete = prefs.getBool(_kOnboardingKey) ?? false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> complete() async {
    _isComplete = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingKey, true);
  }

  Future<void> reset() async {
    _isComplete = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kOnboardingKey);
  }
}

/// Controls whether user skipped Google auth to use app without account
class SkipAuthController extends ChangeNotifier {
  bool _skipped = false;
  bool _isLoaded = false;

  bool get skipped => _skipped;
  bool get isLoaded => _isLoaded;

  SkipAuthController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _skipped = prefs.getBool(_kSkipAuthKey) ?? false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> skip() async {
    _skipped = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSkipAuthKey, true);
  }

  Future<void> reset() async {
    _skipped = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kSkipAuthKey);
  }
}

/// Controls the in-app tour for new users
class InAppTourController extends ChangeNotifier {
  bool _needed = false;
  bool _isLoaded = false;

  bool get needed => _needed;
  bool get isLoaded => _isLoaded;

  InAppTourController() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _needed = prefs.getBool(_kNeedsInAppTourKey) ?? false;
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> enable() async {
    _needed = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNeedsInAppTourKey, true);
  }

  Future<void> complete() async {
    _needed = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNeedsInAppTourKey, false);
  }
}
