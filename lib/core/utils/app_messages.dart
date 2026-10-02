import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/network/api_exception.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';

class AppMessages {
  static void show(BuildContext context, String text, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: isError ? AppColors.danger : AppColors.primaryDark,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  static void showError(BuildContext context, Object error) {
    if (error is ApiException && error.sessionExpired) return;
    show(context, errorText(error), isError: true);
  }

  static String errorText(Object error) {
    if (error is ApiException) return error.message;
    return 'Something went wrong, please try again.';
  }

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Delete',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText,
                style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
