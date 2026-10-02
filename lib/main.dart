import 'package:flutter/material.dart';
import 'package:my_creative_routine/features/splash_screen/presentation/splash_screen.dart';

void main() {
  runApp(const MyCreativeRoutineApp());
}

class MyCreativeRoutineApp extends StatelessWidget {
  const MyCreativeRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Creative Routine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
