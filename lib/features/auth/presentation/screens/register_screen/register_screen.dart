import 'package:boole_apps/features/auth/presentation/screens/register_screen/components/register_form.dart';
import 'package:boole_apps/features/auth/presentation/widgets/socal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
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
                    "Register Account",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Complete your details or continue with social media",
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const RegisterForm(),
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
                  const SizedBox(height: 16),
                  Text(
                    'By continuing your confirm that you agree \nwith our Term and Condition',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
