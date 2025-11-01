class AppConstants {
  // App Information
  static const String appName = 'Healthcare';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.healthcare.com';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String keyUserToken = 'user_token';
  static const String keyUserProfile = 'user_profile';
  static const String keyAppSettings = 'app_settings';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // Default Values
  static const String defaultLanguage = 'en';
  static const String defaultCountryCode = '+1';

  // Limits
  static const int maxUploadSize = 5 * 1024 * 1024; // 5MB
  static const int maxImageSize = 2 * 1024 * 1024; // 2MB
  static const int maxMessageLength = 500;
  static const int maxNameLength = 50;

  // URLs
  static const String privacyPolicyUrl = 'https://healthcare.com/privacy';
  static const String termsOfServiceUrl = 'https://healthcare.com/terms';
  static const String supportUrl = 'https://healthcare.com/support';

  // Social Media
  static const String facebookUrl = 'https://facebook.com/healthcare';
  static const String twitterUrl = 'https://twitter.com/healthcare';
  static const String instagramUrl = 'https://instagram.com/healthcare';

  // Date Formats
  static const String dateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'h:mm a';
  static const String dateTimeFormat = 'MMM dd, yyyy • h:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';
  static const String apiTimeFormat = 'HH:mm:ss';

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Debounce Durations
  static const Duration debounceSearch = Duration(milliseconds: 500);
  static const Duration debounceButton = Duration(milliseconds: 1000);

  // Chat
  static const int maxChatHistoryDays = 30;
  static const int maxMessagesPerPage = 50;

  // Appointment
  static const int appointmentReminderMinutes = 30;
  static const int maxAppointmentsPerDay = 10;
  static const int advanceBookingDays = 30;

  // Doctor
  static const double minDoctorRating = 1.0;
  static const double maxDoctorRating = 5.0;
  static const int maxDoctorExperience = 50;

  // Profile
  static const int minAge = 1;
  static const int maxAge = 120;
  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // Validation
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phonePattern = r'^\+?[1-9]\d{1,14}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';
}

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String doctorDetail = '/doctor-detail';
  static const String appointments = '/appointments';
  static const String chat = '/chat';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String help = '/help';
  static const String about = '/about';
}

class AppAssets {
  // Images
  static const String logoPath = 'assets/images/logo.png';
  static const String onboardingImage = 'assets/images/onboarding.png';
  static const String defaultAvatar = 'assets/images/default_avatar.png';
  static const String defaultDoctor = 'assets/images/default_doctor.png';

  // Icons
  static const String iconsPath = 'assets/icons/';
  static const String heartIcon = '${iconsPath}heart.svg';
  static const String stethoscopeIcon = '${iconsPath}stethoscope.svg';
  static const String pillIcon = '${iconsPath}pill.svg';

  // Animations
  static const String animationsPath = 'assets/animations/';
  static const String loadingAnimation = '${animationsPath}loading.json';
  static const String successAnimation = '${animationsPath}success.json';
  static const String errorAnimation = '${animationsPath}error.json';
}
