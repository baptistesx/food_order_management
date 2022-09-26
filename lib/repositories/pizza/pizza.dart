import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pom/models/exceptions.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/models/pizza.dart';
// TODO: reduce api calls

class PizzaRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;

  PizzaRepository();

  Future<Pizza> getPizzaById(String id) async {
    Pizza pizza = await db
        .collection('pizzas')
        .doc(id)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> event) {
      if (!event.exists) {
        throw ApiResponseException(message: 'Ingrédient $id non trouvé');
      }
      return Pizza.fromMap(event.data()!, event.id);
    });
    if (pizza.ingredients != null) {
      pizza.ingredients!
          .sort((Ingredient a, Ingredient b) => a.name!.compareTo(b.name!));
    }

    return pizza;
  }

  Future<void> deletePizzaById(String id) async {
    await db.collection('pizzas').doc(id).delete();
  }

  Future<void> updatePizzaById(Pizza pizza) async {
    final List<dynamic> ingredientsRefs = <dynamic>[];

    for (int i = 0; i < pizza.ingredients!.length; i++) {
      ingredientsRefs
          .add(db.collection('ingredient').doc(pizza.ingredients![i].id));
    }

    final Map<String, dynamic> map = pizza.toMap(false);
    map['ingredients'] = ingredientsRefs;

    await db.collection('pizzas').doc(pizza.id).update(map);
  }

  Future<void> createPizza(Pizza pizza) async {
    final List<dynamic> ingredientsRefs = <dynamic>[];

    for (int i = 0; i < pizza.ingredients!.length; i++) {
      ingredientsRefs
          .add(db.collection('ingredient').doc(pizza.ingredients![i].id));
    }

    final Map<String, dynamic> map = pizza.toMap(false);
    map['ingredients'] = ingredientsRefs;

    await db.collection('pizzas').add(map);
  }
}
