import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final UserEntity? user;

  const AuthState({this.status = AuthStatus.initial, this.message, this.user});

  bool get isLoading => status == AuthStatus.loading;
  bool get isSuccess => status == AuthStatus.success;
  bool get isError => status == AuthStatus.error;

  AuthState copyWith({AuthStatus? status, String? message, UserEntity? user}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}

