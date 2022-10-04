abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthConnectedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState(this.message);
}
