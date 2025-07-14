import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String phoneNumber;
  final String name;
  final String email;
  final String profileImageUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final DateTime? updatedAt;
  final bool isProfileComplete;
  final bool isVerified;
  final List<BankAccount> linkedBankAccounts;
  final UserPreferences preferences;
  final UserStats stats;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    required this.name,
    this.email = '',
    this.profileImageUrl = '',
    required this.createdAt,
    required this.lastLoginAt,
    this.updatedAt,
    this.isProfileComplete = false,
    this.isVerified = false,
    this.linkedBankAccounts = const [],
    UserPreferences? preferences,
    UserStats? stats,
  }) : preferences = preferences ?? UserPreferences(),
       stats = stats ?? UserStats();

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isProfileComplete': isProfileComplete,
      'isVerified': isVerified,
      'linkedBankAccounts': linkedBankAccounts.map((account) => account.toMap()).toList(),
      'preferences': preferences.toMap(),
      'stats': stats.toMap(),
    };
  }

  // Create from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (map['lastLoginAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] != null ? (map['updatedAt'] as Timestamp).toDate() : null,
      isProfileComplete: map['isProfileComplete'] ?? false,
      isVerified: map['isVerified'] ?? false,
      linkedBankAccounts: (map['linkedBankAccounts'] as List<dynamic>?)
          ?.map((account) => BankAccount.fromMap(account))
          .toList() ?? [],
      preferences: UserPreferences.fromMap(map['preferences'] ?? {}),
      stats: UserStats.fromMap(map['stats'] ?? {}),
    );
  }

  // Create a copy with updated fields
  UserModel copyWith({
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? updatedAt,
    bool? isProfileComplete,
    bool? isVerified,
    List<BankAccount>? linkedBankAccounts,
    UserPreferences? preferences,
    UserStats? stats,
  }) {
    return UserModel(
      uid: uid,
      phoneNumber: phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      isVerified: isVerified ?? this.isVerified,
      linkedBankAccounts: linkedBankAccounts ?? this.linkedBankAccounts,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
    );
  }
}

class BankAccount {
  final String id;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final String accountHolderName;
  final String accountType; // savings, current, etc.
  final bool isPrimary;
  final bool isVerified;
  final DateTime addedAt;

  BankAccount({
    required this.id,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
    required this.accountHolderName,
    required this.accountType,
    this.isPrimary = false,
    this.isVerified = false,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'accountHolderName': accountHolderName,
      'accountType': accountType,
      'isPrimary': isPrimary,
      'isVerified': isVerified,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  factory BankAccount.fromMap(Map<String, dynamic> map) {
    return BankAccount(
      id: map['id'] ?? '',
      bankName: map['bankName'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      ifscCode: map['ifscCode'] ?? '',
      accountHolderName: map['accountHolderName'] ?? '',
      accountType: map['accountType'] ?? 'savings',
      isPrimary: map['isPrimary'] ?? false,
      isVerified: map['isVerified'] ?? false,
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }
}

class UserPreferences {
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final String language;
  final String currency;
  final bool darkMode;
  final double transactionLimit;

  UserPreferences({
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    this.language = 'en',
    this.currency = 'INR',
    this.darkMode = false,
    this.transactionLimit = 50000.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'biometricEnabled': biometricEnabled,
      'language': language,
      'currency': currency,
      'darkMode': darkMode,
      'transactionLimit': transactionLimit,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      biometricEnabled: map['biometricEnabled'] ?? false,
      language: map['language'] ?? 'en',
      currency: map['currency'] ?? 'INR',
      darkMode: map['darkMode'] ?? false,
      transactionLimit: (map['transactionLimit'] ?? 50000.0).toDouble(),
    );
  }
}

class UserStats {
  final int totalTransactions;
  final double totalAmountSent;
  final double totalAmountReceived;
  final int contactsCount;
  final DateTime? lastTransactionDate;

  UserStats({
    this.totalTransactions = 0,
    this.totalAmountSent = 0.0,
    this.totalAmountReceived = 0.0,
    this.contactsCount = 0,
    this.lastTransactionDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalTransactions': totalTransactions,
      'totalAmountSent': totalAmountSent,
      'totalAmountReceived': totalAmountReceived,
      'contactsCount': contactsCount,
      'lastTransactionDate': lastTransactionDate != null 
          ? Timestamp.fromDate(lastTransactionDate!) 
          : null,
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalTransactions: map['totalTransactions'] ?? 0,
      totalAmountSent: (map['totalAmountSent'] ?? 0.0).toDouble(),
      totalAmountReceived: (map['totalAmountReceived'] ?? 0.0).toDouble(),
      contactsCount: map['contactsCount'] ?? 0,
      lastTransactionDate: map['lastTransactionDate'] != null 
          ? (map['lastTransactionDate'] as Timestamp).toDate() 
          : null,
    );
  }
}
