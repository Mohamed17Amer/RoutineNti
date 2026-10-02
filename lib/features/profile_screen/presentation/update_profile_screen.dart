import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/widgets/custom_txt_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _usernameController =
      TextEditingController(text: 'Ahmed Saber');

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  child: Image.asset(
                    AppAssets.flagPng,
                    width: double.infinity,
                    height: 240,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          size: 16, color: AppColors.textBlack),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: CustomTextField(
                controller: _usernameController,
                hintText: 'Username',
                prefixIcon: Icons.person_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
