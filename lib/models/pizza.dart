import 'package:pom/models/ingredient.dart';
import 'package:pom/models/item.dart';

class Pizza extends Item {
  List<Ingredient> ingredients;
  double price;

  Pizza({
    required String id,
    required String name,
    required this.price,
    required this.ingredients,
  }) : super(
          id: id,
          name: name,
        );
}
