import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/ingredient/ingredient_events.dart';
import 'package:pom/blocs/ingredient/ingredient_states.dart';
import 'package:pom/models/exceptions.dart';
import 'package:pom/models/ingredient.dart';
import 'package:pom/repositories/ingredient/ingredient.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final IngredientRepository ingredientRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  IngredientBloc(this.ingredientRepository, {IngredientState? initialState})
      : super(initialState ?? IngredientInitialState()) {
    on<CreateIngredientEvent>(createIngredient);
    on<GetIngredientByIdEvent>(getIngredientById);
    on<UpdateIngredientByIdEvent>(updateIngredientById);
    on<DeleteIngredientByIdEvent>(deleteIngredientById);
  }

  Future<void> getIngredientById(
    GetIngredientByIdEvent event,
    Emitter<IngredientState> emit,
  ) async {
    try {
      emit(IngredientLoadingState());

      final Ingredient ingredient =
          await ingredientRepository.getIngredientById(event.id);

      emit(IngredientFetchedState(ingredient: ingredient));
    } on StandardException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } on ApiResponseException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteIngredientById(
    DeleteIngredientByIdEvent event,
    Emitter<IngredientState> emit,
  ) async {
    try {
      emit(IngredientLoadingState());

      await ingredientRepository.deleteIngredientById(event.id);

      emit(IngredientDeletedState());
    } on StandardException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } on ApiResponseException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateIngredientById(
    UpdateIngredientByIdEvent event,
    Emitter<IngredientState> emit,
  ) async {
    try {
      emit(IngredientLoadingState());

      await ingredientRepository.updateIngredientById(event.ingredient);

      emit(IngredientUpdatedState());
    } on StandardException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } on ApiResponseException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createIngredient(
    CreateIngredientEvent event,
    Emitter<IngredientState> emit,
  ) async {
    try {
      emit(IngredientLoadingState());

      await ingredientRepository.createIngredient(event.ingredient);

      emit(IngredientAddedState());
    } on StandardException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } on ApiResponseException catch (e) {
      emit(IngredientFetchedErrorState(e.message));
      emit(IngredientInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
