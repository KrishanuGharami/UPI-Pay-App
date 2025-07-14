import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _markAllAsRead,
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: _buildNotificationsList(),
    );
  }

  Widget _buildNotificationsList() {
    // Mock notification data - will be replaced with real data
    final mockNotifications = [
      {
        'id': '1',
        'title': 'Payment Received',
        'message': 'You received ₹500 from John Doe',
        'time': DateTime.now().subtract(const Duration(minutes: 30)),
        'type': 'payment_received',
        'isRead': false,
      },
      {
        'id': '2',
        'title': 'Payment Sent',
        'message': 'You sent ₹250 to Sarah Wilson',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'type': 'payment_sent',
        'isRead': true,
      },
      {
        'id': '3',
        'title': 'Bank Account Added',
        'message': 'Your SBI account has been successfully linked',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'type': 'account_linked',
        'isRead': false,
      },
      {
        'id': '4',
        'title': 'Security Alert',
        'message': 'New device login detected',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'security',
        'isRead': true,
      },
      {
        'id': '5',
        'title': 'Offer Available',
        'message': 'Get 10% cashback on your next transaction',
        'time': DateTime.now().subtract(const Duration(days: 3)),
        'type': 'offer',
        'isRead': false,
      },
    ];

    if (mockNotifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mockNotifications.length,
      itemBuilder: (context, index) {
        final notification = mockNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final bool isRead = notification['isRead'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _markAsRead(notification['id']),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isRead
                ? Colors.white
                : const Color(0xFF667eea).withValues(alpha: 0.05),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _getNotificationColor(
                    notification['type'],
                  ).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification['type']),
                  color: _getNotificationColor(notification['type']),
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isRead
                                  ? FontWeight.w500
                                  : FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF667eea),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTime(notification['time']),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),

              // More Options
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      _markAsRead(notification['id']);
                      break;
                    case 'delete':
                      _deleteNotification(notification['id']);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_read',
                    child: Row(
                      children: [
                        Icon(
                          isRead
                              ? Icons.mark_email_unread
                              : Icons.mark_email_read,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(isRead ? 'Mark as unread' : 'Mark as read'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: Icon(Icons.more_vert, color: Colors.grey[400], size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'payment_received':
        return Icons.arrow_downward;
      case 'payment_sent':
        return Icons.arrow_upward;
      case 'account_linked':
        return Icons.account_balance;
      case 'security':
        return Icons.security;
      case 'offer':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'payment_received':
        return Colors.green;
      case 'payment_sent':
        return Colors.blue;
      case 'account_linked':
        return const Color(0xFF667eea);
      case 'security':
        return Colors.orange;
      case 'offer':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  void _markAsRead(String notificationId) {
    setState(() {
      // In a real app, this would update the notification status in the database
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification $notificationId marked as read')),
    );
  }

  void _markAllAsRead() {
    setState(() {
      // In a real app, this would update all notification statuses in the database
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      // In a real app, this would delete the notification from the database
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification $notificationId deleted')),
    );
  }
}
