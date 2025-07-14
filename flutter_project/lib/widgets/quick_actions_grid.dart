import 'package:flutter/material.dart';
import '../screens/profile/bank_accounts_screen.dart';
// import '../screens/payments/send_money_screen.dart'; // Temporarily commented out
import '../screens/payments/qr_scanner_screen.dart';
import '../screens/payments/request_money_screen.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionItem(
          context: context,
          icon: Icons.send_rounded,
          label: 'Send Money',
          color: const Color(0xFF4CAF50),
          onTap: () {
            // Temporarily disabled due to UPI service issues
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Send Money feature temporarily disabled'),
                backgroundColor: Colors.orange,
              ),
            );
            /*
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SendMoneyScreen()),
            );
            */
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.request_page_rounded,
          label: 'Request',
          color: const Color(0xFF2196F3),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RequestMoneyScreen(),
              ),
            );
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.qr_code_scanner_rounded,
          label: 'Scan QR',
          color: const Color(0xFF9C27B0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRScannerScreen()),
            );
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.account_balance_rounded,
          label: 'Bank',
          color: const Color(0xFF667eea),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BankAccountsScreen(),
              ),
            );
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.phone_rounded,
          label: 'Mobile Recharge',
          color: const Color(0xFFFF9800),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mobile Recharge - Coming Soon!')),
            );
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.receipt_long_rounded,
          label: 'Bill Pay',
          color: const Color(0xFFE91E63),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Bill Payment - Coming Soon!')),
            );
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.people_rounded,
          label: 'Contacts',
          color: const Color(0xFF00BCD4),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Contacts - Coming Soon!')),
            );
          },
        ),
        _buildActionItem(
          context: context,
          icon: Icons.more_horiz_rounded,
          label: 'More',
          color: const Color(0xFF607D8B),
          onTap: () {
            _showMoreActionsBottomSheet(context);
          },
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreActionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'More Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            // More actions grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMoreActionItem(
                    context: context,
                    icon: Icons.credit_card,
                    label: 'Add Money',
                    color: const Color(0xFF4CAF50),
                  ),
                  _buildMoreActionItem(
                    context: context,
                    icon: Icons.savings,
                    label: 'Savings',
                    color: const Color(0xFF2196F3),
                  ),
                  _buildMoreActionItem(
                    context: context,
                    icon: Icons.local_offer,
                    label: 'Offers',
                    color: const Color(0xFFFF9800),
                  ),
                  _buildMoreActionItem(
                    context: context,
                    icon: Icons.help_outline,
                    label: 'Help',
                    color: const Color(0xFF9C27B0),
                  ),
                  _buildMoreActionItem(
                    context: context,
                    icon: Icons.feedback,
                    label: 'Feedback',
                    color: const Color(0xFFE91E63),
                  ),
                  _buildMoreActionItem(
                    context: context,
                    icon: Icons.share,
                    label: 'Refer & Earn',
                    color: const Color(0xFF00BCD4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$label - Coming Soon!')));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
