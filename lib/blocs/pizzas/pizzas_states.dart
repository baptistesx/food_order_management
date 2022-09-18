import 'package:pom/models/pizza.dart';

abstract class PizzasState {}

class PizzasInitialState extends PizzasState {}

class PizzasLoadingState extends PizzasState {}

class PizzasFetchedState extends PizzasState {
  final List<Pizza> pizzas;

  PizzasFetchedState({required this.pizzas});
}

class PizzasFetchedErrorState extends PizzasState {
  final String message;

  PizzasFetchedErrorState(this.message);
}
