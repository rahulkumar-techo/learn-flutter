import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),

              // Limits the form width on larger screens.
              // On mobile, it will use the available width.
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------------------------------------------------
                    // Welcome
                    // ---------------------------------------------------
                    Center(
                      child: Text(
                        'Welcome 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------------------------------------------
                    // Email
                    // ---------------------------------------------------
                    Text(
                      'Email',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------------------------------------------
                    // Password
                    // ---------------------------------------------------
                    Text(
                      'Password',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------------------------------------------
                    // Forgot Password
                    // ---------------------------------------------------
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------------------------------------------
                    // Login Button
                    // ---------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                           print("Login clicked");
                        },
                        child: const Text('Login'),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ---------------------------------------------------
                    // OR Divider
                    // ---------------------------------------------------
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Text(
                            'OR',
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                            ),
                          ),
                        ),

                        const Expanded(
                          child: Divider(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // ---------------------------------------------------
                    // Google Login
                    // ---------------------------------------------------
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.g_mobiledata,
                        ),
                        label: const Text(
                          'Continue with Google',
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------------------------------------------
                    // Create Account
                    // ---------------------------------------------------
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Don't have an account? Create Account",
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
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