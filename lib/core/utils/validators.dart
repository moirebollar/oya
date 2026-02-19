class Validators {
  Validators._();

  static String? email(String? value, {String? requiredMsg, String? invalidMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Email is required';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return invalidMsg ?? 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {String? requiredMsg, String? tooShortMsg}) {
    if (value == null || value.isEmpty) {
      return requiredMsg ?? 'Password is required';
    }
    if (value.length < 8) {
      return tooShortMsg ?? 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? original,
      {String? noMatchMsg}) {
    if (value != original) {
      return noMatchMsg ?? 'Passwords do not match';
    }
    return null;
  }

  static String? name(String? value, {String? requiredMsg}) {
    if (value == null || value.trim().isEmpty) {
      return requiredMsg ?? 'Name is required';
    }
    return null;
  }

  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }
}
