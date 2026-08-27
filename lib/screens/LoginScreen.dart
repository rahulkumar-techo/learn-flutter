import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/forms/LoginForm.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),

      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),

              // Limits the form width on larger screens.
              // On mobile, it will use the available width.
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.green),
                ),
                // alignment:AlignmentGeometry.xy(x, y),

                child: Align(
                  alignment: Alignment.center,
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  child: Loginform(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
