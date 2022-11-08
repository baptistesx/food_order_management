import 'package:fom/models/meal.dart';

abstract class MealState {}

class MealInitialState extends MealState {}

class MealLoadingState extends MealState {}

class MealDeletedState extends MealState {}

class MealAddedState extends MealState {}

class MealUpdatedState extends MealState {}

class MealFetchedState extends MealState {
  final Meal meal;

  MealFetchedState({required this.meal});
}

class MealFetchedErrorState extends MealState {
  final String message;

  MealFetchedErrorState(this.message);
}
