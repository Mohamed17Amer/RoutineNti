import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_fonts.dart';
import 'package:my_creative_routine/core/utils/app_messages.dart';
import 'package:my_creative_routine/core/widgets/app_avatar.dart';
import 'package:my_creative_routine/features/login_screen/data/auth_service.dart';
import 'package:my_creative_routine/features/login_screen/presentation/login_screen.dart';
import 'package:my_creative_routine/features/profile_screen/data/models/user_model.dart';
import 'package:my_creative_routine/features/profile_screen/data/services/user_service.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/pages/change_password_screen.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/pages/settings_screen.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/pages/update_profile_screen.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? user;

  const ProfileScreen({super.key, this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();

  UserModel? _user;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userService.getUserData();
      if (mounted) setState(() => _user = user);
    } catch (e) {
      if (mounted && _user == null) AppMessages.showError(context, e);
    }
  }

  Future<void> _openUpdateProfile() async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfileScreen(user: _user),
      ),
    );
    if (updated == true) _loadUser();
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _logout() async {
    final confirmed = await AppMessages.confirm(
      context,
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      confirmText: 'Log Out',
    );
    if (!confirmed) return;
    await _authService.logout();
    if (mounted) _goToLogin();
  }

  Future<void> _deleteAccount() async {
    final confirmed = await AppMessages.confirm(
      context,
      title: 'Delete Account',
      message:
          'Your account and all your tasks will be deleted permanently. '
          'This can\'t be undone.',
    );
    if (!confirmed || !mounted) return;

    setState(() => _isBusy = true);
    try {
      await _userService.deleteAccount();
      if (!mounted) return;
      AppMessages.show(context, 'Your account has been deleted');
      _goToLogin();
    } catch (e) {
      if (mounted) AppMessages.showError(context, e);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: AbsorbPointer(
          absorbing: _isBusy,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppAvatar(imageUrl: _user?.imageUrl, radius: 24),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello!',
                            style:
                                AppFonts.bodyRegular.copyWith(fontSize: 12)),
                        Text(_user?.username ?? '',
                            style: AppFonts.titleBold.copyWith(fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                ProfileMenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: _openUpdateProfile,
                ),
                ProfileMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangePasswordScreen()),
                    );
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  onTap: _logout,
                ),
                ProfileMenuItem(
                  icon: Icons.delete_forever_outlined,
                  title: 'Delete Account',
                  color: AppColors.danger,
                  onTap: _deleteAccount,
                ),
                if (_isBusy)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12),
                      child:
                          CircularProgressIndicator(color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
