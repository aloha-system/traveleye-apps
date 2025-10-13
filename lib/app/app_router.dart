import 'package:boole_apps/app/main_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/register_screen/register_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/splash_screen/splash_screen.dart';
import 'package:boole_apps/features/home/presentation/home_screen.dart';
import 'package:boole_apps/features/translate/presentation/translate_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/features/destination/domain/usecases/search_destinations_usecase.dart';
import 'package:boole_apps/features/destination/domain/entities/destination.dart';
import 'package:boole_apps/features/detail/presentation/detail_screen.dart';
import 'package:boole_apps/features/detail/presentation/providers/detail_provider.dart';
import 'package:boole_apps/features/detail/domain/usecases/get_destination_detail_usecase.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String main = '/main';
  static const String home = '/home';
  static const String destination = '/search';
  static const String detail = '/detail';
  static const String login = '/login';
  static const String register = '/register';
  static const String translate = '/translate';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen(), settings: settings);

      case main:
        return MaterialPageRoute(builder: (_) => MainScreen(), settings: settings);

      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen(), settings: settings);

      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen(), settings: settings);

      // ====== SEARCH ======
      case destination: {
        // opsional: bisa kirim arguments saat pushNamed
        // Navigator.pushNamed(context, AppRouter.search, arguments: {'prefill': 'Bali', 'popularOnly': true});
        final args = (settings.arguments is Map) ? settings.arguments as Map : const {};
        final String prefill = (args['prefill'] ?? '') as String;
        final bool popularOnly = (args['popularOnly'] ?? false) as bool;

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            // Ambil usecase dari DI
            final usecase = context.read<SearchDestinationsUsecase>();

            // Mapper dari entity → item UI
            SearchItem mapper(Object e) {
              final d = e as Destination;
              return SearchItem(
                id: d.id,
                name: d.name,
                location: '${d.city}, ${d.province}',
                imageUrl: d.imageUrls.isNotEmpty ? d.imageUrls.first : '',
                ratingText: d.rating.toStringAsFixed(1),
              );
            }

            return ChangeNotifierProvider<DestinationProvider>(
              create: (_) => DestinationProvider(useCase: usecase, mapper: mapper)
                ..prefill(prefill)
                ..setPopular(popularOnly),
              child: const SearchScreen(),
            );
          },
        );
      }

      case '/detail':
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (context) => DetailNotifier(
                getDetail: context.read<GetDestinationDetailUsecase>(),
              )..fetch(args),
              child: DetailScreen(id: args),
            ),
          );
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      case translate:
        return MaterialPageRoute(builder: (_) => const TranslatePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Page not found')),
          ),
          settings: settings,
        );
    }
  }
}
