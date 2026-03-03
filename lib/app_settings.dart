import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A very simple singleton that holds the user-configurable settings and
/// persists them using `SharedPreferences`.
///
/// The app listens to this object as a `ChangeNotifier` so that whenever a
/// value is changed the UI can rebuild accordingly (theme, font size, etc).
class AppSettings extends ChangeNotifier {
  AppSettings._internal();

  static final AppSettings instance = AppSettings._internal();

  late SharedPreferences _prefs;

  // values that can be modified by the user
  bool autoPlay = true;
  double playbackSpeed = 1.0;
  double fontSize = 16.0;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    autoPlay = _prefs.getBool('autoPlay') ?? true;
    playbackSpeed = _prefs.getDouble('playbackSpeed') ?? 1.0;
    fontSize = _prefs.getDouble('fontSize') ?? 16.0;
    notifyListeners();
  }

  Future<void> _saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  Future<void> _saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }

  void updateAutoPlay(bool value) {
    autoPlay = value;
    _saveBool('autoPlay', value);
    notifyListeners();
  }

  void updatePlaybackSpeed(double value) {
    playbackSpeed = value;
    _saveDouble('playbackSpeed', value);
    notifyListeners();
  }

  void updateFontSize(double value) {
    fontSize = value;
    _saveDouble('fontSize', value);
    notifyListeners();
  }
}
