import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SettingsServices extends ChangeNotifier {
  static const String _settingsKey = 'app_settings';
  SettingsModel _settings = SettingsModel.defaults();
  bool _isInitialized = false;

  SettingsModel get settings => _settings;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_settingsKey);

      if (settingsJson != null) {
        final jsonMap = jsonDecode(settingsJson) as Map<String, dynamic>;
        _settings = SettingsModel.fromJson(jsonMap);
      } else {
        // await saveSettings(_settings);
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      _settings = SettingsModel.defaults();
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> saveSettings(SettingsModel newSettings) async {
    _settings = newSettings;
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = jsonEncode(_settings.toJson());
      await prefs.setString(_settingsKey, settingsJson);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to save setting: ${e.toString()}');
    }
  }
  
  Future<void> updateApiKey(String apiKey) async {
    await saveSettings(_settings.copyWith(geminiApiKey: apiKey));
  }
  
  Future<void> updateModelName(String modelName) async {
    await saveSettings(_settings.copyWith(modelName: modelName));
  }
  
  Future<void> updateDarkMode(bool isDarkMode) async {
    await saveSettings(_settings.copyWith(isDarkMode: isDarkMode));
  }

  Future<void> updateSeedColor(Color color) async {
    await saveSettings(_settings.copyWith(seedColorValue: color.toARGB32()));
  }

  Color get seedColor => Color(_settings.seedColorValue);
}