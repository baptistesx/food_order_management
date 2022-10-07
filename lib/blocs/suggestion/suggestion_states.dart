abstract class SuggestionState {}

class SuggestionInitialState extends SuggestionState {}

class SuggestionLoadingState extends SuggestionState {}

class SuggestionSentState extends SuggestionState {}

class SuggestionErrorState extends SuggestionState {
  final String message;

  SuggestionErrorState(this.message);
}
