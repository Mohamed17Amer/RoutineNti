import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/core/widgets/custom_txt_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
              child: Column(
                children: [
                  CustomTextField(
                    controller: _oldPasswordController,
                    hintText: 'Old Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isObscured: _obscureOld,
                    onToggleVisibility: () =>
                        setState(() => _obscureOld = !_obscureOld),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _newPasswordController,
                    hintText: 'New Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isObscured: _obscureNew,
                    onToggleVisibility: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm Password',
                    prefixIcon: Icons.lock_outline,
                    isPassword: true,
                    isObscured: _obscureConfirm,
                    onToggleVisibility: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Save', style: AppFonts.buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
