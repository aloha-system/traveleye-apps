import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';
import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUsecase {
  final AuthRepository repository;

  const SignInWithGoogleUsecase(this.repository);

  Future<UserEntity> call() {
    return repository.signInWithGoogle();
  }
}
