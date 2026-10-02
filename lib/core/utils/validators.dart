class Validators {
  static String? username(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Username is required';
    if (text.length < 3) return 'Username must be at least 3 characters';
    if (text.length > 30) return 'Username can\'t be more than 30 characters';
    return null;
  }

  static String? password(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Password is required';
    if (text.length < 6) return 'Password must be at least 6 characters';
    if (text.contains(' ')) return 'Password can\'t contain spaces';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) return 'Please confirm your password';
    if (value != original) return 'Passwords don\'t match';
    return null;
  }

  static String? newPassword(String? value, String currentPassword) {
    final error = password(value);
    if (error != null) return error;
    if (value == currentPassword) {
      return 'New password must be different from the current one';
    }
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }

  static String? taskTitle(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Title is required';
    if (text.length > 60) return 'Title can\'t be more than 60 characters';
    return null;
  }

  static String? taskDescription(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Description is required';
    if (text.length > 500) {
      return 'Description can\'t be more than 500 characters';
    }
    return null;
  }
}
