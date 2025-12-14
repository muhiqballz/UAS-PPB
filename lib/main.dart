import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const StudyMateApp());
}

class StudyMateApp extends StatelessWidget {
  const StudyMateApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: const Color(0xFF2C3E50),
        scaffoldBackgroundColor: const Color(0xFFECF0F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3498DB),
          primary: const Color(0xFF3498DB),
          secondary: const Color(0xFF2C3E50),
          error: const Color(0xFFE74C3C),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
