import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool isObscured;
  final VoidCallback? onToggleVisibility;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false,
    this.isObscured = false,
    this.onToggleVisibility,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? isObscured : false,
        maxLines: isPassword ? 1 : maxLines,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, color: AppColors.textGrey, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isObscured ? Icons.lock_outline : Icons.lock_open,
                    color: AppColors.textGrey,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          hintText: hintText,
          hintStyle: AppFonts.inputLabel,
        ),
      ),
    );
  }
}
