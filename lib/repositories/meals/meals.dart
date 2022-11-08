import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/main.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';

class MealsRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  MealsRepository();

  Future<List<Meal>> getMeals() async {
    final QuerySnapshot<Map<String, dynamic>> mealsSnapshots = await db
        .collection('meals')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    final QuerySnapshot<Map<String, dynamic>> ingredientsSnapshots = await db
        .collection('ingredients')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();
    final List<Ingredient> ingredients = ingredientsSnapshots.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              Ingredient.fromMap(e.data(), e.id),
        )
        .toList();

    final List<Meal> meals = mealsSnapshots.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) => Meal(
            id: e.id,
            name: e['name'],
            priceSmall: e['priceSmall'],
            priceBig: e['priceBig'],
            isBig: e['isBig'],
            userId: firebaseAuth.currentUser!.uid,
            ingredients: (e['ingredients'] as List<dynamic>)
                .map(
                  (dynamic e) => ingredients.firstWhere(
                    // ignore: avoid_dynamic_calls
                    (Ingredient element) => element.id == e.id,
                    orElse: () => const Ingredient(),
                  ),
                )
                .where((Ingredient element) => element.id != null)
                .toList(),
          ),
        )
        .toList();

    meals.sort(
      (Meal a, Meal b) => a.name.toString().compareTo(b.name.toString()),
    );

    return meals;
  }
}
