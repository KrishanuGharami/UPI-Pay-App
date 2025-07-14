import 'package:flutter/foundation.dart';

class MockAuthService with ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _verificationId;
  String? get verificationId => _verificationId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Mock user data
  Map<String, dynamic>? _userData;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Mock send OTP - always succeeds after 2 seconds
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      _setLoading(true);
      _setError(null);

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Validate phone number format
      if (phoneNumber.length < 10) {
        _setError('Please enter a valid phone number');
        _setLoading(false);
        return false;
      }

      _verificationId =
          "mock_verification_id_${DateTime.now().millisecondsSinceEpoch}";
      _setLoading(false);

      if (kDebugMode) {
        debugPrint('Mock OTP sent to $phoneNumber. Use 123456 to verify.');
      }
      return true;
    } catch (e) {
      _setError('Failed to send OTP: $e');
      _setLoading(false);
      return false;
    }
  }

  // Mock verify OTP - accepts 123456 as valid OTP
  Future<bool> verifyOTP(String otp) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_verificationId == null) {
        _setError('Verification ID not found. Please request OTP again.');
        _setLoading(false);
        return false;
      }

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      if (otp == "123456") {
        // Mock successful authentication
        _isAuthenticated = true;
        _userData = {
          'uid': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
          'phoneNumber': '+91 9876543210', // Mock phone number
          'name': 'Test User',
          'profileImageUrl': '',
          'createdAt': DateTime.now().toIso8601String(),
          'isProfileComplete': false,
        };

        _setLoading(false);
        if (kDebugMode) {
          debugPrint('Mock authentication successful!');
        }
        return true;
      } else {
        _setError('Invalid OTP. Use 123456 for testing.');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Verification failed: $e');
      _setLoading(false);
      return false;
    }
  }

  // Mock get user data
  Future<Map<String, dynamic>?> getUserData() async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); // Simulate network delay
    return _userData;
  }

  // Mock update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    try {
      await Future.delayed(
        const Duration(seconds: 1),
      ); // Simulate network delay

      if (_userData != null) {
        if (name != null) _userData!['name'] = name;
        if (profileImageUrl != null) {
          _userData!['profileImageUrl'] = profileImageUrl;
        }
        _userData!['isProfileComplete'] = true;
        _userData!['updatedAt'] = DateTime.now().toIso8601String();

        notifyListeners();
        if (kDebugMode) {
          debugPrint('Mock profile updated: $name');
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to update profile: $e');
      return false;
    }
  }

  // Mock sign out
  Future<void> signOut() async {
    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay

      _isAuthenticated = false;
      _userData = null;
      _verificationId = null;
      _errorMessage = null;

      notifyListeners();
      if (kDebugMode) {
        debugPrint('Mock sign out successful');
      }
    } catch (e) {
      _setError('Sign out failed: $e');
    }
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Mock properties for compatibility
  get currentUser => _isAuthenticated ? {'uid': _userData?['uid']} : null;
}
