import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  final String id;
  final String userId; // Owner of this contact
  final String name;
  final String phoneNumber;
  final String? upiId;
  final String? profileImageUrl;
  final bool isFavorite;
  final bool isBlocked;
  final DateTime addedAt;
  final DateTime? lastTransactionAt;
  final ContactStats stats;

  ContactModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    this.upiId,
    this.profileImageUrl,
    this.isFavorite = false,
    this.isBlocked = false,
    required this.addedAt,
    this.lastTransactionAt,
    ContactStats? stats,
  }) : stats = stats ?? ContactStats();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'upiId': upiId,
      'profileImageUrl': profileImageUrl,
      'isFavorite': isFavorite,
      'isBlocked': isBlocked,
      'addedAt': Timestamp.fromDate(addedAt),
      'lastTransactionAt': lastTransactionAt != null 
          ? Timestamp.fromDate(lastTransactionAt!) 
          : null,
      'stats': stats.toMap(),
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      upiId: map['upiId'],
      profileImageUrl: map['profileImageUrl'],
      isFavorite: map['isFavorite'] ?? false,
      isBlocked: map['isBlocked'] ?? false,
      addedAt: (map['addedAt'] as Timestamp).toDate(),
      lastTransactionAt: map['lastTransactionAt'] != null 
          ? (map['lastTransactionAt'] as Timestamp).toDate() 
          : null,
      stats: ContactStats.fromMap(map['stats'] ?? {}),
    );
  }

  ContactModel copyWith({
    String? name,
    String? phoneNumber,
    String? upiId,
    String? profileImageUrl,
    bool? isFavorite,
    bool? isBlocked,
    DateTime? lastTransactionAt,
    ContactStats? stats,
  }) {
    return ContactModel(
      id: id,
      userId: userId,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      upiId: upiId ?? this.upiId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      isBlocked: isBlocked ?? this.isBlocked,
      addedAt: addedAt,
      lastTransactionAt: lastTransactionAt ?? this.lastTransactionAt,
      stats: stats ?? this.stats,
    );
  }
}

class ContactStats {
  final int totalTransactions;
  final double totalAmountSent;
  final double totalAmountReceived;
  final double lastTransactionAmount;

  ContactStats({
    this.totalTransactions = 0,
    this.totalAmountSent = 0.0,
    this.totalAmountReceived = 0.0,
    this.lastTransactionAmount = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalTransactions': totalTransactions,
      'totalAmountSent': totalAmountSent,
      'totalAmountReceived': totalAmountReceived,
      'lastTransactionAmount': lastTransactionAmount,
    };
  }

  factory ContactStats.fromMap(Map<String, dynamic> map) {
    return ContactStats(
      totalTransactions: map['totalTransactions'] ?? 0,
      totalAmountSent: (map['totalAmountSent'] ?? 0.0).toDouble(),
      totalAmountReceived: (map['totalAmountReceived'] ?? 0.0).toDouble(),
      lastTransactionAmount: (map['lastTransactionAmount'] ?? 0.0).toDouble(),
    );
  }
}
