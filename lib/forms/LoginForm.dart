import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/utils/routes.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  String _errorMessage = "";
  bool _hasError = false;
  bool _obscurePassword = true; // Changed to true so password starts hidden

  void _handleFormValidation() {
    // Reset general form error before validating fields
    setState(() {
      _hasError = false;
      _errorMessage = "";
    });

    final formState = _formKey.currentState;
    if (formState == null) {
      return;
    }

    if (formState.validate()) {
      formState.save();
      // Inputs are valid; navigate to home screen
      Navigator.pushNamed(context, CustomRoutes.homeRoute);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Shared styling for input borders
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
    );

    return Form(
      key: _formKey,
      child: Column(
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

          Text(
            'Email',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: Colors.white,
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
              ),
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              // Hides the standard redundant bottom error text since you use a custom summary block
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                setState(() {
                  _errorMessage = "Email cannot be empty";
                  _hasError = true;
                });
                return "";
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                setState(() {
                  _errorMessage = "Please enter a valid email address";
                  _hasError = true;
                });
                return "";
              }
              return null;
            },
       
            onSaved: (value) => _email = value?.trim() ?? "",
          ),
          const SizedBox(height: 20),

          // Password input filed with password display and hide
          Text(
            'Password',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextFormField(
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleFormValidation(),
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
              ),
              errorBorder: errorBorder,
              focusedErrorBorder: errorBorder,
              errorStyle: const TextStyle(fontSize: 0, height: 0),
            ),

            // Input Validator , Validate input Values
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                setState(() {
                  _errorMessage = "Password cannot be empty";
                  _hasError = true;
                });
                return "";
              }
              return null;
            },
            onSaved: (value) => _password = value?.trim() ?? "",
          ),

          // Display This Weidget when error happens
          if (_hasError) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage,
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
              onPressed: _handleFormValidation,
              child: const Text('Login'),
            ),
          ),
          const SizedBox(height: 25),

          Row(
            children: [
              // Streach lin like : -----------OR------------
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'OR',
                  style: GoogleFonts.poppins(color: Colors.grey),
                ),
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
      ),
    );
  }
}
