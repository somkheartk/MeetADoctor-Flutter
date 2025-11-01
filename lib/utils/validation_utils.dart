import '../constants/app_constants.dart';

class ValidationUtils {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    final passwordRegex = RegExp(AppConstants.passwordPattern);
    if (!passwordRegex.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Name must be less than ${AppConstants.maxNameLength} characters';
    }

    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }

    if (age < AppConstants.minAge || age > AppConstants.maxAge) {
      return 'Age must be between ${AppConstants.minAge} and ${AppConstants.maxAge}';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateLength(
    String? value,
    int minLength,
    int maxLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }

    if (value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  static String? validateMessage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Message cannot be empty';
    }

    if (value.length > AppConstants.maxMessageLength) {
      return 'Message must be less than ${AppConstants.maxMessageLength} characters';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    return RegExp(AppConstants.emailPattern).hasMatch(email);
  }

  static bool isValidPhoneNumber(String phone) {
    return RegExp(AppConstants.phonePattern).hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return password.length >= 8 &&
        RegExp(AppConstants.passwordPattern).hasMatch(password);
  }
}
