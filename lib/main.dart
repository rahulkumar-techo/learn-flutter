import 'package:flutter/material.dart';
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
    );
  }
}
