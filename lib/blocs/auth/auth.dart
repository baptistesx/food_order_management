import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pom/blocs/auth/auth_events.dart';
import 'package:pom/blocs/auth/auth_states.dart';
import 'package:pom/models/exceptions.dart';
import 'package:pom/repositories/auth/auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  /// We can pass an initial state to allow use to manually fetching setting during launch
  AuthBloc(this.authRepository, {AuthState? initialState})
      : super(initialState ?? AuthInitialState()) {
    on<SignInEvent>(signIn);
    on<SignOutEvent>(signOut);
  }

  Future<void> signIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());

      await authRepository.signInWithGoogle();

      emit(AuthConnectedState());
    } on StandardException catch (e) {
      emit(AuthErrorState(e.message));
      emit(AuthInitialState());
    } on ApiResponseException catch (e) {
      emit(AuthErrorState(e.message));
      emit(AuthInitialState());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());

      await authRepository.signOut();

      emit(AuthConnectedState());
    } on StandardException catch (e) {
      emit(AuthErrorState(e.message));
      emit(AuthInitialState());
    } on ApiResponseException catch (e) {
      emit(AuthErrorState(e.message));
      emit(AuthInitialState());
    } catch (e) {
      rethrow;
    }
  }
}
