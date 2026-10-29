import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends ChangeNotifier {
  SettingController(this._prefs)
    : _themeMode = ThemeMode.values.byName(
        _prefs.getString(_kTheme) ?? ThemeMode.system.name,
      ),
      _defaultHolder = _prefs.getString(_kHolder) ?? '';

  static const _kTheme = 'theme_mode';
  static const _kHolder = 'default_holder';
  static const _kAutoMaxBrightness = 'auto_max_brightness';

  final SharedPreferences _prefs;
  ThemeMode _themeMode;
  String _defaultHolder;

  ThemeMode get themeMode => _themeMode;
  String get defaultHolder => _defaultHolder;
  bool get autoMaxBrightness => _prefs.getBool(_kAutoMaxBrightness) ?? false;

  static Future<SettingController> load() async =>
      SettingController(await SharedPreferences.getInstance());

  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
    await _prefs.setString(_kTheme, mode.name);
  }

  Future<void> setDefaultHolder(String name) async {
    _defaultHolder = name.trim();
    notifyListeners();
    await _prefs.setString(_kHolder, _defaultHolder);
  }

  Future<void> setAutoMaxBrightness(bool value) =>
      _prefs.setBool(_kAutoMaxBrightness, value);
}
