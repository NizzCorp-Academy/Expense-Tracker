import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/pages/Signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Register_page extends StatefulWidget {
  const Register_page({super.key});

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {
  final bool _obscureText = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    "Register",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    "Create an account to access all the\nfeatures of Linear!",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Name',
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Ex. Vicky Aman",
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.black26,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              size: 16,
                              color: Colors.black38,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email", style: GoogleFonts.poppins(fontSize: 14)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: emailController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: "Ex: abc@example.com",
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.black26,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FaIcon(
                              FontAwesomeIcons.at,
                              size: 16,
                              color: Colors.black38,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Password",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "●●●●●●●●●●",
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.black26,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FaIcon(
                              FontAwesomeIcons.lock,
                              size: 16,
                              color: Colors.black38,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // // Password Field
                  // InputField(
                  //   label: "Confirm Password",
                  //   hintText: "●●●●●●●●●●",
                  //   icon: FontAwesomeIcons.shieldHalved,
                  // ),
                  // const SizedBox(height: 32),

                  // Register Button
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) async {
                      if (state is AuthLoading) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder:
                              (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                        );
                      } else if (state is Authenticated) {
                        Navigator.of(context).pop(); // Close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account created successfully!'),
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Sign_In()),
                        );
                      } else if (state is AuthFailure) {
                        Navigator.of(context).pop(); // Close loading
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          String name = nameController.text.trim();
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill in all fields"),
                              ),
                            );
                            return;
                          }

                          // Dispatch SignUpEvent to BLoC
                          context.read<AuthBloc>().add(
                            SignUpEvent(name, email, password),
                          );

                          // Optional: Clear inputs
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Register",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Already have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Sign_In()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
