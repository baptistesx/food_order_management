import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pom/main.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';

class PizzasRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  PizzasRepository();

  Future<List<Pizza>> getPizzas() async {
    final QuerySnapshot<Map<String, dynamic>> pizzasSnapshots = await db
        .collection('pizzas')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .get();

    final QuerySnapshot<Map<String, dynamic>> ingredientsSnapshots = await db
        .collection('ingredients')
        .where('userId', isEqualTo: firebaseAuth.currentUser!.uid)
        .orderBy('name')
        .get();
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
            priceSmall: e['priceSmall'],
            priceBig: e['priceBig'],
            isBig: e['isBig'],
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

    return pizzas;
  }
}
