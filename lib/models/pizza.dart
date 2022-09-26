import 'package:flutter/foundation.dart';
import 'package:pom/extensions/text_helper.dart';
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
      'name': name?.trim().toCapitalized(),
      'price': price,
      'isDone': isDone,
    };
  }

  factory Pizza.fromMap(Map<String, dynamic> map, String? id) {
    return Pizza(
      id: id,
      name: map['name'],
      ingredients: map['ingredients'] == null
          ? <Ingredient>[]
          : List<Ingredient>.from(
              (map['ingredients'] as List<dynamic>?)!.map(
                (dynamic x) =>
                    Ingredient.fromMap(x, (x as Map<String, dynamic>)['id']),
              ),
            ),
      ingredientsToRemove: map['ingredientsToRemove'] == null
          ? <Ingredient>[]
          : List<Ingredient>.from(
              (map['ingredientsToRemove'] as List<dynamic>?)!.map(
                (dynamic x) =>
                    Ingredient.fromMap(x, (x as Map<String, dynamic>)['id']),
              ),
            ),
      ingredientsToAdd: map['ingredientsToAdd'] == null
          ? <Ingredient>[]
          : List<Ingredient>.from(
              (map['ingredientsToAdd'] as List<dynamic>?)!.map(
                (dynamic x) =>
                    Ingredient.fromMap(x, (x as Map<String, dynamic>)['id']),
              ),
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pizza &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.ingredientsToRemove, ingredientsToRemove) &&
        listEquals(other.ingredientsToAdd, ingredientsToAdd) &&
        other.price == price &&
        other.isDone == isDone;
  }

  @override
  int get hashCode {
    return ingredients.hashCode ^
        ingredientsToRemove.hashCode ^
        ingredientsToAdd.hashCode ^
        price.hashCode ^
        isDone.hashCode;
  }
}
