import 'package:pom/models/order.dart';

abstract class OrdersEvent {}

class GetOrdersEvent extends OrdersEvent {}

class UpdateOrdersEvent extends OrdersEvent {
  final List<Order> orders;

  UpdateOrdersEvent(this.orders);
}
