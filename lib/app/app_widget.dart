import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/core/theme/app_theme.dart';
import 'package:boole_apps/core/theme/util/text_theme_util.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'Montserrat', 'Poppins');
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: theme.light(),
      darkTheme: theme.dark(),
      debugShowCheckedModeBanner: false,
      title: 'Boole Mobile Application',
      initialRoute: AppRouter.main,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
