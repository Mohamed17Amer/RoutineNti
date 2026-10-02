import 'package:flutter/material.dart';
import 'package:my_creative_routine/features/login_screen/presentation/login_screen.dart';

class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void goToLogin({String? message}) {
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
    if (message != null) {
      messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
