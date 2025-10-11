import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';
import 'package:boole_apps/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:boole_apps/features/auth/domain/usecases/create_account_usecase.dart';
import 'package:boole_apps/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:boole_apps/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:boole_apps/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_state.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final CreateAccountUsecase createAccountUsecase;
  final SignInUsecase signInUsecase;
  final SignOutUsecase signOutUsecase;
  final ResetPasswordUsecase resetPasswordUsecase;
  final CheckAuthStatusUsecase checkAuthStatusUsecase;

  AuthProvider({
    required this.createAccountUsecase,
    required this.signInUsecase,
    required this.signOutUsecase,
    required this.resetPasswordUsecase,
    required this.checkAuthStatusUsecase,
  });

  AuthState _state = AuthState();
  AuthState get state => _state;

  UserEntity? _user;
  UserEntity? get user => _user;

  void _emit(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  // check auth status trigger method
  Future<void> _checkAuthStatus() async {
    final user = await checkAuthStatusUsecase();

    if (user != null) {
      _state = state.copyWith(status: AuthStatus.success, user: user);
    } else {
      _state = state.copyWith(status: AuthStatus.initial);
    }
    notifyListeners();
  }

  // create account trigger method
  Future<void> createAccount(String email, String password, String name) async {
    _state = _state.copyWith(status: AuthStatus.loading);
    notifyListeners();

    try {
      _user = await createAccountUsecase.call(
        email: email,
        password: password,
        name: name,
      );
      _state = _state.copyWith(status: AuthStatus.success);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, message: e.toString());
    } finally {
      notifyListeners();
    }
  }

  // sign in trigger method
  Future<void> signIn(String email, String password) async {
    _state = _state.copyWith(status: AuthStatus.loading);
    notifyListeners();

    try {
      _user = await signInUsecase.call(email, password);
      _state = _state.copyWith(status: AuthStatus.success);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, message: e.toString());
    } finally {
      notifyListeners();
    }
  }

  // sign out trigger method
  Future<void> signOut() async {
    _state = _state.copyWith(status: AuthStatus.loading);
    notifyListeners();

    try {
      await signOutUsecase.call();
      _user = null;
      _state = _state.copyWith(status: AuthStatus.success);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, message: e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _state = _state.copyWith(status: AuthStatus.loading);
    notifyListeners();

    try {
      await resetPasswordUsecase.call(email: email);
      _state = _state.copyWith(status: AuthStatus.success);
    } catch (e) {
      _state = _state.copyWith(status: AuthStatus.error, message: e.toString());
    } finally {
      notifyListeners();
    }
  }
}
