import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fom/models/settings_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// In case of breaking change we can handle that with the [version]
class Preferences {
  static const String settingsKey = 'settings';

  Future<void> saveSettings(SettingsModel settings) async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    instance.setString(settingsKey, jsonEncode(settings.toJson()));
  }

  Future<SettingsModel?> loadSettings() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    final String? json = instance.getString(settingsKey);
    if (json == null) return null;
    return SettingsModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  Future<void> delete(String key) async {
    try {
      final SharedPreferences instance = await SharedPreferences.getInstance();
      instance.remove(key);
    } catch (err, stack) {
      debugPrintStack(stackTrace: stack, label: err.toString());
    }
  }
}
