import 'package:flutter/material.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ElangKuy',
      theme: ThemeData(
        primaryColor: const Color(0xFF4052EF),
        fontFamily: 'Inter',
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Change initial route to login screen
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}