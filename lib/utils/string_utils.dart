class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - suffix.length) + suffix;
  }

  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'\D'), '');

    if (digits.length == 10) {
      // Format as (XXX) XXX-XXXX
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      // Format as +1 (XXX) XXX-XXXX
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    return phoneNumber; // Return original if doesn't match expected format
  }

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  static String getInitials(String name) {
    if (name.isEmpty) return '';

    final words = name.split(' ');
    if (words.length == 1) {
      return words[0].substring(0, 1).toUpperCase();
    }

    return words
        .take(2)
        .map((word) => word.substring(0, 1).toUpperCase())
        .join();
  }

  static bool isNullOrEmpty(String? text) {
    return text == null || text.isEmpty;
  }

  static bool isNotNullOrEmpty(String? text) {
    return text != null && text.isNotEmpty;
  }

  static String removeExtraSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String maskEmail(String email) {
    if (!email.contains('@')) return email;

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 3) {
      return '***@$domain';
    }

    final visibleChars = username.substring(0, 2);
    final maskedChars = '*' * (username.length - 2);
    return '$visibleChars$maskedChars@$domain';
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 4) return phoneNumber;

    final lastFour = phoneNumber.substring(phoneNumber.length - 4);
    final masked = '*' * (phoneNumber.length - 4);
    return '$masked$lastFour';
  }

  static bool containsOnlyNumbers(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }

  static bool containsOnlyLetters(String text) {
    return RegExp(r'^[a-zA-Z]+$').hasMatch(text);
  }

  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(
      length,
      (index) => chars[(random + index) % chars.length],
    ).join();
  }
}
