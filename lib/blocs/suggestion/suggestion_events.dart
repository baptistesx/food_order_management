import 'package:pom/models/suggestion.dart';

abstract class SuggestionEvent {}

class SendSuggestionEvent extends SuggestionEvent {
  final Suggestion suggestion;

  SendSuggestionEvent(this.suggestion);
}
