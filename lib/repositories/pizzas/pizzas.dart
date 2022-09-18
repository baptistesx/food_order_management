import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';

class PizzasRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  PizzasRepository();

  Future<List<Pizza>> getPizzas() async {
    final QuerySnapshot<Map<String, dynamic>> pizzasSnapshots =
        await db.collection('pizzas').get();

    final QuerySnapshot<Map<String, dynamic>> ingredientsSnapshots =
        await db.collection('ingredients').get();
    final List<Ingredient> ingredients = ingredientsSnapshots.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              Ingredient.fromMap(e.data(), e.id),
        )
        .toList();

    final List<Pizza> pizzas = pizzasSnapshots.docs
        .map(
          (QueryDocumentSnapshot<Map<String, dynamic>> e) => Pizza(
            id: e.id,
            name: e['name'],
            price: e['price'],
            ingredients: (e['ingredients'] as List<dynamic>)
                .map(
                  (dynamic e) => ingredients.firstWhere(
                    (Ingredient element) => element.id == e.id,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    pizzas.sort((Pizza a, Pizza b) => a.name!.compareTo(b.name!));

    return pizzas;
  }
}
