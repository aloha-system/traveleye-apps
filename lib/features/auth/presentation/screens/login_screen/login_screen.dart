import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/features/auth/presentation/screens/login_screen/components/login_form.dart';
import 'package:boole_apps/features/auth/presentation/widgets/socal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Sign in with your email and password or continue with social media",
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const LoginForm(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () async {
                          final auth = context.read<AuthProvider>();
                          await auth.signInWithGoogle();
                          if (!context.mounted) return;
                          if (auth.state.isSuccess) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRouter.home,
                              (_) => false,
                            );
                          } else if (auth.state.isError) {
                            final msg =
                                auth.state.message ?? 'Google sign-in failed';
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(msg)));
                          }
                        },
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Coming soon!')),
                          );
                        },
                      ),
                      SocalCard(
                        icon: "assets/icons/twitter.svg",
                        press: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NoAccountText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRouter.register),
          child: Text(
            "Sign Up",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
