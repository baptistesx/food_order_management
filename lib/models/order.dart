import 'package:pom/models/pizza.dart';

enum OrderStatus { toDo, done, delivered }

class Order {
  final String id;
  final OrderStatus status;
  final DateTime timeToDeliver;
  final List<Pizza> pizzas;
  final String clientName;

  Order({
    required this.id,
    required this.status,
    required this.timeToDeliver,
    required this.pizzas,
    required this.clientName,
  });
}
