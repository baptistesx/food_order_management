import 'package:fom/models/meal.dart';

abstract class MealsState {}

class MealsInitialState extends MealsState {}

class MealsLoadingState extends MealsState {}

class MealsFetchedState extends MealsState {
  final List<Meal> meals;

  MealsFetchedState({required this.meals});
}

class MealsFetchedErrorState extends MealsState {
  final String message;

  MealsFetchedErrorState(this.message);
}
