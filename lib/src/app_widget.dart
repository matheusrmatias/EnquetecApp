import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  final Widget page;
  const MyApp({super.key, required this.page});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enquetec',

      navigatorKey: NavigationService.navigatorKey,
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Resolve-Light',
        colorScheme: ColorScheme.fromSeed(seedColor: MainColors.primary, primary: MainColors.orange),
        canvasColor: MainColors.white
      ),
      home: page,
    );
  }
}