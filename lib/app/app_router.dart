import 'package:boole_apps/app/main_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/register_screen/register_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/splash_screen/splash_screen.dart';
import 'package:boole_apps/features/culture/presentation/screens/culture_screen.dart';
import 'package:boole_apps/features/home/presentation/home_screen.dart';
import 'package:boole_apps/features/destination/presentation/destination_screen.dart';
import 'package:boole_apps/features/destination/presentation/providers/destination_provider.dart';
import 'package:boole_apps/features/translate/presentation/translate_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/features/destination/domain/usecases/search_destinations_usecase.dart';
import 'package:boole_apps/features/destination/domain/entities/destination.dart';
import 'package:boole_apps/features/detail/presentation/detail_screen.dart';
import 'package:boole_apps/features/detail/presentation/providers/detail_provider.dart';
import 'package:boole_apps/features/detail/domain/usecases/get_destination_detail_usecase.dart';
import 'package:boole_apps/features/navigation/presentation/map_route_screen.dart';
import 'package:boole_apps/features/navigation/presentation/providers/route_provider.dart';
import 'package:boole_apps/features/navigation/domain/usecases/get_route_usecase.dart';
import 'package:boole_apps/features/navigation/presentation/navigation_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String main = '/main';
  static const String home = '/home';
  static const String destination = '/search';
  static const String detail = '/detail';
  static const String login = '/login';
  static const String register = '/register';
  static const String translate = '/translate';
  static const String mapRoute = '/mapRoute';
  static const String navigation = '/navigation';
  static const String culture = '/culture';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );

      case main:
        return MaterialPageRoute(
          builder: (_) => MainScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );

      case translate:
        return MaterialPageRoute(
          builder: (_) => TranslatePage(),
          settings: settings,
        );

      // ====== SEARCH ======
      case destination:
        {
          // opsional: bisa kirim arguments saat pushNamed
          // Navigator.pushNamed(context, AppRouter.search, arguments: {'prefill': 'Bali', 'popularOnly': true});
          final args = (settings.arguments is Map)
              ? settings.arguments as Map
              : const {};
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
                  latitude: d.latitude,
                  longitude: d.longitude,
                );
              }

              return ChangeNotifierProvider<DestinationProvider>(
                create: (_) =>
                    DestinationProvider(useCase: usecase, mapper: mapper)
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
      case culture:
        return MaterialPageRoute(builder: (_) => const CultureScreen());

      case navigation:
        return MaterialPageRoute(
          builder: (_) => const NavigationScreen(),
          settings: settings,
        );
      case mapRoute:
        final args = (settings.arguments is Map)
            ? settings.arguments as Map
            : const {};
        final double lat = (args['lat'] as num).toDouble();
        final double lng = (args['lng'] as num).toDouble();
        final String title = (args['title'] ?? 'Route') as String;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (context) =>
                RouteProvider(getRoute: context.read<GetRouteUsecase>()),
            child: MapRouteScreen(
              destinationLat: lat,
              destinationLng: lng,
              title: title,
            ),
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page not found'))),
          settings: settings,
        );
    }
  }
}
