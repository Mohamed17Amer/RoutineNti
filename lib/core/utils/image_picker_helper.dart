import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

class PickedImage {
  final String name;
  final Uint8List bytes;

  const PickedImage({required this.name, required this.bytes});
}

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<PickedImage?> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1080,
    );
    if (file == null) return null;
    return PickedImage(name: file.name, bytes: await file.readAsBytes());
  }
}
