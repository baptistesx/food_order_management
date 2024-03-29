import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/main.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
// TODO: reduce api calls

class MealRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  MealRepository();

  Future<Meal> getMealById(String id) async {
    final Meal meal = await db
        .collection('meals')
        .doc(id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> event) async {
      if (!event.exists) {
        throw ApiResponseException(message: 'Ingrédient $id non trouvé');
      }
      final List<Ingredient> ingredients = await db
          .collection('ingredients')
          .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
        return snapshot.docs
            .map(
              (QueryDocumentSnapshot<Object?> e) => Ingredient.fromMap(
                e.data() as Map<String, dynamic>,
                e.reference.id,
              ),
            )
            .toList();
      });

      return Meal.fromMap(event.data()!, event.id, ingredients);
    });
    if (meal.ingredients != null) {
      meal.ingredients!
          .sort((Ingredient a, Ingredient b) => a.name!.compareTo(b.name!));
    }

    return meal;
  }

  Future<void> deleteMealById(String id) async {
    await db.collection('meals').doc(id).delete();
  }

  Future<void> updateMealById(Meal meal) async {
    final List<dynamic> ingredientsRefs = <dynamic>[];

    for (int i = 0; i < meal.ingredients!.length; i++) {
      ingredientsRefs
          .add(db.collection('ingredient').doc(meal.ingredients![i].id));
    }

    final Map<String, dynamic> map = meal.toMap(false);
    map['ingredients'] = ingredientsRefs;

    await db.collection('meals').doc(meal.id).update(map);
  }

  Future<void> createMeal(Meal meal) async {
    final List<dynamic> ingredientsRefs = <dynamic>[];

    for (int i = 0; i < meal.ingredients!.length; i++) {
      ingredientsRefs
          .add(db.collection('ingredient').doc(meal.ingredients![i].id));
    }

    final Map<String, dynamic> map = meal.toMap(false);
    map['ingredients'] = ingredientsRefs;

    await db.collection('meals').add(map);
  }
}
