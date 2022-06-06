import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/blocs/settings/settings.dart';
import 'package:mobile_app/repositories/settings/settings.dart';

export 'settings_events.dart';
export 'settings_states.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  SettingsBloc(this.settingsRepository, {SettingsState? initialState})
      : super(initialState ?? SettingsInitialState()) {
    on<SettingsSaveSettings>(updateSettings);
  }

  Future<void> updateSettings(
    SettingsSaveSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsSavingState());
    await settingsRepository.saveToPreferences(event.settings);
    emit(SettingsUpdatedState(settings: event.settings));
  }
}
