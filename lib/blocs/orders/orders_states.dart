import 'package:fom/models/order.dart';

abstract class OrdersState {}

class OrdersInitialState extends OrdersState {}

class OrdersLoadingState extends OrdersState {}

class OrdersFetchedState extends OrdersState {
  final List<Order> orders;

  OrdersFetchedState({required this.orders});
}

class OrdersFetchedErrorState extends OrdersState {
  final String message;

  OrdersFetchedErrorState(this.message);
}
