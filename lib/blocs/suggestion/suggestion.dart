import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/suggestion/suggestion_events.dart';
import 'package:fom/blocs/suggestion/suggestion_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/repositories/suggestion/suggestion.dart';

class SuggestionBloc extends Bloc<SuggestionEvent, SuggestionState> {
  final SuggestionRepository suggestionRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  SuggestionBloc(this.suggestionRepository, {SuggestionState? initialState})
      : super(initialState ?? SuggestionInitialState()) {
    on<SendSuggestionEvent>(sendSuggestion);
  }

  Future<void> sendSuggestion(
    SendSuggestionEvent event,
    Emitter<SuggestionState> emit,
  ) async {
    try {
      emit(SuggestionLoadingState());

      await suggestionRepository.sendSuggestion(event.suggestion);

      emit(SuggestionSentState());
    } on StandardException catch (e) {
      emit(SuggestionErrorState(e.message));
      emit(SuggestionInitialState());
    } on ApiResponseException catch (e) {
      emit(SuggestionErrorState(e.message));
      emit(SuggestionInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
