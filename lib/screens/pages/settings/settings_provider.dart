import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _civicAlertsKey = 'civic_alerts_enabled';
  static const String _discussionNotificationsKey =
      'discussion_notifications_enabled';
  static const String _languageKey = 'app_language';
  static const String _autoPlayVideosKey = 'auto_play_videos';
  static const String _dataSaverKey = 'data_saver_mode';

  SharedPreferences? _prefs;

  bool _notificationsEnabled = true;
  bool _civicAlertsEnabled = true;
  bool _discussionNotificationsEnabled = true;
  bool _autoPlayVideos = true;
  bool _dataSaverMode = false;
  String _selectedLanguage = 'English';

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get civicAlertsEnabled => _civicAlertsEnabled;
  bool get discussionNotificationsEnabled => _discussionNotificationsEnabled;
  bool get autoPlayVideos => _autoPlayVideos;
  bool get dataSaverMode => _dataSaverMode;
  String get selectedLanguage => _selectedLanguage;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = _prefs?.getBool(_notificationsKey) ?? true;
    _civicAlertsEnabled = _prefs?.getBool(_civicAlertsKey) ?? true;
    _discussionNotificationsEnabled =
        _prefs?.getBool(_discussionNotificationsKey) ?? true;
    _autoPlayVideos = _prefs?.getBool(_autoPlayVideosKey) ?? true;
    _dataSaverMode = _prefs?.getBool(_dataSaverKey) ?? false;
    _selectedLanguage = _prefs?.getString(_languageKey) ?? 'English';
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _saveBoolSetting(_notificationsKey, _notificationsEnabled);
    notifyListeners();
  }

  Future<void> toggleCivicAlerts() async {
    _civicAlertsEnabled = !_civicAlertsEnabled;
    await _saveBoolSetting(_civicAlertsKey, _civicAlertsEnabled);
    notifyListeners();
  }

  Future<void> toggleDiscussionNotifications() async {
    _discussionNotificationsEnabled = !_discussionNotificationsEnabled;
    await _saveBoolSetting(
      _discussionNotificationsKey,
      _discussionNotificationsEnabled,
    );
    notifyListeners();
  }

  Future<void> toggleAutoPlayVideos() async {
    _autoPlayVideos = !_autoPlayVideos;
    await _saveBoolSetting(_autoPlayVideosKey, _autoPlayVideos);
    notifyListeners();
  }

  Future<void> toggleDataSaverMode() async {
    _dataSaverMode = !_dataSaverMode;
    await _saveBoolSetting(_dataSaverKey, _dataSaverMode);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _selectedLanguage = language;
    await _saveStringSetting(_languageKey, language);
    notifyListeners();
  }

  Future<void> _saveBoolSetting(String key, bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(key, value);
  }

  Future<void> _saveStringSetting(String key, String value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(key, value);
  }
}
