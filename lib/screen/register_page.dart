import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  final Function onRegister;
  final Function onLogin;
  const RegisterPage({
    Key? key,
    required this.onRegister,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registerButton),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset("assets/story-logo.png"),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.validatorName;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.validatorEmail;
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.validatorPassword;
                    } else if (value.length < 8) {
                      return AppLocalizations.of(context)!.passwordLong;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                context.watch<AuthProvider>().isLoadingRegister
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          final ScaffoldMessengerState scaffoldMessengerState =
                              ScaffoldMessenger.of(context);
                          final localizations = AppLocalizations.of(context)!;
                          if (formKey.currentState!.validate()) {
                            final authRead = context.read<AuthProvider>();

                            final result = await authRead.registerUser(
                                nameController.text,
                                emailController.text,
                                passwordController.text);
                            if (result) {
                              widget.onRegister();
                            } else {
                              scaffoldMessengerState.showSnackBar(SnackBar(
                                  content:
                                      Text(localizations.validatorRegister)));
                            }
                          }
                        },
                        child:
                            Text(AppLocalizations.of(context)!.registerButton),
                      ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => widget.onLogin(),
                  child: Text(AppLocalizations.of(context)!.loginButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
