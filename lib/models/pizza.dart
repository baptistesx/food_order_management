import 'package:pom/models/ingredient.dart';
import 'package:pom/models/item.dart';

class Pizza extends Item {
  List<Ingredient>? ingredients;
  List<Ingredient>? ingredientsToRemove;
  List<Ingredient>? ingredientsToAdd;
  double? price;
  bool? isDone;

  Pizza({
    String? id,
    String? name,
    this.price,
    this.ingredients,
    this.ingredientsToRemove,
    this.ingredientsToAdd,
    this.isDone,
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
      'isDone': isDone,
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
      isDone: map['isDone'],
    );
  }

  Pizza copyWith({
    List<Ingredient>? ingredients,
    List<Ingredient>? ingredientsToRemove,
    List<Ingredient>? ingredientsToAdd,
    double? price,
    bool? isDone,
    String? id,
    String? name,
  }) {
    return Pizza(
      ingredients: ingredients ?? this.ingredients,
      ingredientsToRemove: ingredientsToRemove ?? this.ingredientsToRemove,
      ingredientsToAdd: ingredientsToAdd ?? this.ingredientsToAdd,
      price: price ?? this.price,
      isDone: isDone ?? this.isDone,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }
}
