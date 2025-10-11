import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';
import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthStatusUsecase {
  final AuthRepository repository;

  const CheckAuthStatusUsecase(this.repository);

  Future<UserEntity?> call() {
    return repository.getCurrentUser();
  }
}
