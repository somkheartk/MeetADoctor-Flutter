import 'package:flutter/material.dart';

class AppColors {
  // Primary Healthcare Colors
  static const Color primary = Color(0xFF7B68EE);
  static const Color primaryLight = Color(0xFFB19CD9);
  static const Color primaryDark = Color(0xFF5A4FCF);

  // Secondary Colors
  static const Color secondary = Color(0xFF00E676);
  static const Color secondaryLight = Color(0xFF69F0AE);
  static const Color secondaryDark = Color(0xFF00C853);

  // Status Colors
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF2196F3);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF5F5F5);

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowDark = Colors.black.withOpacity(0.15);
}

class AppGradients {
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryLight],
  );

  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.secondary, AppColors.secondaryLight],
  );

  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.success, AppColors.secondaryLight],
  );
}
