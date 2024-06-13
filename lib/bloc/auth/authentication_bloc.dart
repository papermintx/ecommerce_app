import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:e_apps/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final storage = const FlutterSecureStorage();

  final String url = 'https://api.escuelajs.co/api/v1/auth/login';

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoadUserData>((event, emit) async {
      emit(AuthLoading());

      try {
        final token = await storage.read(key: 'token');
        final refreshToken = await storage.read(key: 'refreshToken');

        if (token != null && refreshToken != null) {
          emit(Authenticated(token: token, refreshToken: refreshToken));
          final response = await http.get(
            Uri.parse('https://api.escuelajs.co/api/v1/auth/profile'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final user = UserModel.fromJson(data);
            emit(UserLoaded(user: user));
          } else {
            emit(AuthError(
                message:
                    'Server error${response.statusCode} ${response.body}'));
          }
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await http.post(Uri.parse(url), body: {
          'email': event.email,
          'password': event.password,
        });

        if (response.statusCode == 201) {
          final data = json.decode(response.body);
          final token = data['access_token'];
          final refreshToken = data['refresh_token'];
          await storage.write(key: 'token', value: token);
          await storage.write(key: 'refreshToken', value: refreshToken);
          emit(AuthSuccess());
        } else {
          if (kDebugMode) {
            print(response.body);
            print(response.statusCode);
          }
          emit(AuthError(message: 'Server error 1'));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    on<LogOut>((event, emit) async {
      emit(AuthLoading());
      try {
        await storage.delete(key: 'token');
        await storage.delete(key: 'refreshToken');
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });
  }
}
