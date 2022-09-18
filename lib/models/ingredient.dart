import 'package:pom/models/item.dart';

class Ingredient extends Item {
  const Ingredient({
    String? id,
    String? name,
  }) : super(
          id: id,
          name: name,
        );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map, String id) {
    return Ingredient(
      id: id,
      name: map['name'],
    );
  }
}
