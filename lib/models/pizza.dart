import 'package:pom/models/ingredient.dart';
import 'package:pom/models/item.dart';

class Pizza extends Item {
  List<Ingredient> ingredients;

  Pizza({
    required String id,
    required String name,
    required this.ingredients,
  }) : super(
          id: id,
          name: name,
        );
}
