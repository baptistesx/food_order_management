import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/meals/meals_events.dart';
import 'package:fom/blocs/meals/meals_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/models/meal.dart';
import 'package:fom/repositories/meals/meals.dart';

class MealsBloc extends Bloc<MealsEvent, MealsState> {
  final MealsRepository mealsRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  MealsBloc(this.mealsRepository, {MealsState? initialState})
      : super(initialState ?? MealsInitialState()) {
    on<GetMealsEvent>(getMeals);
  }

  Future<void> getMeals(
    GetMealsEvent event,
    Emitter<MealsState> emit,
  ) async {
    try {
      emit(MealsLoadingState());

      final List<Meal> meals = await mealsRepository.getMeals();

      emit(MealsFetchedState(meals: meals));
    } on StandardException catch (e) {
      emit(MealsFetchedErrorState(e.message));
      emit(MealsInitialState());
    } on ApiResponseException catch (e) {
      emit(MealsFetchedErrorState(e.message));
      emit(MealsInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
