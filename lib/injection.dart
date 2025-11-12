// ==== Feature Emergency ====
import 'package:boole_apps/core/data/datasources/gemini_remote_datasource.dart';
import 'package:boole_apps/features/culture/domain/usecases/search_culture_usecase.dart';
import 'package:boole_apps/features/destination/data/repositories/gen_culture_repository_impl.dart';
import 'package:boole_apps/features/destination/domain/repositories/gen_culture_repository.dart';
import 'package:boole_apps/features/destination/domain/usecases/gen_culture_usecase.dart';
import 'package:boole_apps/features/emergency/data/datasources/e_services_remote_datasource.dart';
import 'package:boole_apps/features/emergency/data/repositories/emergency_services_repsitory_impl.dart';
import 'package:boole_apps/features/emergency/domain/repositories/emergency_repository.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_all_services_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_priority_services_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_service_by_id_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/get_services_by_category_usecase.dart';
import 'package:boole_apps/features/emergency/domain/usecases/search_services_usecase.dart';
import 'package:boole_apps/features/emergency/presentation/provider/emergency_provider.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

// ==== Feature Culture ====
import 'package:boole_apps/env/env.dart';
import 'package:boole_apps/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:boole_apps/features/culture/data/datasource/culture_remote_datasource.dart';
import 'package:boole_apps/features/culture/data/repositories/culture_repository_imp.dart';
import 'package:boole_apps/features/culture/domain/repositories/culture_repository.dart';
import 'package:boole_apps/features/culture/domain/usecases/get_culture_by_id_usecase.dart';
import 'package:boole_apps/features/culture/domain/usecases/get_culture_usecase.dart';
import 'package:boole_apps/features/culture/presentation/provider/culture_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ==== Feature Auth ====
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_imp.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/create_account_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/sign_in_with_google_usecase.dart';
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

// ==== Feature Translation ====
import 'package:translator/translator.dart';
import 'features/translate/data/datasources/translation_remote_datasource.dart';
import 'features/translate/data/datasources/translation_local_datasource.dart';
import 'features/translate/data/datasources/speech_datasource.dart';
import 'features/translate/data/repositories/translation_repository_impl.dart';
import 'features/translate/domain/repositories/translation_repository.dart';
import 'features/translate/domain/usecases/translate_text_usecase.dart';
import 'features/translate/domain/usecases/speech_to_text_usecase.dart';
import 'features/translate/domain/usecases/text_to_speech_usecase.dart';
import 'features/translate/presentation/provider/translation_provider.dart';

// ==== Feature Navigation (Directions) ====
import 'features/navigation/data/datasources/directions_remote_datasource.dart';
import 'features/navigation/data/repositories/directions_repository_impl.dart';
import 'features/navigation/domain/repositories/directions_repository.dart';
import 'features/navigation/domain/usecases/get_route_usecase.dart';

class AppInjection {
  // Supabase REST constants (sementara hardcoded, nanti bisa diganti ke .env)
  static const String _supabaseDestinationsEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1/destinations';
  static const String _supabaseAnonKey = Env.supabaseApiKey;
  static const String _supabaseCultureEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1/culture';
  static const String _supabaseEmergencyEndpoint =
      'https://fowfuytbmgxpeogsaiwk.supabase.co/rest/v1';

  static final GenerativeModel _cultureGenModel = GenerativeModel(
    model: Env.geminiCultureModel,
    apiKey: Env.geminiCultureApiKey,
  );

  static final GenerativeModel _defaultModel = GenerativeModel(
    model: Env.geminiCultureModel,
    apiKey: Env.geminiCultureApiKey,
  );

  static List<SingleChildWidget> providers() => [
    // ==============================
    // GENERATIVE CULTURE (GEMINI) CHAIN
    // ==============================
    Provider<GeminiRemoteDataSource>(
      create: (_) => GeminiRemoteDataSourceImpl(_cultureGenModel),
    ),
    ProxyProvider<GeminiRemoteDataSource, GenCultureRepository>(
      update: (_, remote, __) => GenCultureRepositoryImpl(remote),
    ),
    ProxyProvider<GenCultureRepository, GenCultureUsecase>(
      update: (_, repo, __) => GenCultureUsecase(repo),
    ),

    // ==============================
    // AUTH CHAIN
    // ==============================
    Provider<FirebaseAuth>(create: (_) => FirebaseAuth.instance),

    Provider<GoogleSignIn>(create: (_) => GoogleSignIn()),

    ProxyProvider2<FirebaseAuth, GoogleSignIn, AuthRemoteDatasource>(
      update: (_, firebaseAuth, googleSignIn, __) =>
          AuthRemoteDatasource(firebaseAuth, googleSignIn),
    ),

    ProxyProvider<AuthRemoteDatasource, AuthRepository>(
      update: (_, remoteDatasource, __) => AuthRepositoryImp(remoteDatasource),
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
    ProxyProvider<AuthRepository, SignInWithGoogleUsecase>(
      update: (_, repo, __) => SignInWithGoogleUsecase(repo),
    ),

    ChangeNotifierProxyProvider6<
      CreateAccountUsecase,
      SignInUsecase,
      SignOutUsecase,
      ResetPasswordUsecase,
      CheckAuthStatusUsecase,
      SignInWithGoogleUsecase,
      AuthProvider
    >(
      create: (context) => AuthProvider(
        createAccountUsecase: context.read<CreateAccountUsecase>(),
        signInUsecase: context.read<SignInUsecase>(),
        signOutUsecase: context.read<SignOutUsecase>(),
        resetPasswordUsecase: context.read<ResetPasswordUsecase>(),
        checkAuthStatusUsecase: context.read<CheckAuthStatusUsecase>(),
        signInWithGoogleUsecase: context.read<SignInWithGoogleUsecase>(),
      ),
      update: (_, a, b, c, d, e, f, authProvider) => authProvider!,
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

    // ==============================
    // TRANSLATION CHAIN
    // ==============================
    // Speech Services
    Provider<SpeechToText>(create: (_) => SpeechToText()),
    Provider<FlutterTts>(create: (_) => FlutterTts()),

    // Translation Data Sources
    Provider<GoogleTranslator>(create: (_) => GoogleTranslator()),
    Provider<TranslationRemoteDatasource>(
      create: (context) =>
          TranslationRemoteDatasource(context.read<GoogleTranslator>()),
    ),
    Provider<TranslationLocalDatasource>(
      create: (_) => TranslationLocalDatasource(),
    ),
    ProxyProvider2<SpeechToText, FlutterTts, SpeechDatasource>(
      update: (_, speechToText, flutterTts, __) =>
          SpeechDatasource(flutterTts, speechToText),
    ),

    ProxyProvider3<
      TranslationRemoteDatasource,
      TranslationLocalDatasource,
      SpeechDatasource,
      TranslationRepository
    >(
      update: (_, remoteDatasource, localDatasource, speechDatasource, __) =>
          TranslationRepositoryImpl(
            remoteDatasource,
            localDatasource,
            speechDatasource,
          ),
    ),

    ProxyProvider<TranslationRepository, TranslateTextUsecase>(
      update: (_, repository, __) => TranslateTextUsecase(repository),
    ),
    ProxyProvider<TranslationRepository, SpeechToTextUsecase>(
      update: (_, repository, __) => SpeechToTextUsecase(repository),
    ),
    ProxyProvider<TranslationRepository, TextToSpeechUsecase>(
      update: (_, repository, __) => TextToSpeechUsecase(repository),
    ),

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
      update:
          (_, translateText, speechToText, textToSpeech, translationProvider) =>
              translationProvider!,
    ),

    // ==============================
    // CULTURE CHAIN (Supabase REST)
    // ==============================
    Provider(
      create: (_) => CultureRemoteDatasource(
        baseUrl: _supabaseCultureEndpoint,
        apiKey: _supabaseAnonKey,
      ),
    ),

    ProxyProvider<CultureRemoteDatasource, CultureRepository>(
      update: (_, cultureDataSource, __) =>
          CultureRepositoryImp(cultureDataSource),
    ),

    ProxyProvider<CultureRepository, GetCultureUsecase>(
      update: (_, repository, __) => GetCultureUsecase(repository),
    ),

    ProxyProvider<CultureRepository, GetCultureByIdUsecase>(
      update: (_, repository, __) => GetCultureByIdUsecase(repository),
    ),

    ProxyProvider<CultureRepository, SearchCultureUsecase>(
      update: (_, repository, __) => SearchCultureUsecase(repository),
    ),

    ChangeNotifierProxyProvider3<
      GetCultureUsecase,
      GetCultureByIdUsecase,
      SearchCultureUsecase,
      CultureProvider
    >(
      create: (context) => CultureProvider(
        getCultureUsecase: context.read<GetCultureUsecase>(),
        getCultureByIdUsecase: context.read<GetCultureByIdUsecase>(),
        searchCultureUsecase: context.read<SearchCultureUsecase>(),
      ),
      update:
          (
            _,
            getCultureUsecase,
            getCultureByIdUsecase,
            searchCultureUsecase,
            provider,
          ) => provider!,
    ),

    // ==============================
    // NAVIGATION / DIRECTIONS CHAIN
    // ==============================
    Provider<DirectionsRemoteDatasource>(
      create: (_) => DirectionsRemoteDatasource(),
    ),
    ProxyProvider<DirectionsRemoteDatasource, DirectionsRepository>(
      update: (_, remote, __) => DirectionsRepositoryImpl(remote),
    ),
    ProxyProvider<DirectionsRepository, GetRouteUsecase>(
      update: (_, repo, __) => GetRouteUsecase(repo),
    ),

    // ==============================
    // EMERGENCY NUMBERS CHAIN
    // ==============================

    // HTTP Client (shared)
    Provider<http.Client>(create: (_) => http.Client()),

    // Datasource
    Provider<EmergencyRemoteDatasource>(
      create: (context) => EmergencyRemoteDatasourceImpl(
        baseUrl: _supabaseEmergencyEndpoint,
        apiKey: _supabaseAnonKey,
        client: context.read<http.Client>(),
      ),
    ),

    // Repository
    ProxyProvider<EmergencyRemoteDatasource, EmergencyRepository>(
      update: (_, datasource, __) => EmergencyRepositoryImpl(datasource),
    ),

    // Usecases
    ProxyProvider<EmergencyRepository, GetAllServicesUsecase>(
      update: (_, repository, __) => GetAllServicesUsecase(repository),
    ),
    ProxyProvider<EmergencyRepository, GetServicesByCategoryUsecase>(
      update: (_, repository, __) => GetServicesByCategoryUsecase(repository),
    ),
    ProxyProvider<EmergencyRepository, SearchServicesUsecase>(
      update: (_, repository, __) => SearchServicesUsecase(repository),
    ),
    ProxyProvider<EmergencyRepository, GetPriorityServicesUsecase>(
      update: (_, repository, __) => GetPriorityServicesUsecase(repository),
    ),
    ProxyProvider<EmergencyRepository, GetServiceByIdUsecase>(
      update: (_, repository, __) => GetServiceByIdUsecase(repository),
    ),

    // Provider
    ChangeNotifierProxyProvider5<
      GetAllServicesUsecase,
      GetServicesByCategoryUsecase,
      SearchServicesUsecase,
      GetPriorityServicesUsecase,
      GetServiceByIdUsecase,
      EmergencyProvider
    >(
      create: (context) => EmergencyProvider(
        getAllServicesUsecase: context.read<GetAllServicesUsecase>(),
        getServicesByCategoryUsecase: context
            .read<GetServicesByCategoryUsecase>(),
        searchServicesUsecase: context.read<SearchServicesUsecase>(),
        getPriorityServicesUsecase: context.read<GetPriorityServicesUsecase>(),
        getServiceByIdUsecase: context.read<GetServiceByIdUsecase>(),
      ),
      update: (_, a, b, c, d, e, provider) => provider!,
    ),
  ];
}
