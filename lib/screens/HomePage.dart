import 'package:flutter/material.dart';
import 'package:my_app/screens/LoginScreen.dart';

class Homepage extends StatelessWidget {
  // Cleaned up the constructor syntax using standard Flutter patterns
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My App")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Home Page"),
            const SizedBox(height: 16),
            // Button to redirect to login screen 
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
      drawer: const Drawer(),
    );
  }
}
