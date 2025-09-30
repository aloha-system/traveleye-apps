import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUsecase {
  final AuthRepository repository;

  const ResetPasswordUsecase(this.repository);

  Future<void> call({required String email}) async {
    return repository.resetPassword(email);
  }
}
