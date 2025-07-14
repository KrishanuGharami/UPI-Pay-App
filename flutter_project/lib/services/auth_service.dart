import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  String? _verificationId;
  String? get verificationId => _verificationId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Send OTP to phone number
  Future<bool> sendOTP(String phoneNumber) async {
    try {
      _setLoading(true);
      _setError(null);

      // Debug logging
      if (kDebugMode) {
        debugPrint('🔥 Firebase Auth: Sending OTP to $phoneNumber');
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          if (kDebugMode) {
            debugPrint('🔥 Firebase Auth: Auto-verification completed');
          }
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (kDebugMode) {
            debugPrint(
              '🔥 Firebase Auth: Verification failed - ${e.code}: ${e.message}',
            );
          }

          String errorMessage = _getReadableErrorMessage(e);
          _setError(errorMessage);
          _setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          if (kDebugMode) {
            debugPrint('🔥 Firebase Auth: Code sent successfully');
          }
          _verificationId = verificationId;
          _setLoading(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (kDebugMode) {
            debugPrint('🔥 Firebase Auth: Code auto-retrieval timeout');
          }
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 60),
      );

      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('🔥 Firebase Auth: Exception - $e');
      }
      _setError('Failed to send OTP: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Verify OTP and sign in
  Future<bool> verifyOTP(String otp) async {
    try {
      _setLoading(true);
      _setError(null);

      if (_verificationId == null) {
        _setError('Verification ID not found. Please request OTP again.');
        _setLoading(false);
        return false;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      return await _signInWithCredential(credential);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sign in with credential
  Future<bool> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        // Check if user exists in Firestore, if not create user document
        await _createOrUpdateUserDocument(userCredential.user!);
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Create or update user document in Firestore
  Future<void> _createOrUpdateUserDocument(User user) async {
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      DocumentSnapshot docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // Create new user document
        await userDoc.set({
          'uid': user.uid,
          'phoneNumber': user.phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'lastLoginAt': FieldValue.serverTimestamp(),
          'name': '',
          'profileImageUrl': '',
          'linkedBankAccounts': [],
          'isProfileComplete': false,
        });
      } else {
        // Update last login time
        await userDoc.update({'lastLoginAt': FieldValue.serverTimestamp()});
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error creating/updating user document: $e');
      }
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      if (currentUser == null) return null;

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error getting user data: $e');
      }
      return null;
    }
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? profileImageUrl,
  }) async {
    try {
      if (currentUser == null) return false;

      Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      if (updateData.isNotEmpty) {
        updateData['isProfileComplete'] = true;
        updateData['updatedAt'] = FieldValue.serverTimestamp();

        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .update(updateData);
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _verificationId = null;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    }
  }

  // Clear error
  void clearError() {
    _setError(null);
  }

  // Get readable error message from Firebase exception
  String _getReadableErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-phone-number':
        return 'Invalid phone number format. Please use international format (+91XXXXXXXXXX)';
      case 'too-many-requests':
        return 'Too many requests. Please try again later or use a test phone number';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection';
      case 'app-not-authorized':
        return 'App not authorized. Please check Firebase configuration';
      case 'captcha-check-failed':
        return 'reCAPTCHA verification failed. Please try again';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again tomorrow or contact support';
      case 'invalid-verification-code':
        return 'Invalid verification code. Please check and try again';
      case 'session-expired':
        return 'Verification session expired. Please request a new code';
      default:
        return e.message ?? 'Authentication failed. Please try again';
    }
  }
}
