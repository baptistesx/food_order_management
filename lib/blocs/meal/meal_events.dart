import 'package:fom/models/meal.dart';

abstract class MealEvent {}

class GetMealByIdEvent extends MealEvent {
  final String id;

  GetMealByIdEvent(this.id);
}

class DeleteMealByIdEvent extends MealEvent {
  final String id;

  DeleteMealByIdEvent(this.id);
}

class UpdateMealByIdEvent extends MealEvent {
  final Meal meal;

  UpdateMealByIdEvent(this.meal);
}

class CreateMealEvent extends MealEvent {
  final Meal meal;

  CreateMealEvent(this.meal);
}
