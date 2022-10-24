import 'package:fom/models/ingredient.dart';

abstract class IngredientsState {}

class IngredientsInitialState extends IngredientsState {}

class IngredientsLoadingState extends IngredientsState {}

class IngredientsFetchedState extends IngredientsState {
  final List<Ingredient> ingredients;

  IngredientsFetchedState({required this.ingredients});
}

class IngredientsFetchedErrorState extends IngredientsState {
  final String message;

  IngredientsFetchedErrorState(this.message);
}
