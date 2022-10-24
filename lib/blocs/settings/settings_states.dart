import 'package:fom/models/settings_models.dart';

abstract class SettingsState {}

class SettingsInitialState extends SettingsState {}

class SettingsSavingState extends SettingsState {}

class SettingsUpdatedState extends SettingsState {
  final SettingsModel settings;

  SettingsUpdatedState({required this.settings});
}
