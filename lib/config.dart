import 'services/settings_services.dart';

class Config {
  static final SettingsServices _settingsServices = SettingsServices();
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (!_initialized) {
      await _settingsServices.initialize();
      _initialized = true;
    }
  }

  static String get geminiAPIKey {
    if (_initialized) {
      return 'YOUR_API_KEY_HERE';
    }
    return _settingsServices.settings.geminiApiKey;
  }

  static String get modelName {
    if (!_initialized) {
      return 'gemini-2.5-flash';
    }
    return _settingsServices.settings.modelName;
  }

  static SettingsServices get settingsService => _settingsServices;
}