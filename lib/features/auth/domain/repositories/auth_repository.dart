import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> createAccount({
    required String email,
    required String password,
    required String name,
  });

  Future<UserEntity> signIn(String email, String password);

  Future<void> signOut();
}
