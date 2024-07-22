import 'package:firebase_superbootcamp/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInPages extends StatefulWidget {
  const SignInPages({super.key});

  @override
  State<SignInPages> createState() => _SignInPagesState();
}

class _SignInPagesState extends State<SignInPages> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Materi Firebase Auth",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Column(
            children: [
              /// Email Textfield
              textField(title: "Email", controller: emailController),

              /// Password Textfield
              textField(title: "Password", controller: passController),

              /// Register Button
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: state.isLoading
                        ? const CircularProgressIndicator() // Tampilkan loading indicator ketika loading
                        : ElevatedButton(
                            onPressed: () {
                              final email = emailController.text;
                              final pass = passController.text;

                              /// Pastikan Email atau Password tidak kosong
                              if (email.isNotEmpty || pass.isNotEmpty) {
                                context.read<AuthBloc>().add(
                                      AuthRegister(
                                        email: emailController.text,
                                        password: passController.text,
                                      ),
                                    );
                              }
                            },
                            child: const Text("Register"),
                          ),
                  );
                },
              ),

              /// Registered User Information
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return state.errorMessage.isNotEmpty
                        ? Text("Error : ${state.errorMessage}")
                        : Text(
                            "Email: ${state.userData?.email}\nUID: ${state.userData?.uid}",
                            textAlign: TextAlign.center,
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textField({
    required String title,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          labelText: title,
        ),
        controller: controller,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
}
