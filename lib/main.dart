import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const OraytCarwashApp());
}

class OraytCarwashApp extends StatelessWidget {
  const OraytCarwashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orayt Vendo Carwash',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B6), // Deep ocean blue
          primary: const Color(0xFF0077B6),
          secondary: const Color(0xFF00B4D8), // Light water blue
          background: const Color(0xFFF0F8FF), // Alice Blue background
        ),
        scaffoldBackgroundColor: const Color(0xFFF0F8FF),
      ),
      home: const HomeScreen(),
    );
  }
}
