part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class LoadUserData extends AuthenticationEvent {}

class LogOut extends AuthenticationEvent {}
