import 'package:flutter/foundation.dart';
import 'package:fom/extensions/text_helper.dart';
import 'package:fom/models/ingredient.dart';
import 'package:fom/models/item.dart';

class Pizza extends Item {
  List<Ingredient>? ingredients;
  List<Ingredient>? ingredientsToRemove;
  List<Ingredient>? ingredientsToAdd;
  double? priceSmall;
  double? priceBig;
  bool? isDone;
  bool? isBig;

  Pizza({
    String? id,
    String? userId,
    String? name,
    this.priceSmall,
    this.priceBig,
    this.ingredients,
    this.ingredientsToRemove,
    this.ingredientsToAdd,
    this.isDone,
    this.isBig,
  }) : super(
          id: id,
          userId: userId,
          name: name,
        );

  Map<String, dynamic> toMap(bool isInOrder) {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
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
      'priceSmall': priceSmall,
      'priceBig': priceBig,
      'isDone': isDone,
      'isBig': isBig,
    };
  }

  factory Pizza.fromMap(Map<String, dynamic> map, String? id) {
    return Pizza(
      id: id,
      userId: map['userId'],
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
      priceSmall: map['priceSmall'],
      priceBig: map['priceBig'],
      isDone: map['isDone'],
      isBig: map['isBig'],
    );
  }

  Pizza copyWith({
    List<Ingredient>? ingredients,
    List<Ingredient>? ingredientsToRemove,
    List<Ingredient>? ingredientsToAdd,
    double? priceSmall,
    double? priceBig,
    bool? isDone,
    String? id,
    String? userId,
    String? name,
    bool? isBig,
  }) {
    return Pizza(
      ingredients: ingredients ?? this.ingredients,
      ingredientsToRemove: ingredientsToRemove ?? this.ingredientsToRemove,
      ingredientsToAdd: ingredientsToAdd ?? this.ingredientsToAdd,
      priceSmall: priceSmall ?? this.priceSmall,
      priceBig: priceBig ?? this.priceBig,
      isDone: isDone ?? this.isDone,
      isBig: isBig ?? this.isBig,
      name: name ?? this.name,
      id: id ?? this.id,
      userId: userId ?? this.userId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Pizza &&
        listEquals(other.ingredients, ingredients) &&
        listEquals(other.ingredientsToRemove, ingredientsToRemove) &&
        listEquals(other.ingredientsToAdd, ingredientsToAdd) &&
        other.isDone == isDone &&
        other.isBig == isBig &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return ingredients.hashCode ^
        ingredientsToRemove.hashCode ^
        ingredientsToAdd.hashCode ^
        isDone.hashCode ^
        isBig.hashCode ^
        userId.hashCode;
  }
}
