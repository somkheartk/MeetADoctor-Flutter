class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Simple in-memory storage (in real app, use SharedPreferences or secure storage)
  bool _isLoggedIn = false;
  String? _userEmail;

  // Check if user is logged in
  bool isLoggedIn() {
    return _isLoggedIn;
  }

  // Login user
  Future<void> login(String email) async {
    _isLoggedIn = true;
    _userEmail = email;
  }

  // Logout user
  Future<void> logout() async {
    _isLoggedIn = false;
    _userEmail = null;
  }

  // Get user email
  String? getUserEmail() {
    return _userEmail;
  }

  // Simulate login validation
  Future<bool> validateLogin(String email, String password) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation - in real app, this would be API call
    if (email.isNotEmpty && password.length >= 6) {
      return true;
    }
    return false;
  }
}
