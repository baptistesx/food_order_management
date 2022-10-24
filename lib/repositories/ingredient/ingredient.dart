import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/repositories/pizza/pizza.dart';
import 'package:fom/repositories/pizzas/pizzas.dart';

class IngredientRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  PizzasRepository pizzasRepository = PizzasRepository();
  PizzaRepository pizzaRepository = PizzaRepository();

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
    final List<Pizza> pizzas = await pizzasRepository.getPizzas();

    pizzas
        .where((Pizza pizza) => pizza.ingredients!.contains(ingredient))
        .forEach((Pizza pizza) async {
      pizza.ingredients!.removeWhere(
        (Ingredient ingredientToUpdate) =>
            ingredientToUpdate.id == ingredient.id,
      );

      await pizzaRepository.updatePizzaById(pizza);
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
