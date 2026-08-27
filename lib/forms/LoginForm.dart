import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/utils/routes.dart';

// 1. Capitalized class name to adhere to Dart PascalCase conventions
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = "";
  String password = "";
  String errorMessage = "";
  bool hasError = false;

  bool checkLoginValidation() {
    // 2. Wrapped mutation in setState so the UI clears old errors immediately
    setState(() {
      errorMessage = "";
      hasError = false;
    });

    if (email.trim().isEmpty) {
      setState(() {
        errorMessage = "Email cannot be empty";
        hasError = true;
      });
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.trim())) {
      setState(() {
        errorMessage = "Please enter a valid email address";
        hasError = true;
      });
      return false;
    }

    if (password.trim().isEmpty) {
      setState(() {
        errorMessage = "Password cannot be empty";
        hasError = true;
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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

        Text('Email', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.emailAddress, // Native email keyboard layout
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            filled: true,
            // 3. Replaced bright solid red background with a subtle error border style
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Colors.transparent,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Colors.transparent,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: hasError ? Colors.red.shade700 : Theme.of(context).primaryColor,
                width: 1.5,
              ),
            ),
            
          ),
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
        ),
        const SizedBox(height: 20),

        Text(
          'Password',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            filled: true,
            fillColor: Colors.white,
            // Uses standard invisible border unless modified globally
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
        ),

        // 4. Inline error message rendering block
        if (hasError) ...[
          const SizedBox(height: 12),
          Text(
            errorMessage,
            style: GoogleFonts.poppins(
              color: Colors.red.shade700,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],

        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text('Forgot Password?'),
          ),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              if (checkLoginValidation()) {
                Navigator.pushNamed(context, CustomRoutes.homeRoute);
              }
            },
            child: const Text('Login'),
          ),
        ),
        const SizedBox(height: 25),

        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text('OR', style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 25),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Continue with Google'),
          ),
        ),
        const SizedBox(height: 30),

        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text("Don't have an account? Create Account"),
          ),
        ),
      ],
    );
  }
}
