import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/order/order_events.dart';
import 'package:fom/blocs/order/order_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/order.dart';
import 'package:fom/repositories/order/order.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  OrderBloc(this.orderRepository, {OrderState? initialState})
      : super(initialState ?? OrderInitialState()) {
    on<CreateOrderEvent>(createOrder);
    on<GetOrderByIdEvent>(getOrderById);
    on<UpdateOrderByIdEvent>(updateOrderById);
    on<DeleteOrderByIdEvent>(deleteOrderById);
  }

  Future<void> getOrderById(
    GetOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoadingState());

      final Order order = await orderRepository.getOrderById(event.id);

      emit(OrderFetchedState(order: order));
    } on StandardException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } on ApiResponseException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteOrderById(
    DeleteOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoadingState());

      await orderRepository.deleteOrderById(event.order);

      emit(OrderDeletedState());
      emit(OrderInitialState());
    } on StandardException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } on ApiResponseException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderById(
    UpdateOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoadingState());

      await orderRepository.updateOrderById(event.order);

      emit(OrderUpdatedState(orderUpdated: event.order));
    } on StandardException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } on ApiResponseException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(
    UpdateOrderByIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoadingState());

      await orderRepository.updateOrderById(event.order);

      emit(OrderStatusUpdatedState(orderUpdated: event.order));
    } on StandardException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } on ApiResponseException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoadingState());

      await orderRepository.createOrder(event.order);

      emit(OrderAddedState());
      emit(OrderInitialState());
    } on StandardException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } on ApiResponseException catch (e) {
      emit(OrderFetchedErrorState(e.message));
      emit(OrderInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
