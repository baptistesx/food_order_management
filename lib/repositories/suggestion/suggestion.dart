import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pom/models/suggestion.dart';

class SuggestionRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  SuggestionRepository();

  Future<void> sendSuggestion(Suggestion suggestion) async {
    await db.collection('suggestions').add(suggestion.toMap());
  }
}
