import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';

enum AuthStatus { initial, loading, success, error }

class AuthState {
  final AuthStatus status;
  final String? message;
  final UserEntity? user;

  const AuthState({this.status = AuthStatus.initial, this.message, this.user});

  AuthState copyWith({AuthStatus? status, String? message, UserEntity? user}) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }
}
