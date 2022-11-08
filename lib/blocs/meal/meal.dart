import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/meal/meal_events.dart';
import 'package:fom/blocs/meal/meal_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/repositories/meal/meal.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository mealRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  MealBloc(this.mealRepository, {MealState? initialState})
      : super(initialState ?? MealInitialState()) {
    on<CreateMealEvent>(createMeal);
    on<GetMealByIdEvent>(getMealById);
    on<UpdateMealByIdEvent>(updateMealById);
    on<DeleteMealByIdEvent>(deleteMealById);
  }

  Future<void> getMealById(
    GetMealByIdEvent event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(MealLoadingState());

      final Meal meal = await mealRepository.getMealById(event.id);

      emit(MealFetchedState(meal: meal));
    } on StandardException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } on ApiResponseException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteMealById(
    DeleteMealByIdEvent event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(MealLoadingState());

      await mealRepository.deleteMealById(event.id);

      emit(MealDeletedState());
      emit(MealInitialState());
    } on StandardException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } on ApiResponseException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMealById(
    UpdateMealByIdEvent event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(MealLoadingState());

      await mealRepository.updateMealById(event.meal);

      emit(MealUpdatedState());
      emit(MealInitialState());
    } on StandardException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } on ApiResponseException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createMeal(
    CreateMealEvent event,
    Emitter<MealState> emit,
  ) async {
    try {
      emit(MealLoadingState());

      await mealRepository.createMeal(event.meal);

      emit(MealAddedState());
      emit(MealInitialState());
    } on StandardException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } on ApiResponseException catch (e) {
      emit(MealFetchedErrorState(e.message));
      emit(MealInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
