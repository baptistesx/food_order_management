import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/ingredients/ingredients_events.dart';
import 'package:pom/blocs/ingredients/ingredients_states.dart';
import 'package:pom/models/exceptions.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/repositories/ingredients/ingredients.dart';

class IngredientsBloc extends Bloc<IngredientsEvent, IngredientsState> {
  final IngredientsRepository ingredientsRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  IngredientsBloc(this.ingredientsRepository, {IngredientsState? initialState})
      : super(initialState ?? IngredientsInitialState()) {
    on<GetIngredientsEvent>(getIngredients);
  }

  Future<void> getIngredients(
    GetIngredientsEvent event,
    Emitter<IngredientsState> emit,
  ) async {
    try {
      emit(IngredientsLoadingState());

      final List<Ingredient> ingredients =
          await ingredientsRepository.getIngredients();

      emit(IngredientsFetchedState(ingredients: ingredients));
    } on StandardException catch (e) {
      emit(IngredientsFetchedErrorState(e.message));
      emit(IngredientsInitialState());
    } on ApiResponseException catch (e) {
      emit(IngredientsFetchedErrorState(e.message));
      emit(IngredientsInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
