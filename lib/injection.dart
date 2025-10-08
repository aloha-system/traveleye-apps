import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/single_child_widget.dart';

// Feature Auth
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_imp.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/create_account_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';

class AppInjection {
  static List<SingleChildWidget> providers() => [
    // Firebase Auth instance
    Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),

    // Remote Data Source
    ProxyProvider<FirebaseAuth, AuthRemoteDatasource>(
      update: (_, firebaseAuth, __) => AuthRemoteDatasource(firebaseAuth),
    ),

    // Repository
    ProxyProvider<AuthRemoteDatasource, AuthRepository>(
      update: (_, remoteDatasource, __) => AuthRepositoryImp(remoteDatasource),
    ),

    // UseCases
    ProxyProvider<AuthRepository, CreateAccountUsecase>(
      update: (_, repository, __) => CreateAccountUsecase(repository),
    ),
    ProxyProvider<AuthRepository, SignInUsecase>(
      update: (_, repository, __) => SignInUsecase(repository),
    ),
    ProxyProvider<AuthRepository, SignOutUsecase>(
      update: (_, repository, __) => SignOutUsecase(repository),
    ),
    ProxyProvider<AuthRepository, ResetPasswordUsecase>(
      update: (_, repository, __) => ResetPasswordUsecase(repository),
    ),

    // AuthProvider
    ChangeNotifierProxyProvider4<
      CreateAccountUsecase,
      SignInUsecase,
      SignOutUsecase,
      ResetPasswordUsecase,
      AuthProvider
    >(
      create: (context) => AuthProvider(
        createAccountUsecase: context.read<CreateAccountUsecase>(),
        signInUsecase: context.read<SignInUsecase>(),
        signOutUsecase: context.read<SignOutUsecase>(),
        resetPasswordUsecase: context.read<ResetPasswordUsecase>(),
      ),
      update:
          (_, createAccount, signIn, signOut, resetPassword, authProvider) =>
              authProvider!,
    ),
  ];
}
