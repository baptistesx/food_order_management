import 'package:mobile_app/models/settings_models.dart';

abstract class SettingsEvent {}

class SettingsInitialEvent extends SettingsEvent {}

class SettingsSaveSettings extends SettingsEvent {
  final SettingsModel settings;

  SettingsSaveSettings({required this.settings});
}

class SettingsUpdatedEvent extends SettingsEvent {}
