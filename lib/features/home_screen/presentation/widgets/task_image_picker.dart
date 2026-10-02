import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';
import 'package:my_creative_routine/core/utils/app_colors.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';

class TaskImagePicker extends StatelessWidget {
  final PickedImage? pickedImage;
  final String? currentImageUrl;
  final VoidCallback onTap;
  final double height;

  const TaskImagePicker({
    super.key,
    required this.onTap,
    this.pickedImage,
    this.currentImageUrl,
    this.height = 180,
  });

  Widget _placeholder() {
    return Image.asset(
      AppAssets.flagPng,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _image() {
    if (pickedImage != null) {
      return Image.memory(
        pickedImage!.bytes,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    if (currentImageUrl != null) {
      return Image.network(
        currentImageUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = pickedImage != null || currentImageUrl != null;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            _image(),
            Positioned(
              right: 10,
              bottom: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.image_outlined,
                        size: 16, color: AppColors.textGrey),
                    const SizedBox(width: 6),
                    Text(
                      hasImage ? 'Change Image' : 'Add Image',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textGrey),
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
