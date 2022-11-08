import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/orders/orders_events.dart';
import 'package:fom/blocs/orders/orders_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/order.dart';
import 'package:fom/repositories/orders/orders.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository ordersRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  OrdersBloc(this.ordersRepository, {OrdersState? initialState})
      : super(initialState ?? OrdersInitialState()) {
    on<GetOrdersEvent>(getOrders);
    on<UpdateOrdersEvent>(updateOrders);
  }

  Future<void> getOrders(
    GetOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(OrdersLoadingState());

      final List<Order> orders = await ordersRepository.getOrders();

      emit(OrdersFetchedState(orders: orders));
    } on StandardException catch (e) {
      emit(OrdersFetchedErrorState(e.message));
      emit(OrdersInitialState());
    } on ApiResponseException catch (e) {
      emit(OrdersFetchedErrorState(e.message));
      emit(OrdersInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrders(
    UpdateOrdersEvent event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      emit(OrdersLoadingState());

      emit(OrdersFetchedState(orders: event.orders));
    } on StandardException catch (e) {
      emit(OrdersFetchedErrorState(e.message));
      emit(OrdersInitialState());
    } on ApiResponseException catch (e) {
      emit(OrdersFetchedErrorState(e.message));
      emit(OrdersInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
