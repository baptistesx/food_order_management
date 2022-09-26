import 'package:pom/extensions/text_helper.dart';
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
    return <String, dynamic>{
      'id': id,
      'name': name?.toCapitalized().trim(),
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map, String id) {
    return Ingredient(
      id: id,
      name: map['name'],
    );
  }
}
