import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/pizza/pizza_events.dart';
import 'package:pom/blocs/pizza/pizza_states.dart';
import 'package:pom/models/exceptions.dart';
import 'package:pom/models/pizza.dart';
import 'package:pom/repositories/pizza/pizza.dart';

class PizzaBloc extends Bloc<PizzaEvent, PizzaState> {
  final PizzaRepository pizzaRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  PizzaBloc(this.pizzaRepository, {PizzaState? initialState})
      : super(initialState ?? PizzaInitialState()) {
    on<CreatePizzaEvent>(createPizza);
    on<GetPizzaByIdEvent>(getPizzaById);
    on<UpdatePizzaByIdEvent>(updatePizzaById);
    on<DeletePizzaByIdEvent>(deletePizzaById);
  }

  Future<void> getPizzaById(
    GetPizzaByIdEvent event,
    Emitter<PizzaState> emit,
  ) async {
    try {
      emit(PizzaLoadingState());

      final Pizza pizza = await pizzaRepository.getPizzaById(event.id);

      emit(PizzaFetchedState(pizza: pizza));
    } on StandardException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } on ApiResponseException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePizzaById(
    DeletePizzaByIdEvent event,
    Emitter<PizzaState> emit,
  ) async {
    try {
      emit(PizzaLoadingState());

      await pizzaRepository.deletePizzaById(event.id);

      emit(PizzaDeletedState());
    } on StandardException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } on ApiResponseException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePizzaById(
    UpdatePizzaByIdEvent event,
    Emitter<PizzaState> emit,
  ) async {
    try {
      emit(PizzaLoadingState());

      await pizzaRepository.updatePizzaById(event.pizza);

      emit(PizzaUpdatedState());
    } on StandardException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } on ApiResponseException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createPizza(
    CreatePizzaEvent event,
    Emitter<PizzaState> emit,
  ) async {
    try {
      emit(PizzaLoadingState());

      await pizzaRepository.createPizza(event.pizza);

      emit(PizzaAddedState());
    } on StandardException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } on ApiResponseException catch (e) {
      emit(PizzaFetchedErrorState(e.message));
      emit(PizzaInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
