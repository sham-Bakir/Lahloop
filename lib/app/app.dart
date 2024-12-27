import 'package:advapp/presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:advapp/presentation/resources/routes_manager.dart';

class MyApp extends StatefulWidget {
  const MyApp._internal(); // Private named constructor for singleton

  static final MyApp _instance =
      const MyApp._internal(); // singleton or single instance

  factory MyApp({Key? key}) {
    return _instance;
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
