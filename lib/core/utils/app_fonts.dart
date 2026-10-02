import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  static const String fontFamily = 'Poppins';

  static const TextStyle titleBold = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlack,
  );

  static const TextStyle bodyRegular = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textGrey,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    color: AppColors.textGrey,
  );
}
