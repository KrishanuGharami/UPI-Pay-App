import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/transaction_model.dart';
import '../main/main_navigation_screen.dart';

class PaymentResultScreen extends StatelessWidget {
  final TransactionModel transaction;

  const PaymentResultScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = transaction.isCompleted;
    final bool isPending = transaction.isPending;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isSuccess
                ? [Colors.green[400]!, Colors.green[600]!]
                : isPending
                ? [Colors.orange[400]!, Colors.orange[600]!]
                : [Colors.red[400]!, Colors.red[600]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Status Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess
                        ? Icons.check_circle
                        : isPending
                        ? Icons.schedule
                        : Icons.error,
                    size: 80,
                    color: isSuccess
                        ? Colors.green
                        : isPending
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),

                const SizedBox(height: 24),

                // Status Title
                Text(
                  isSuccess
                      ? 'Payment Successful!'
                      : isPending
                      ? 'Payment Pending'
                      : 'Payment Failed',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Status Message
                Text(
                  isSuccess
                      ? 'Your payment has been processed successfully'
                      : isPending
                      ? 'Your payment is being processed'
                      : transaction.failureReason ??
                            'Payment could not be completed',
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Transaction Details Card
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Transaction Details Header
                          const Text(
                            'Transaction Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Amount
                          _buildDetailRow(
                            'Amount',
                            '₹${transaction.amount.toStringAsFixed(2)}',
                            isAmount: true,
                          ),

                          // Recipient
                          _buildDetailRow('To', transaction.receiverName),

                          // UPI ID
                          _buildDetailRow('UPI ID', transaction.receiverUpiId),

                          // Transaction ID
                          if (transaction.upiTransactionId != null)
                            _buildDetailRow(
                              'Transaction ID',
                              transaction.upiTransactionId!,
                              isCopyable: true,
                            ),

                          // Reference ID
                          if (transaction.referenceId != null)
                            _buildDetailRow(
                              'Reference ID',
                              transaction.referenceId!,
                              isCopyable: true,
                            ),

                          // Date & Time
                          _buildDetailRow(
                            'Date & Time',
                            _formatDateTime(transaction.createdAt),
                          ),

                          // Note
                          if (transaction.note.isNotEmpty)
                            _buildDetailRow('Note', transaction.note),

                          // Status
                          _buildDetailRow(
                            'Status',
                            transaction.statusDisplayName,
                            statusColor: isSuccess
                                ? Colors.green
                                : isPending
                                ? Colors.orange
                                : Colors.red,
                          ),

                          const Spacer(),

                          // Action Buttons
                          Column(
                            children: [
                              // Share Receipt Button
                              if (isSuccess)
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: OutlinedButton.icon(
                                    onPressed: () => _shareReceipt(context),
                                    icon: const Icon(Icons.share),
                                    label: const Text('Share Receipt'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF667eea),
                                      side: const BorderSide(
                                        color: Color(0xFF667eea),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                              if (isSuccess) const SizedBox(height: 12),

                              // Done Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () => _goToHome(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF667eea),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isAmount = false,
    bool isCopyable = false,
    Color? statusColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: isAmount ? 18 : 14,
                      fontWeight: isAmount ? FontWeight.bold : FontWeight.w500,
                      color: statusColor ?? Colors.black87,
                    ),
                  ),
                ),
                if (isCopyable)
                  GestureDetector(
                    onTap: () => _copyToClipboard(value),
                    child: const Icon(
                      Icons.copy,
                      size: 16,
                      color: Color(0xFF667eea),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void _shareReceipt(BuildContext context) {
    final receiptText =
        '''
UPI Payment Receipt
-------------------
Amount: ₹${transaction.amount.toStringAsFixed(2)}
To: ${transaction.receiverName}
UPI ID: ${transaction.receiverUpiId}
Transaction ID: ${transaction.upiTransactionId ?? 'N/A'}
Date: ${_formatDateTime(transaction.createdAt)}
Status: ${transaction.statusDisplayName}
${transaction.note.isNotEmpty ? 'Note: ${transaction.note}' : ''}
-------------------
Powered by UPI Pay
''';

    Clipboard.setData(ClipboardData(text: receiptText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt copied to clipboard'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      (route) => false,
    );
  }
}
