import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';
import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class SignInUsecase {
  final AuthRepository repository;

  const SignInUsecase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    return repository.signIn(email, password);
  }
}
