import 'package:boole_apps/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// ==== Feature Auth ====
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_imp.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/create_account_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';

// ==== Feature Search (Supabase REST) ====
import 'features/search/data/datasources/search_remote_datasource.dart';
import 'features/search/data/repositories/search_repository_impl.dart';
import 'features/search/domain/repositories/search_repository.dart';
import 'features/search/domain/usecases/search_destinations_usecase.dart';

class AppInjection {
  // Supabase REST constants (AMAN untuk public anon key, tapi sebaiknya simpan via env/secret jika produksi)
  static const String _supabaseDestinationsEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1/destinations';
  static const String _supabaseAnonKey =
      'REDACTED';

  static List<SingleChildWidget> providers() => [
    // ==============================
    // AUTH CHAIN
    // ==============================

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

    ProxyProvider<AuthRepository, CheckAuthStatusUsecase>(
      update: (_, repository, __) => CheckAuthStatusUsecase(repository),
    ),

    // AuthProvider
    ChangeNotifierProxyProvider5<
      CreateAccountUsecase,
      SignInUsecase,
      SignOutUsecase,
      ResetPasswordUsecase,
      CheckAuthStatusUsecase,
      AuthProvider
    >(
      create: (context) => AuthProvider(
        createAccountUsecase: context.read<CreateAccountUsecase>(),
        signInUsecase: context.read<SignInUsecase>(),
        signOutUsecase: context.read<SignOutUsecase>(),
        resetPasswordUsecase: context.read<ResetPasswordUsecase>(),
        checkAuthStatusUsecase: context.read<CheckAuthStatusUsecase>(),
      ),
      update:
          (
            _,
            createAccount,
            signIn,
            signOut,
            resetPassword,
            checkAuthStatus,
            authProvider,
          ) => authProvider!,
    ),

    // ==============================
    // SEARCH CHAIN (Supabase REST)
    // ==============================

    // DataSource -> panggil Supabase REST destinations
    Provider<SearchRemoteDatasource>(
      create: (_) => SearchRemoteDatasource(
        baseUrl: _supabaseDestinationsEndpoint,
        apiKey: _supabaseAnonKey,
      ),
    ),

    // Repository
    ProxyProvider<SearchRemoteDatasource, SearchRepository>(
      update: (_, ds, __) => SearchRepositoryImpl(ds),
    ),

    // UseCase
    ProxyProvider<SearchRepository, SearchDestinationsUsecase>(
      update: (_, repo, __) => SearchDestinationsUsecase(repo),
    ),

    // NOTE:
    // SearchNotifier (ChangeNotifier) tidak di-register di sini,
    // tapi dibuat per-route saat build SearchScreen di AppRouter:
    // ChangeNotifierProvider(
    //   create: (_) => SearchNotifier(useCase: context.read<SearchDestinationsUsecase>(), mapper: mapper)
    //     ..prefill(prefill)..setPopular(popularOnly),
    //   child: const SearchScreen(),
    // )
  ];
}
