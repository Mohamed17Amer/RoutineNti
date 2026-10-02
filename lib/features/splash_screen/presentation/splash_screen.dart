import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/storage/token_storage.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/features/home_screen/presentation/pages/home_screen.dart';
import 'package:my_creative_routine/features/starting_screen/presentation/lets_start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    final results = await Future.wait([
      TokenStorage.hasSession(),
      Future.delayed(const Duration(seconds: 2), () => true),
    ]);
    if (!mounted) return;

    final loggedIn = results.first;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            loggedIn ? const HomeScreen() : const StartingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.splashBgPng, width: 170, height: 170),
            const SizedBox(height: 24),
            Text(
              'MY ROUTINE',
              style: AppFonts.titleBold.copyWith(
                color: AppColors.primary,
                letterSpacing: 2.0,
                fontSize: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
