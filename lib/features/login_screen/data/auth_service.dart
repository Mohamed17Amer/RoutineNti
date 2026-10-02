import 'package:my_creative_routine/core/network/api_client.dart';
import 'package:my_creative_routine/core/network/api_exception.dart';
import 'package:my_creative_routine/core/network/end_points.dart';
import 'package:my_creative_routine/core/storage/token_storage.dart';
import 'package:my_creative_routine/core/utils/image_picker_helper.dart';
import 'package:my_creative_routine/features/home_screen/data/local/task_extras_storage.dart';

class AuthService {
  final ApiClient _api = ApiClient.instance;

  Future<bool> register({
    required String username,
    required String password,
    PickedImage? image,
  }) async {
    final response = await _api.post(
      EndPoints.register,
      withAuth: false,
      body: {'username': username, 'password': password, 'image': image},
    );
    return _saveTokensFrom(response);
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    final response = await _api.post(
      EndPoints.login,
      withAuth: false,
      body: {'username': username, 'password': password},
    );
    final saved = await _saveTokensFrom(response);
    if (!saved) {
      throw const ApiException('Login failed, please try again.');
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    await TaskExtrasStorage.clear();
  }

  Future<bool> _saveTokensFrom(dynamic response) async {
    final access = ApiClient.findValue(response, 'access_token');
    final refresh = ApiClient.findValue(response, 'refresh_token');
    if (access is! String || access.isEmpty) return false;

    await TokenStorage.saveTokens(
      accessToken: access,
      refreshToken: refresh is String ? refresh : null,
    );
    return true;
  }
}
