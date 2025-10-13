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

// ==== Feature Destination (Search) ====
import 'features/destination/data/datasources/destination_remote_datasource.dart';
import 'features/destination/data/repositories/destination_repository_impl.dart';
import 'features/destination/domain/repositories/destination_repository.dart';
import 'features/destination/domain/usecases/search_destinations_usecase.dart';

// ==== Feature Detail ====
import 'features/detail/data/datasources/detail_remote_datasource.dart';
import 'features/detail/data/repositories/detail_repository_impl.dart';
import 'features/detail/domain/repositories/detail_repository.dart';
import 'features/detail/domain/usecases/get_destination_detail_usecase.dart';
import 'features/detail/presentation/providers/detail_provider.dart';

class AppInjection {
  // Supabase REST constants (sementara hardcoded, nanti bisa diganti ke .env)
  static const String _supabaseDestinationsEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1/destinations';
  static const String _supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZvd2Z1eXRibWd4cGVvZ3NhaXdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjAwNDI4NjYsImV4cCI6MjA3NTYxODg2Nn0.CF7lItv-9QRfTGaNbs3Wfoxx_92xm7OBr3K8zxKdEkI';

  static List<SingleChildWidget> providers() => [
        // ==============================
        // AUTH CHAIN
        // ==============================
        Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),

        ProxyProvider<FirebaseAuth, AuthRemoteDatasource>(
          update: (_, firebaseAuth, __) => AuthRemoteDatasource(firebaseAuth),
        ),

        ProxyProvider<AuthRemoteDatasource, AuthRepository>(
          update: (_, remoteDatasource, __) =>
              AuthRepositoryImp(remoteDatasource),
        ),

        ProxyProvider<AuthRepository, CreateAccountUsecase>(
          update: (_, repo, __) => CreateAccountUsecase(repo),
        ),
        ProxyProvider<AuthRepository, SignInUsecase>(
          update: (_, repo, __) => SignInUsecase(repo),
        ),
        ProxyProvider<AuthRepository, SignOutUsecase>(
          update: (_, repo, __) => SignOutUsecase(repo),
        ),
        ProxyProvider<AuthRepository, ResetPasswordUsecase>(
          update: (_, repo, __) => ResetPasswordUsecase(repo),
        ),
        ProxyProvider<AuthRepository, CheckAuthStatusUsecase>(
          update: (_, repo, __) => CheckAuthStatusUsecase(repo),
        ),

        ChangeNotifierProxyProvider5<
            CreateAccountUsecase,
            SignInUsecase,
            SignOutUsecase,
            ResetPasswordUsecase,
            CheckAuthStatusUsecase,
            AuthProvider>(
          create: (context) => AuthProvider(
            createAccountUsecase: context.read<CreateAccountUsecase>(),
            signInUsecase: context.read<SignInUsecase>(),
            signOutUsecase: context.read<SignOutUsecase>(),
            resetPasswordUsecase: context.read<ResetPasswordUsecase>(),
            checkAuthStatusUsecase: context.read<CheckAuthStatusUsecase>(),
          ),
          update: (_, a, b, c, d, e, authProvider) => authProvider!,
        ),

        // ==============================
        // DESTINATION (SEARCH) CHAIN
        // ==============================
        Provider<DestinationRemoteDatasource>(
          create: (_) => DestinationRemoteDatasource(
            baseUrl: _supabaseDestinationsEndpoint,
            apiKey: _supabaseAnonKey,
          ),
        ),

        ProxyProvider<DestinationRemoteDatasource, DestinationRepository>(
          update: (_, ds, __) => DestinationRepositoryImpl(ds),
        ),

        ProxyProvider<DestinationRepository, SearchDestinationsUsecase>(
          update: (_, repo, __) => SearchDestinationsUsecase(repo),
        ),

        // ==============================
        // DETAIL CHAIN (Supabase REST)
        // ==============================
        Provider<DetailRemoteDatasource>(
          create: (_) => DetailRemoteDatasourceImpl(
            baseUrl: _supabaseDestinationsEndpoint,
            apiKey: _supabaseAnonKey,
          ),
        ),

        ProxyProvider<DetailRemoteDatasource, DetailRepository>(
          update: (_, ds, __) => DetailRepositoryImpl(ds),
        ),

        ProxyProvider<DetailRepository, GetDestinationDetailUsecase>(
          update: (_, repo, __) => GetDestinationDetailUsecase(repo),
        ),

        ChangeNotifierProxyProvider<GetDestinationDetailUsecase, DetailNotifier>(
          create: (context) => DetailNotifier(
            getDetail: context.read<GetDestinationDetailUsecase>(),
          ),
          update: (_, usecase, notifier) => notifier!..getDetail,
        ),
      ];
}
