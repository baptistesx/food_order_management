import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pom/models/exceptions.dart';
import 'package:pom/models/ingredient.dart';

class IngredientRepository {
  var db = FirebaseFirestore.instance;

  IngredientRepository();

  Future<Ingredient> getIngredientById(String id) async {
    Ingredient ingredient =
        await db.collection("ingredients").doc(id).get().then((event) {
      print("${event.id} => ${event.data()}");
      if (!event.exists) {
        throw ApiResponseException(message: 'Ingrédient $id non trouvé');
      }
      return Ingredient.fromMap(event.data()!, event.id);
    });

    return ingredient;
  }

  Future<void> deleteIngredientById(String id) async {
    await db.collection("ingredients").doc(id).delete();
  }

  Future<void> updateIngredientById(Ingredient ingredient) async {
    await db
        .collection("ingredients")
        .doc(ingredient.id)
        .update(ingredient.toMap())
        .then((event) {})
        .catchError((onError) {
      print("onError");
    });
    ;
  }

  Future<void> createIngredient(Ingredient ingredient) async {
    await db.collection("ingredients").add(ingredient.toMap());
  }
}
