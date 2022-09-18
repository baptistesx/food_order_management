import 'package:pom/models/pizza.dart';

abstract class PizzaEvent {}

class GetPizzaByIdEvent extends PizzaEvent {
  final String id;

  GetPizzaByIdEvent(this.id);
}

class DeletePizzaByIdEvent extends PizzaEvent {
  final String id;

  DeletePizzaByIdEvent(this.id);
}

class UpdatePizzaByIdEvent extends PizzaEvent {
  final Pizza pizza;

  UpdatePizzaByIdEvent(this.pizza);
}

class CreatePizzaEvent extends PizzaEvent {
  final Pizza pizza;

  CreatePizzaEvent(this.pizza);
}
