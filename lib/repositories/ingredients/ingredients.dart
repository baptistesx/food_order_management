import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pom/models/ingredient.dart';

class IngredientsRepository {
  var db = FirebaseFirestore.instance;
  IngredientsRepository();

  Future<List<Ingredient>> getIngredients() async {
    List<Ingredient> ingredients = [];

    await db.collection("ingredients").get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");

        ingredients.add(Ingredient.fromMap(doc.data(), doc.id));
      }
    });

    return ingredients;
  }
}
