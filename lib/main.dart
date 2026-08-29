import 'package:flutter/material.dart';
import 'package:my_app/utils/app_router.dart';
import 'package:my_app/widgets/themes.dart';



void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(),

      routerConfig: appRouter,
    );
  }
}
