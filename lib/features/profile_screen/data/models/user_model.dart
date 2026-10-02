import 'package:my_creative_routine/core/network/api_client.dart';

class UserModel {
  final String id;
  final String username;
  final String? imageUrl;

  const UserModel({
    required this.id,
    required this.username,
    this.imageUrl,
  });

  factory UserModel.fromJson(dynamic json) {
    Map data = json is Map ? json : {};
    for (final key in ['user', 'data']) {
      if (data[key] is Map) {
        data = data[key];
        break;
      }
    }

    return UserModel(
      id: data['id']?.toString() ?? '',
      username: data['username']?.toString() ?? '',
      imageUrl: ApiClient.imageUrl(
        data['image_path'] ?? data['image'] ?? data['image_url'],
      ),
    );
  }
}
