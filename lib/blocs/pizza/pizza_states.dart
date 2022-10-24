import 'package:fom/models/pizza.dart';

abstract class PizzaState {}

class PizzaInitialState extends PizzaState {}

class PizzaLoadingState extends PizzaState {}

class PizzaDeletedState extends PizzaState {}

class PizzaAddedState extends PizzaState {}

class PizzaUpdatedState extends PizzaState {}

class PizzaFetchedState extends PizzaState {
  final Pizza pizza;

  PizzaFetchedState({required this.pizza});
}

class PizzaFetchedErrorState extends PizzaState {
  final String message;

  PizzaFetchedErrorState(this.message);
}
