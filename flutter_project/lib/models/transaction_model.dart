import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { sent, received, request }
enum TransactionStatus { pending, completed, failed, cancelled }

class TransactionModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String senderName;
  final String receiverName;
  final String senderUpiId;
  final String receiverUpiId;
  final double amount;
  final String note;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? failureReason;
  final String? upiTransactionId;
  final String? referenceId;

  TransactionModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderName,
    required this.receiverName,
    required this.senderUpiId,
    required this.receiverUpiId,
    required this.amount,
    this.note = '',
    required this.type,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.failureReason,
    this.upiTransactionId,
    this.referenceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'receiverName': receiverName,
      'senderUpiId': senderUpiId,
      'receiverUpiId': receiverUpiId,
      'amount': amount,
      'note': note,
      'type': type.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'failureReason': failureReason,
      'upiTransactionId': upiTransactionId,
      'referenceId': referenceId,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      senderName: map['senderName'] ?? '',
      receiverName: map['receiverName'] ?? '',
      senderUpiId: map['senderUpiId'] ?? '',
      receiverUpiId: map['receiverUpiId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      note: map['note'] ?? '',
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.sent,
      ),
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => TransactionStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      completedAt: map['completedAt'] != null 
          ? (map['completedAt'] as Timestamp).toDate() 
          : null,
      failureReason: map['failureReason'],
      upiTransactionId: map['upiTransactionId'],
      referenceId: map['referenceId'],
    );
  }

  TransactionModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? senderName,
    String? receiverName,
    String? senderUpiId,
    String? receiverUpiId,
    double? amount,
    String? note,
    TransactionType? type,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    String? failureReason,
    String? upiTransactionId,
    String? referenceId,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      senderName: senderName ?? this.senderName,
      receiverName: receiverName ?? this.receiverName,
      senderUpiId: senderUpiId ?? this.senderUpiId,
      receiverUpiId: receiverUpiId ?? this.receiverUpiId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      failureReason: failureReason ?? this.failureReason,
      upiTransactionId: upiTransactionId ?? this.upiTransactionId,
      referenceId: referenceId ?? this.referenceId,
    );
  }

  // Helper methods
  bool get isPending => status == TransactionStatus.pending;
  bool get isCompleted => status == TransactionStatus.completed;
  bool get isFailed => status == TransactionStatus.failed;
  bool get isCancelled => status == TransactionStatus.cancelled;

  String get statusDisplayName {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get typeDisplayName {
    switch (type) {
      case TransactionType.sent:
        return 'Money Sent';
      case TransactionType.received:
        return 'Money Received';
      case TransactionType.request:
        return 'Money Requested';
    }
  }

  // Generate UPI payment URL
  String generateUpiUrl() {
    final upiUrl = 'upi://pay?'
        'pa=$receiverUpiId&'
        'pn=${Uri.encodeComponent(receiverName)}&'
        'am=$amount&'
        'cu=INR&'
        'tn=${Uri.encodeComponent(note.isNotEmpty ? note : 'Payment')}&'
        'tr=$referenceId';
    
    return upiUrl;
  }

  // Parse UPI URL to create transaction
  static TransactionModel? fromUpiUrl(String upiUrl, String currentUserId, String currentUserName, String currentUserUpiId) {
    try {
      final uri = Uri.parse(upiUrl);
      final params = uri.queryParameters;

      final receiverUpiId = params['pa'] ?? '';
      final receiverName = params['pn'] ?? '';
      final amount = double.tryParse(params['am'] ?? '0') ?? 0.0;
      final note = params['tn'] ?? '';
      final referenceId = params['tr'] ?? '';

      if (receiverUpiId.isEmpty || amount <= 0) {
        return null;
      }

      return TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUserId,
        receiverId: '', // Will be resolved later
        senderName: currentUserName,
        receiverName: receiverName,
        senderUpiId: currentUserUpiId,
        receiverUpiId: receiverUpiId,
        amount: amount,
        note: note,
        type: TransactionType.sent,
        status: TransactionStatus.pending,
        createdAt: DateTime.now(),
        referenceId: referenceId.isNotEmpty ? referenceId : null,
      );
    } catch (e) {
      return null;
    }
  }
}
