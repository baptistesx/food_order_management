import 'package:fom/models/ingredient.dart';

abstract class IngredientEvent {}

class GetIngredientByIdEvent extends IngredientEvent {
  final String id;

  GetIngredientByIdEvent(this.id);
}

class DeleteIngredientByIdEvent extends IngredientEvent {
  final Ingredient ingredient;

  DeleteIngredientByIdEvent(this.ingredient);
}

class UpdateIngredientByIdEvent extends IngredientEvent {
  final Ingredient ingredient;

  UpdateIngredientByIdEvent(this.ingredient);
}

class CreateIngredientEvent extends IngredientEvent {
  final Ingredient ingredient;

  CreateIngredientEvent(this.ingredient);
}
