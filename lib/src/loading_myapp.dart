import 'package:enquetec/src/loading_page.dart';
import 'package:enquetec/src/themes/main.dart';
import 'package:flutter/material.dart';

class LoadingMyApp extends StatelessWidget {
  const LoadingMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Enquetec',
      theme: ThemeData(
          fontFamily: 'Resolve-Light',
          colorScheme: ColorScheme.fromSeed(seedColor: MainColors.primary, primary: MainColors.orange),
          canvasColor: MainColors.white
      ),
      home: const LoadingPage(),
    );
  }
}
