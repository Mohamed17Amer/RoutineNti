import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';

class ProfileHeader extends StatelessWidget {
  final PickedImage? pickedImage;
  final String? imageUrl;
  final VoidCallback? onPickImage;

  const ProfileHeader({
    super.key,
    this.pickedImage,
    this.imageUrl,
    this.onPickImage,
  });

  Widget _asset() {
    return Image.asset(
      AppAssets.flagPng,
      width: double.infinity,
      height: 240,
      fit: BoxFit.cover,
    );
  }

  Widget _image() {
    if (pickedImage != null) {
      return Image.memory(
        pickedImage!.bytes,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
      );
    }
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: double.infinity,
        height: 240,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _asset(),
      );
    }
    return _asset();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          child: _image(),
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
        if (onPickImage != null)
          Positioned(
            bottom: -15,
            child: GestureDetector(
              onTap: onPickImage,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  'Change Image',
                  style: TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
