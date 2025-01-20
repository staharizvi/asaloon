import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  // Private variables
  bool _isAuthenticated = true; // Tracks authentication status
  String? _username; // Stores the authenticated username (if any)

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;

  // Method for signing in
  Future<void> signIn(String username, String password) async {
    // Simulate an API call or authentication process
    await Future.delayed(const Duration(seconds: 2)); // Simulate a network delay

    // Example validation logic (replace with real validation)
    if (username == 'test' && password == 'password') {
      _isAuthenticated = true;
      _username = username;

      // Notify listeners about the state change
      notifyListeners();
    } else {
      throw Exception('Invalid username or password');
    }
  }

  // Method for signing out
  void signOut() {
    _isAuthenticated = false;
    _username = null;

    // Notify listeners about the state change
    notifyListeners();
  }

  // Method to simulate checking authentication status (e.g., auto-login)
  Future<void> checkAuthStatus() async {
    // Simulate a saved session or token validation
    await Future.delayed(const Duration(seconds: 1));

    // Example logic for restoring session
    _isAuthenticated = false; // Assume no session is found
    _username = null;

    // Notify listeners
    notifyListeners();
  }
}
