import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/features/register_screen/presentation/register_screen.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({super.key});

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(AppAssets.startPng, height: 260),

              const SizedBox(height: 36),
              const Text(
                'Welcome To\nDo It !',
                textAlign: TextAlign.center,
                style: AppFonts.titleBold,
              ),

              const SizedBox(height: 14),
              const Text(
                'Ready to conquer your tasks? Let\'s Do\nIt together.',
                textAlign: TextAlign.center,
                style: AppFonts.bodyRegular,
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Let\'s Start', style: AppFonts.buttonText),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
