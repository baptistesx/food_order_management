import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/repositories/meal/meal.dart';
import 'package:fom/repositories/meals/meals.dart';

class IngredientRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  MealsRepository mealsRepository = MealsRepository();
  MealRepository mealRepository = MealRepository();

  IngredientRepository();

  Future<Ingredient> getIngredientById(String id) async {
    final Ingredient ingredient = await db
        .collection('ingredients')
        .doc(id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> event) {
      if (!event.exists) {
        throw ApiResponseException(message: 'Ingrédient $id non trouvé');
      }
      return Ingredient.fromMap(event.data()!, event.id);
    });

    return ingredient;
  }

  Future<void> deleteIngredientById(Ingredient ingredient) async {
    final List<Meal> meals = await mealsRepository.getMeals();

    meals
        .where((Meal meal) => meal.ingredients!.contains(ingredient))
        .forEach((Meal meal) async {
      meal.ingredients!.removeWhere(
        (Ingredient ingredientToUpdate) =>
            ingredientToUpdate.id == ingredient.id,
      );

      await mealRepository.updateMealById(meal);
    });

    await db.collection('ingredients').doc(ingredient.id).delete();
  }

  Future<void> updateIngredientById(Ingredient ingredient) async {
    await db
        .collection('ingredients')
        .doc(ingredient.id)
        .update(ingredient.toMap());
  }

  Future<void> createIngredient(Ingredient ingredient) async {
    await db.collection('ingredients').add(ingredient.toMap());
  }
}
