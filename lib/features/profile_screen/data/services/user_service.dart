import 'package:my_creative_routine/core/network/api_client.dart';
import 'package:my_creative_routine/core/network/end_points.dart';
import 'package:my_creative_routine/core/storage/token_storage.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';
import 'package:my_creative_routine/features/home_screen/data/local/task_extras_storage.dart';
import 'package:my_creative_routine/features/profile_screen/data/models/user_model.dart';

class UserService {
  final ApiClient _api = ApiClient.instance;

  Future<UserModel> getUserData() async {
    final response = await _api.get(EndPoints.getUserData);
    return UserModel.fromJson(response);
  }

  Future<void> updateProfile({
    required String username,
    PickedImage? image,
  }) async {
    await _api.put(
      EndPoints.updateProfile,
      body: {'username': username, 'image': image},
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _api.post(
      EndPoints.changePassword,
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirm': confirmPassword,
      },
    );
  }

  Future<void> deleteAccount() async {
    await _api.delete(EndPoints.deleteUser);
    await TokenStorage.clear();
    await TaskExtrasStorage.clear();
  }
}
