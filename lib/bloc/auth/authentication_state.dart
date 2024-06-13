part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthLoading extends AuthenticationState {}

final class AuthUnauthenticated extends AuthenticationState {}

final class AuthSuccess extends AuthenticationState {}

final class Authenticated extends AuthenticationState {
  final String token;
  final String refreshToken;
  Authenticated({
    required this.token,
    required this.refreshToken,
  });
}

final class AuthError extends AuthenticationState {
  final String message;
  AuthError({
    required this.message,
  });
}

final class UserLoaded extends AuthenticationState {
  final UserModel user;
  UserLoaded({
    required this.user,
  });
}
