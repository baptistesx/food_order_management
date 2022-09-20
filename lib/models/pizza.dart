import 'package:pom/models/ingredient.dart';
import 'package:pom/models/item.dart';

class Pizza extends Item {
  List<Ingredient>? ingredients;
  List<Ingredient>? ingredientsToRemove;
  List<Ingredient>? ingredientsToAdd;
  double? price;

  Pizza({
    String? id,
    String? name,
    this.price,
    this.ingredients,
    this.ingredientsToRemove,
    this.ingredientsToAdd,
  }) : super(
          id: id,
          name: name,
        );

  Map<String, dynamic> toMap(bool isInOrder) {
    return <String, dynamic>{
      'id': id,
      'ingredients': ingredients != null
          ? ingredients!
              .map((Ingredient x) => isInOrder ? x.toMap() : x.id)
              .toList()
          : <Ingredient>[],
      'ingredientsToRemove': ingredientsToRemove != null
          ? ingredientsToRemove!
              .map((Ingredient x) => isInOrder ? x.toMap() : x.id)
              .toList()
          : <Ingredient>[],
      'ingredientsToAdd': ingredientsToAdd != null
          ? ingredientsToAdd!
              .map((Ingredient x) => isInOrder ? x.toMap() : x.id)
              .toList()
          : <Ingredient>[],
      'name': name,
      'price': price,
    };
  }

  factory Pizza.fromMap(Map<String, dynamic> map, String? id) {
    return Pizza(
      id: id,
      name: map['name'],
      ingredients: List<Ingredient>.from(
        map['ingredients']?.map((x) => Ingredient.fromMap(x, x['id'])),
      ),
      ingredientsToRemove: List<Ingredient>.from(
        map['ingredientsToRemove']?.map((x) => Ingredient.fromMap(x, x['id'])),
      ),
      ingredientsToAdd: List<Ingredient>.from(
        map['ingredientsToAdd']?.map((x) => Ingredient.fromMap(x, x['id'])),
      ),
      price: map['price'],
    );
  }

  Pizza copyWith({
    List<Ingredient>? ingredients,
    double? price,
  }) {
    return Pizza(
      id: id,
      name: name,
      ingredients: ingredients ?? this.ingredients,
      price: price ?? this.price,
    );
  }

  @override
  String toString() {
    return 'Pizza(ingredients: $ingredients, ingredientsToRemove: $ingredientsToRemove, ingredientsToAdd: $ingredientsToAdd, price: $price)';
  }
}
