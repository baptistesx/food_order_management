import 'package:pom/models/order.dart';

abstract class OrderEvent {}

class GetOrderByIdEvent extends OrderEvent {
  final String id;

  GetOrderByIdEvent(this.id);
}

class DeleteOrderByIdEvent extends OrderEvent {
  final Order order;

  DeleteOrderByIdEvent(this.order);
}

class UpdateOrderByIdEvent extends OrderEvent {
  final Order order;

  UpdateOrderByIdEvent(this.order);
}

class CreateOrderEvent extends OrderEvent {
  final Order order;

  CreateOrderEvent(this.order);
}
