import 'package:pom/models/order.dart';

abstract class OrderState {}

class OrderInitialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class OrderDeletedState extends OrderState {}

class OrderAddedState extends OrderState {}

class OrderUpdatedState extends OrderState {}

class OrderFetchedState extends OrderState {
  final Order order;

  OrderFetchedState({required this.order});
}

class OrderFetchedErrorState extends OrderState {
  final String message;

  OrderFetchedErrorState(this.message);
}
