import 'package:boole_apps/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:boole_apps/features/auth/domain/entities/user_entity.dart';
import 'package:boole_apps/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImp implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  const AuthRepositoryImp(this.remoteDatasource);

  @override
  Future<UserEntity> signIn(String email, String password) async {
    final user = await remoteDatasource.signIn(email, password);

    return UserEntity(uid: user.uid, email: user.email ?? '');
  }
}
