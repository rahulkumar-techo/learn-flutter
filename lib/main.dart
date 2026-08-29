import 'package:flutter/material.dart';
import 'package:my_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:my_app/widgets/themes.dart';

import "utils//routes.dart";
import 'screens/HomePage.dart';
import 'screens/LoginScreen.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(),
      initialRoute: '/',

      routes: {
        CustomRoutes.homeRoute: (context) => const Homepage(),
        CustomRoutes.loginRoute: (context) => const LoginScreen(),
      },

      // Add onGenerateRoute to handle dynamic arguments intercepting
      onGenerateRoute: (settings) {
        if (settings.name == CustomRoutes.productDetailsRoute) {
          // Extract the integer ID passed from ProductCard
          final productId = settings.arguments;

          if (productId is! int) {
            return MaterialPageRoute(
              builder: (context) => const Scaffold(
                body: Center(child: Text('Product details not found.')),
              ),
            );
          }

          return MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(productId: productId),
          );
        }

        // Return null so it falls back to static routes if no dynamic match is found
        return null;
      },
    );
  }
}
