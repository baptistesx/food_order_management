import 'package:pom/models/ingredient.dart';
import 'package:pom/models/item.dart';

class Pizza extends Item {
  List<Ingredient>? ingredients;
  double? price;

  Pizza({
    String? id,
    String? name,
    this.price,
    this.ingredients,
  }) : super(
          id: id,
          name: name,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ingredients': ingredients != null
          ? ingredients!.map((Ingredient x) => x.id).toList()
          : <Ingredient>[],
      'name': name,
      'price': price,
    };
  }

  factory Pizza.fromMap(Map<String, dynamic> map, String id) {
    return Pizza(
      id: id,
      name: map['name'],
      ingredients: <Ingredient>[],
      //  List<Ingredient>.from(
      //     map['ingredients']?.map((x) => Ingredient.fromMap(x))),
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
}
