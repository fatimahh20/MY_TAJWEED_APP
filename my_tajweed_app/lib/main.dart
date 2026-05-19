import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const AlMakharijApp());
}

class AlMakharijApp extends StatelessWidget {
  const AlMakharijApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
