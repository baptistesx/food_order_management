import 'package:pom/models/settings_models.dart';
import 'package:pom/services/logger.dart';
import 'package:pom/services/preferences.dart';

class SettingsRepository {
  final Logger logger;

  SettingsRepository({required this.logger});

  Future<void> saveToPreferences(SettingsModel model) async {
    try {
      await Preferences().saveSettings(model);
    } catch (err, stack) {
      logger.record(error: err, stack: stack);
    }
  }

  Future<SettingsModel?> loadFromPreferences() async {
    final Preferences preferences = Preferences();
    try {
      return await preferences.loadSettings();
    } catch (err, stack) {
      logger.record(error: err, stack: stack);
      preferences.delete(Preferences.settingsKey);
    }
    return null;
  }
}
