import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF667eea),
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Transaction History',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: _showFilterOptions,
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                ),
                IconButton(
                  onPressed: _showSearchDialog,
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
              ],
            ),
          ];
        },
        body: Column(
          children: [
            // Filter Tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF667eea),
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF667eea),
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Sent'),
                  Tab(text: 'Received'),
                  Tab(text: 'Pending'),
                ],
              ),
            ),

            // Transaction List
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTransactionList('all'),
                  _buildTransactionList('sent'),
                  _buildTransactionList('received'),
                  _buildTransactionList('pending'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(String filter) {
    // Mock transaction data - will be replaced with real data
    final mockTransactions = _getMockTransactions(filter);

    if (mockTransactions.isEmpty) {
      return _buildEmptyState(filter);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockTransactions.length,
      itemBuilder: (context, index) {
        final transaction = mockTransactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildEmptyState(String filter) {
    String message = 'No transactions found';
    IconData icon = Icons.receipt_long_outlined;

    switch (filter) {
      case 'sent':
        message = 'No sent transactions';
        icon = Icons.arrow_upward;
        break;
      case 'received':
        message = 'No received transactions';
        icon = Icons.arrow_downward;
        break;
      case 'pending':
        message = 'No pending transactions';
        icon = Icons.schedule;
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transactions will appear here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final bool isSent = transaction['type'] == 'sent';
    final bool isPending = transaction['status'] == 'pending';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showTransactionDetails(transaction),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Transaction Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTransactionColor(
                    isSent,
                    isPending,
                  ).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getTransactionIcon(isSent, isPending),
                  color: _getTransactionColor(isSent, isPending),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          transaction['recipient'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '${isSent ? '-' : '+'}₹${transaction['amount'].toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getTransactionColor(isSent, isPending),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isSent ? 'Money sent' : 'Money received',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isPending
                                ? Colors.orange.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            isPending ? 'Pending' : 'Completed',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isPending ? Colors.orange : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(transaction['date']),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMockTransactions(String filter) {
    final allTransactions = [
      {
        'id': '1',
        'type': 'sent',
        'amount': 500.0,
        'recipient': 'John Doe',
        'date': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'completed',
        'upiId': 'john@paytm',
      },
      {
        'id': '2',
        'type': 'received',
        'amount': 1200.0,
        'recipient': 'Sarah Wilson',
        'date': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'completed',
        'upiId': 'sarah@gpay',
      },
      {
        'id': '3',
        'type': 'sent',
        'amount': 250.0,
        'recipient': 'Mike Johnson',
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'status': 'pending',
        'upiId': 'mike@phonepe',
      },
      // Add more mock transactions...
    ];

    switch (filter) {
      case 'sent':
        return allTransactions.where((t) => t['type'] == 'sent').toList();
      case 'received':
        return allTransactions.where((t) => t['type'] == 'received').toList();
      case 'pending':
        return allTransactions.where((t) => t['status'] == 'pending').toList();
      default:
        return allTransactions;
    }
  }

  IconData _getTransactionIcon(bool isSent, bool isPending) {
    if (isPending) return Icons.schedule;
    return isSent ? Icons.arrow_upward : Icons.arrow_downward;
  }

  Color _getTransactionColor(bool isSent, bool isPending) {
    if (isPending) return Colors.orange;
    return isSent ? Colors.red : Colors.green;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Date Range'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Date filter - Coming Soon!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.currency_rupee),
              title: const Text('Amount Range'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Amount filter - Coming Soon!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Transactions'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter recipient name or UPI ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search functionality - Coming Soon!'),
                ),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Transaction Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildDetailRow('Transaction ID', transaction['id']),
                    _buildDetailRow('Amount', '₹${transaction['amount']}'),
                    _buildDetailRow('Recipient', transaction['recipient']),
                    _buildDetailRow('Status', transaction['status']),
                    _buildDetailRow('Date', _formatDate(transaction['date'])),
                    if (transaction['upiId'] != null)
                      _buildDetailRow('UPI ID', transaction['upiId']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
