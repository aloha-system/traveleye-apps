import 'package:boole_apps/app/main_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/login_screen/login_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/register_screen/register_screen.dart';
import 'package:boole_apps/features/auth/presentation/screens/splash_screen/splash_screen.dart';
import 'package:boole_apps/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String main = '/main';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case main:
        return MaterialPageRoute(builder: (_) => MainScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('404 - Page not found'))),
        );
    }
  }
}
