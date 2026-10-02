class EndPoints {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://your-todo-api.com/',
  );

  static const String register = 'register';
  static const String login = 'login';
  static const String refreshToken = 'refresh_token';
  static const String getUserData = 'get_user_data';
  static const String updateProfile = 'update_profile';
  static const String changePassword = 'change_password';
  static const String deleteUser = 'delete_user';

  static const String newTask = 'new_task';
  static const String myTasks = 'my_tasks';
  static String task(String id) => 'tasks/$id';
}
