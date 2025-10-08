import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/core/utils/keyboard_utils.dart';
import 'package:boole_apps/core/widgets/custom_suffix_icon.dart';
import 'package:boole_apps/features/auth/presentation/constants/form_error.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_provider.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_state.dart';
import 'package:boole_apps/features/auth/presentation/screens/login_screen/components/form_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  SignFormState createState() => SignFormState();
}

class SignFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool? remember = false;
  final List<String?> errors = [];
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _lastErrorMessageShown;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void signIn() {}

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // email form field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: FormErrorConstants.kEmailNullError);
              } else if (FormErrorConstants.emailValidatorRegExp.hasMatch(
                value,
              )) {
                removeError(error: FormErrorConstants.kInvalidEmailError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: FormErrorConstants.kEmailNullError);
                return "";
              } else if (!FormErrorConstants.emailValidatorRegExp.hasMatch(
                value,
              )) {
                addError(error: FormErrorConstants.kInvalidEmailError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
              hintStyle: Theme.of(context).textTheme.bodyLarge,
              labelStyle: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          // password form field
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: FormErrorConstants.kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: FormErrorConstants.kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: FormErrorConstants.kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: FormErrorConstants.kShortPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
              hintStyle: Theme.of(context).textTheme.bodyLarge,
              labelStyle: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 20),

          // remember me and forgot password widget
          Row(
            children: [
              // remember me check box
              Checkbox(
                value: remember,
                activeColor: Theme.of(context).colorScheme.primary,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),

              // forgot password
              GestureDetector(
                // onTap: () => Navigator.pushNamed(
                //   context,
                //   ForgotPasswordScreen.routeName,
                // ),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),

          // form error
          FormError(errors: errors),

          const SizedBox(height: 16),

          // continue / login button
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final isLoading = auth.state.status == AuthStatus.loading;

              // auth state error
              if (auth.state.status == AuthStatus.error && context.mounted) {
                final msg = auth.state.message;

                if (_lastErrorMessageShown != msg) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'That login info didn\'t work',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            msg ??
                                'Check your username or password and try again. You can also create a new account.',
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 4,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(
                                  context,
                                  AppRouter.register,
                                );
                              },
                              child: const Text('Sign Up'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Try Again'),
                            ),
                          ],
                        );
                      },
                    );
                  });

                  _lastErrorMessageShown = msg;
                }
              }
              // auth state success
              else if (auth.state.status == AuthStatus.success &&
                  context.mounted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // auth state succes return to home screen
                  Navigator.pushNamed(context, AppRouter.main);
                  // todo: add token for argument if possible
                });
              }

              // login button checked with auth state loading
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          KeyboardUtil.hideKeyboard(context);

                          context.read<AuthProvider>().signIn(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Continue'),
              );
            },
          ),
        ],
      ),
    );
  }
}
