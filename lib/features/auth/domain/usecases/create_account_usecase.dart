import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';
import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class CreateAccountUsecase {
  final AuthRepository repository;
  const CreateAccountUsecase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String name,
  }) async {
    return repository.createAccount(
      email: email,
      password: password,
      name: name,
    );
  }
}
