import 'package:boole_apps/features/auth/presentation/splash_screen/components/splash_content.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final int index;

  const SplashScreen({super.key, this.index = 0});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late int currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.index;
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
                          (index) => AnimatedContainer(
                            duration: Duration(milliseconds: 200),
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
                      const Spacer(flex: 3),
                      ElevatedButton(
                        onPressed: () {
                          // todo-sign-in-route
                          // Navigator.pushNamed(context, /* signin route */ );
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 150,
                            maxWidth: 250,
                          ),
                          child: Center(
                            child: Text(
                              "Continue",
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
