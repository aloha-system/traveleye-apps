import 'package:boole_apps/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_imp.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/create_account_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/presentation/provider/auth_provider.dart';

// Feature Translation
import 'features/translate/data/datasources/translation_mock_datasource.dart';
import 'features/translate/data/datasources/translation_local_datasource.dart';
import 'features/translate/data/datasources/speech_mock_datasource.dart';
import 'features/translate/data/repositories/translation_repository_impl.dart';
import 'features/translate/domain/repositories/translation_repository.dart';
import 'features/translate/domain/usecases/translate_text_usecase.dart';
import 'features/translate/domain/usecases/speech_to_text_usecase.dart';
import 'features/translate/domain/usecases/text_to_speech_usecase.dart';
import 'features/translate/presentation/provider/translation_provider.dart';

class AppInjection {
  // Supabase REST constants (sementara hardcoded, nanti bisa diganti ke .env)
  static const String _supabaseDestinationsEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1/destinations';
  static const String _supabaseAnonKey =
      'REDACTED';

  static List<SingleChildWidget> providers() => [
        // ==============================
        // AUTH CHAIN
        // ==============================
        Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),

    // Auth Remote Data Source
    ProxyProvider<FirebaseAuth, AuthRemoteDatasource>(
      update: (_, firebaseAuth, __) => AuthRemoteDatasource(firebaseAuth),
    ),

    // Translation Data Sources (Mock implementations)
    Provider<TranslationMockDatasource>(create: (_) => const TranslationMockDatasource()),
    Provider<TranslationLocalDatasource>(create: (_) => TranslationLocalDatasource()),
    Provider<SpeechMockDatasource>(create: (_) => const SpeechMockDatasource()),

    // Auth Repository
    ProxyProvider<AuthRemoteDatasource, AuthRepository>(
      update: (_, remoteDatasource, __) => AuthRepositoryImp(remoteDatasource),
    ),

    // Translation Repository
    ProxyProvider3<TranslationMockDatasource, TranslationLocalDatasource, SpeechMockDatasource, TranslationRepository>(
      update: (_, remoteDatasource, localDatasource, speechDatasource, __) => 
          TranslationRepositoryImpl(remoteDatasource, localDatasource, speechDatasource),
    ),

    // Auth UseCases
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

    // Translation UseCases
    ProxyProvider<TranslationRepository, TranslateTextUsecase>(
      update: (_, repository, __) => TranslateTextUsecase(repository),
    ),
    ProxyProvider<TranslationRepository, SpeechToTextUsecase>(
      update: (_, repository, __) => SpeechToTextUsecase(repository),
    ),
    ProxyProvider<TranslationRepository, TextToSpeechUsecase>(
      update: (_, repository, __) => TextToSpeechUsecase(repository),
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

    // TranslationProvider
    ChangeNotifierProxyProvider3<
      TranslateTextUsecase,
      SpeechToTextUsecase,
      TextToSpeechUsecase,
      TranslationProvider
    >(
      create: (context) => TranslationProvider(
        translateTextUsecase: context.read<TranslateTextUsecase>(),
        speechToTextUsecase: context.read<SpeechToTextUsecase>(),
        textToSpeechUsecase: context.read<TextToSpeechUsecase>(),
      ),
      update: (_, translateText, speechToText, textToSpeech, translationProvider) =>
          translationProvider!,
    ),
  ];
}
