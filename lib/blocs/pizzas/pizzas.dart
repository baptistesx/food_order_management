import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/pizzas/pizzas_events.dart';
import 'package:fom/blocs/pizzas/pizzas_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/pizza.dart';
import 'package:fom/repositories/pizzas/pizzas.dart';

class PizzasBloc extends Bloc<PizzasEvent, PizzasState> {
  final PizzasRepository pizzasRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  PizzasBloc(this.pizzasRepository, {PizzasState? initialState})
      : super(initialState ?? PizzasInitialState()) {
    on<GetPizzasEvent>(getPizzas);
  }

  Future<void> getPizzas(
    GetPizzasEvent event,
    Emitter<PizzasState> emit,
  ) async {
    try {
      emit(PizzasLoadingState());

      final List<Pizza> pizzas = await pizzasRepository.getPizzas();

      emit(PizzasFetchedState(pizzas: pizzas));
    } on StandardException catch (e) {
      emit(PizzasFetchedErrorState(e.message));
      emit(PizzasInitialState());
    } on ApiResponseException catch (e) {
      emit(PizzasFetchedErrorState(e.message));
      emit(PizzasInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
