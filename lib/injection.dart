import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/single_child_widget.dart';

// ==== Feature Auth ====
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_imp.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/create_account_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';

// ==== Feature Search (Supabase REST) ====
import 'features/destination/data/datasources/destination_remote_datasource.dart';
import 'features/destination/data/repositories/destination_repository_impl.dart';
import 'features/destination/domain/repositories/destination_repository.dart';
import 'features/destination/domain/usecases/search_destinations_usecase.dart';

class AppInjection {
  // Supabase REST constants (AMAN untuk public anon key, tapi sebaiknya simpan via env/secret jika produksi)
  static const String _supabaseDestinationsEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1/destinations';
  static const String _supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvd2Z1eXRibWd4cGVvZ3NhaXdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAwNDI4NjYsImV4cCI6MjA3NTYxODg2Nn0.CF7lItv-9QRfTGaNbs3Wfoxx_92xm7OBr3K8zxKdEkI';

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
          update: (_, remoteDatasource, __) =>
              AuthRepositoryImp(remoteDatasource),
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
            AuthProvider>(
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

        // ==============================
        // SEARCH CHAIN (Supabase REST)
        // ==============================

        // DataSource -> panggil Supabase REST destinations
        Provider<DestinationRemoteDatasource>(
          create: (_) => DestinationRemoteDatasource(
            baseUrl: _supabaseDestinationsEndpoint,
            apiKey: _supabaseAnonKey,
          ),
        ),

        // Repository
        ProxyProvider<DestinationRemoteDatasource, DestinationRepository>(
          update: (_, ds, __) => DestinationRepositoryImpl(ds),
        ),

        // UseCase
        ProxyProvider<DestinationRepository, SearchDestinationsUsecase>(
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
