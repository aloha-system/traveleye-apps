import 'package:boole_apps/app/app_router.dart';
import 'package:boole_apps/core/utils/keyboard_utils.dart';
import 'package:boole_apps/core/widgets/custom_suffix_icon.dart';
import 'package:boole_apps/features/auth/presentation/constants/form_error.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_provider.dart';
import 'package:boole_apps/features/auth/presentation/provider/auth_state.dart';
import 'package:boole_apps/features/auth/presentation/screens/login_screen/components/form_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool remember = false;
  final List<String?> errors = [];

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // username form field
          TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: FormErrorConstants.kNamelNullError);
              } else if (FormErrorConstants.nameValidatorRegExp.hasMatch(
                value,
              )) {
                removeError(error: FormErrorConstants.kInvalidNameError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: FormErrorConstants.kNamelNullError);
                return "";
              } else if (!FormErrorConstants.nameValidatorRegExp.hasMatch(
                value,
              )) {
                addError(error: FormErrorConstants.kInvalidNameError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Name",
              hintText: "Enter your name",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(Icons.person_outline),
              ),
            ),
          ),

          const SizedBox(height: 20),

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
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),

          const SizedBox(height: 20),

          // passowrd form field
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: FormErrorConstants.kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: FormErrorConstants.kShortPassError);
              }
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

          // confirm password form field
          TextFormField(
            obscureText: true,
            controller: _confirmPasswordController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: FormErrorConstants.kPassNullError);
              } else if (value.isNotEmpty &&
                  _confirmPasswordController.text == _passwordController.text) {
                removeError(error: FormErrorConstants.kMatchPassError);
              }
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: FormErrorConstants.kPassNullError);
                return "";
              } else if ((_passwordController.text != value)) {
                addError(error: FormErrorConstants.kMatchPassError);
                return "";
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
              hintStyle: Theme.of(context).textTheme.bodyLarge,
              labelStyle: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // form error
          FormError(errors: errors),

          const SizedBox(height: 20),

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
                            'Failed to create an account',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          content: Text(
                            msg ??
                                'Check your username or password and try again.',
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 3,
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Try again'),
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Create account success',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        content: Text('Please Sign In to continue.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRouter.login,
                              );
                            },
                            child: Text('Sign In'),
                          ),
                        ],
                      );
                    },
                  );
                });
              }

              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          KeyboardUtil.hideKeyboard(context);

                          context.read<AuthProvider>().createAccount(
                            _emailController.text,
                            _passwordController.text,
                            _usernameController.text,
                          );
                          // if all are valid then go to success screen
                          // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
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
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Sign Up'),
              );
            },
          ),
        ],
      ),
    );
  }
}
