import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_provider.dart';
import 'package:boole_apps/features/auth/presentation/screens/splash_screen/components/splash_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final int index;

  const SplashScreen({super.key, this.index = 0});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late int currentPage;
  VoidCallback? _authListener;
  bool _navigated = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();

      authProvider.checkAuthStatus();

      _authListener = () async {
        final state = authProvider.state;
        if (_navigated) return;

        if (state.isSuccess) {
          // Briefly show splash before navigating to Home if already authenticated
          // await Future.delayed(const Duration(milliseconds: 800));
          if (!mounted || _navigated) return;
          _navigated = true;
          Navigator.pushReplacementNamed(context, AppRouter.home);
        }
        // Do not auto-navigate on initial; let user press Next to go to Login
      };

      authProvider.addListener(_authListener!);
    });

    // Future.microtask(() {
    //   if (!mounted) return;
    //   final authProvider = context.read<AuthProvider>();

    //   authProvider.checkAuthStatus();

    //   _authListener = () async {
    //     final state = authProvider.state;
    //     if (_navigated) return;

    //     if (state.isSuccess) {
    //       // Briefly show splash before navigating to Home if already authenticated
    //       // await Future.delayed(const Duration(milliseconds: 800));
    //       if (!mounted || _navigated) return;
    //       _navigated = true;
    //       Navigator.pushReplacementNamed(context, AppRouter.home);
    //     }
    //     // Do not auto-navigate on initial; let user press Next to go to Login
    //   };

    //   authProvider.addListener(_authListener!);
    // });

    currentPage = widget.index;
  }

  @override
  void dispose() {
    final authProvider = context.read<AuthProvider>();
    if (_authListener != null) {
      authProvider.removeListener(_authListener!);
    }
    _pageController.dispose();
    super.dispose();
  }

  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to BooLe,\nLet's Begin Explore Indonesia!",
      "image": "assets/images/splash_1.png",
    },
    {
      "text": "We Help People Explore Around Indonesia",
      "image": "assets/images/splash_2.png",
    },
    {
      "text": "We Show The Easy Way To Begin Your Journey.",
      "image": "assets/images/splash_3.png",
    },
    {
      "text": "All set! You're good to go.",
      "image": "assets/images/success.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          splashData.length,
                          (index) => GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.ease,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 5),
                              height: 6,
                              width: currentPage == index ? 20 : 6,
                              decoration: BoxDecoration(
                                color: currentPage == index
                                    ? Theme.of(context).colorScheme.primary
                                    : const Color(0xFFD8D8D8),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),
                      // if (currentPage == splashData.length - 1)
                      ElevatedButton(
                        onPressed: () async {
                          final auth = context.read<AuthProvider>();
                          if (auth.state.isSuccess) {
                            if (!_navigated) {
                              _navigated = true;
                              Navigator.pushReplacementNamed(
                                context,
                                AppRouter.home,
                              );
                            }
                          } else {
                            Navigator.pushNamed(context, AppRouter.login);
                          }
                        },
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 150,
                            maxWidth: 250,
                          ),
                          child: Center(
                            child: Text(
                              "Get Started",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
