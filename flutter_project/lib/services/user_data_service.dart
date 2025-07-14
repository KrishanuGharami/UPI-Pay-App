import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/contact_model.dart';

class UserDataService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  List<ContactModel> _contacts = [];
  List<ContactModel> get contacts => _contacts;

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

  void clearError() {
    _setError(null);
  }

  // Initialize user data when user logs in
  Future<bool> initializeUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      _setLoading(true);
      _setError(null);

      // Load user data
      await loadUserData();

      // Load contacts
      await loadContacts();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to initialize user data: $e');
      _setLoading(false);
      return false;
    }
  }

  // Load user data from Firestore
  Future<UserModel?> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        _currentUser = UserModel.fromMap(doc.data()!);
        notifyListeners();
        return _currentUser;
      }
      return null;
    } catch (e) {
      _setError('Failed to load user data: $e');
      return null;
    }
  }

  // Create or update user profile
  Future<bool> updateUserProfile({
    String? name,
    String? email,
    File? profileImage,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      _setLoading(true);
      _setError(null);

      Map<String, dynamic> updateData = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Update name
      if (name != null && name.isNotEmpty) {
        updateData['name'] = name;
      }

      // Update email
      if (email != null && email.isNotEmpty) {
        updateData['email'] = email;
      }

      // Upload profile image if provided
      if (profileImage != null) {
        final imageUrl = await _uploadProfileImage(user.uid, profileImage);
        if (imageUrl != null) {
          updateData['profileImageUrl'] = imageUrl;
        }
      }

      // Check if profile is complete
      final currentData = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();
      if (currentData.exists) {
        final userData = currentData.data()!;
        final hasName = (updateData['name'] ?? userData['name'] ?? '')
            .toString()
            .isNotEmpty;
        final hasImage =
            (updateData['profileImageUrl'] ?? userData['profileImageUrl'] ?? '')
                .toString()
                .isNotEmpty;

        updateData['isProfileComplete'] = hasName && hasImage;
      }

      // Update in Firestore
      await _firestore.collection('users').doc(user.uid).update(updateData);

      // Reload user data
      await loadUserData();

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to update profile: $e');
      _setLoading(false);
      return false;
    }
  }

  // Upload profile image to Firebase Storage
  Future<String?> _uploadProfileImage(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_images').child('$userId.jpg');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error uploading profile image: $e');
      }
      return null;
    }
  }

  // Add bank account
  Future<bool> addBankAccount(BankAccount bankAccount) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      _setLoading(true);
      _setError(null);

      // If this is the first bank account, make it primary
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final existingAccounts =
            (userData['linkedBankAccounts'] as List<dynamic>?) ?? [];

        BankAccount accountToAdd = bankAccount;
        if (existingAccounts.isEmpty) {
          accountToAdd = BankAccount(
            id: bankAccount.id,
            bankName: bankAccount.bankName,
            accountNumber: bankAccount.accountNumber,
            ifscCode: bankAccount.ifscCode,
            accountHolderName: bankAccount.accountHolderName,
            accountType: bankAccount.accountType,
            isPrimary: true, // First account is primary
            isVerified: bankAccount.isVerified,
            addedAt: bankAccount.addedAt,
          );
        }

        await _firestore.collection('users').doc(user.uid).update({
          'linkedBankAccounts': FieldValue.arrayUnion([accountToAdd.toMap()]),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        await loadUserData();
        _setLoading(false);
        return true;
      }

      _setLoading(false);
      return false;
    } catch (e) {
      _setError('Failed to add bank account: $e');
      _setLoading(false);
      return false;
    }
  }

  // Remove bank account
  Future<bool> removeBankAccount(String accountId) async {
    try {
      final user = _auth.currentUser;
      if (user == null || _currentUser == null) return false;

      _setLoading(true);
      _setError(null);

      // Find and remove the account
      final accountToRemove = _currentUser!.linkedBankAccounts.firstWhere(
        (account) => account.id == accountId,
      );

      await _firestore.collection('users').doc(user.uid).update({
        'linkedBankAccounts': FieldValue.arrayRemove([accountToRemove.toMap()]),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await loadUserData();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to remove bank account: $e');
      _setLoading(false);
      return false;
    }
  }

  // Update user preferences
  Future<bool> updateUserPreferences(UserPreferences preferences) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore.collection('users').doc(user.uid).update({
        'preferences': preferences.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      await loadUserData();
      return true;
    } catch (e) {
      _setError('Failed to update preferences: $e');
      return false;
    }
  }

  // Load user contacts
  Future<void> loadContacts() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final querySnapshot = await _firestore
          .collection('contacts')
          .where('userId', isEqualTo: user.uid)
          .where('isBlocked', isEqualTo: false)
          .orderBy('name')
          .get();

      _contacts = querySnapshot.docs
          .map((doc) => ContactModel.fromMap(doc.data()))
          .toList();

      notifyListeners();
    } catch (e) {
      _setError('Failed to load contacts: $e');
    }
  }

  // Add contact
  Future<bool> addContact(ContactModel contact) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      await _firestore
          .collection('contacts')
          .doc(contact.id)
          .set(contact.toMap());
      await loadContacts();
      return true;
    } catch (e) {
      _setError('Failed to add contact: $e');
      return false;
    }
  }

  // Update contact
  Future<bool> updateContact(ContactModel contact) async {
    try {
      await _firestore
          .collection('contacts')
          .doc(contact.id)
          .update(contact.toMap());
      await loadContacts();
      return true;
    } catch (e) {
      _setError('Failed to update contact: $e');
      return false;
    }
  }

  // Delete contact
  Future<bool> deleteContact(String contactId) async {
    try {
      await _firestore.collection('contacts').doc(contactId).delete();
      await loadContacts();
      return true;
    } catch (e) {
      _setError('Failed to delete contact: $e');
      return false;
    }
  }

  // Clear all data on logout
  void clearUserData() {
    _currentUser = null;
    _contacts = [];
    _errorMessage = null;
    notifyListeners();
  }
}
