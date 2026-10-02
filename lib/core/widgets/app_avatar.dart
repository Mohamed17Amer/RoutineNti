import 'package:flutter/material.dart';
import 'package:my_creative_routine/core/utils/app_assets.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const AppAvatar({super.key, this.imageUrl, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final ImageProvider image;
    if (hasImage) {
      image = NetworkImage(imageUrl!);
    } else {
      image = const AssetImage(AppAssets.flagPng);
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: image,
      onBackgroundImageError: hasImage ? (_, __) {} : null,
    );
  }
}
