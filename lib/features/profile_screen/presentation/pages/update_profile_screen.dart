import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/app_messages.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';
import 'package:my_creative_routine/core/utils/validators.dart';
import 'package:my_creative_routine/core/widgets/app_button.dart';
import 'package:my_creative_routine/core/widgets/custom_txt_field.dart';
import 'package:my_creative_routine/features/profile_screen/data/models/user_model.dart';
import 'package:my_creative_routine/features/profile_screen/data/services/user_service.dart';
import 'package:my_creative_routine/features/profile_screen/presentation/widgets/profile_header.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UserModel? user;

  const UpdateProfileScreen({super.key, this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  late final TextEditingController _usernameController =
      TextEditingController(text: widget.user?.username ?? '');

  PickedImage? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickFromGallery();
    if (image != null && mounted) setState(() => _image = image);
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    if (username == widget.user?.username && _image == null) {
      AppMessages.show(context, 'Nothing to update');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _userService.updateProfile(username: username, image: _image);
      if (!mounted) return;
      AppMessages.show(context, 'Profile updated');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) AppMessages.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              pickedImage: _image,
              imageUrl: widget.user?.imageUrl,
              onPickImage: _pickImage,
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _usernameController,
                      hintText: 'Username',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.done,
                      validator: Validators.username,
                    ),
                    const SizedBox(height: 28),
                    AppButton(
                      text: 'Save',
                      isLoading: _isLoading,
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
