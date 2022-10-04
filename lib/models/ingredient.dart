import 'package:pom/extensions/text_helper.dart';
import 'package:pom/models/item.dart';

class Ingredient extends Item {
  const Ingredient({
    String? id,
    String? userId,
    String? name,
  }) : super(
          id: id,
          userId: userId,
          name: name,
        );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name?.toCapitalized().trim(),
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map, String id) {
    return Ingredient(
      id: id,
      userId: map['userId'],
      name: map['name'],
    );
  }
}
