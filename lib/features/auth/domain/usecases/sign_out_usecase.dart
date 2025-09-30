import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class SignOutUsecase {
  final AuthRepository repository;

  const SignOutUsecase(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}
