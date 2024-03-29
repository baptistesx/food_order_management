import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fom/blocs/auth/auth_events.dart';
import 'package:fom/blocs/auth/auth_states.dart';
import 'package:fom/models/exceptions.dart';
import 'package:fom/repositories/auth/auth.dart';

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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        emit(
          AuthErrorState(
            'Des crédentials différents sont déjà utiliés pour ce compte',
          ),
        );
        emit(AuthInitialState());
      } else if (e.code == 'invalid-credential') {
        emit(AuthErrorState('Credentials invalides'));
        emit(AuthInitialState());
      }
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

      emit(AuthInitialState());
    } on StandardException catch (e) {
      emit(AuthErrorState(e.message));
      emit(AuthConnectedState());
    } on ApiResponseException catch (e) {
      emit(AuthErrorState(e.message));
      emit(AuthConnectedState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        emit(
          AuthErrorState(
            'The account already exists with a different credential.',
          ),
        );
        emit(AuthConnectedState());
      } else if (e.code == 'invalid-credential') {
        emit(
          AuthErrorState(
            'Error occurred while accessing credentials. Try again.',
          ),
        );
        emit(AuthConnectedState());
      }
    } catch (e) {
      rethrow;
    }
  }
}
