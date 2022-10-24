import 'package:fom/models/ingredient.dart';

abstract class IngredientState {}

class IngredientInitialState extends IngredientState {}

class IngredientLoadingState extends IngredientState {}

class IngredientDeletedState extends IngredientState {}

class IngredientAddedState extends IngredientState {}

class IngredientUpdatedState extends IngredientState {}

class IngredientFetchedState extends IngredientState {
  final Ingredient ingredient;

  IngredientFetchedState({required this.ingredient});
}

class IngredientFetchedErrorState extends IngredientState {
  final String message;

  IngredientFetchedErrorState(this.message);
}
