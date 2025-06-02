import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_event.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/bloc/auth_state.dart';
import 'package:expense_trackerl_ite/features/auth/presentation/pages/signup.dart';
import 'package:expense_trackerl_ite/features/transaction_list/presentation/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Sign_In extends StatefulWidget {
  const Sign_In({super.key});

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
  final bool _obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<bool> signInWithGoogle(BuildContext context) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     if (googleUser == null) {
  //       // User cancelled the sign-in
  //       return false;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text("Signed in with Google")));
  //       return true;
  //     }

  //     return false;
  //   } catch (e) {
  //     print('Google Sign-In Error: $e');
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Google Sign-In failed")));
  //     return false;
  //   }
  // }
bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (state is Authenticated) {
          setState(() {
            isLoading = false;
          });
          print('User is authenticated');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (state is AuthFailure) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
          body: Center(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        "Login",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Subtitle
                      Text(
                        "Login now to track all your expenses\nand income at a place!",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),
    
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
                      const SizedBox(height: 8),
    
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.poppins(
                              color: Colors.blue,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
    
                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            String email = emailController.text.trim();
                            String password = passwordController.text.trim();
    
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please fill in all fields"),
                                ),
                              );
                              return;
                            }
    
                            if (!email.contains("@") || !email.contains(".")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please enter a valid email address",
                                  ),
                                ),
                              );
                              return;
                            }
    
                            BlocProvider.of<AuthBloc>(
                              context,
                            ).add(SignInEvent(email, password,));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3CFF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          child: isLoading ? CircularProgressIndicator(color: Colors.white,) : Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
    
                      const SizedBox(height: 16),
    
                      // Google Button
                      BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is Authenticated) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                            
                          } else if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login failed: ${state.error}')),
                            );
                          }
                        },
                        child: Column(
                          children: [
                            // Google Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () {
                                  BlocProvider.of<AuthBloc>(context).add(GoogleSignInEvent());
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.black26),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/gmail.png', height: 30),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
    
                      // Register Redirect
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an account? ",
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register_page(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              "Register",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
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
        ),
    );
  }
}
