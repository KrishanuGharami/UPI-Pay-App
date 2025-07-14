import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home/enhanced_home_screen.dart';
import 'transactions/transaction_history_screen.dart';
import 'profile/profile_screen.dart';
import 'settings/settings_screen.dart';
import 'main/main_navigation_screen.dart';

class EnhancedMainNavigationScreen extends StatefulWidget {
  const EnhancedMainNavigationScreen({super.key});

  @override
  State<EnhancedMainNavigationScreen> createState() =>
      _EnhancedMainNavigationScreenState();
}

class _EnhancedMainNavigationScreenState
    extends State<EnhancedMainNavigationScreen> {
  int _currentIndex = 0;
  bool _isEnhancedMode = true;
  bool _showWelcomeMessage = true;

  final List<Widget> _screens = [
    const EnhancedHomeScreen(),
    const TransactionHistoryScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    const BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'Transactions',
    ),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Show welcome message after a short delay
    if (_showWelcomeMessage) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          _showEnhancedModeWelcome();
        }
      });
    }
  }

  void _showEnhancedModeWelcome() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Welcome to Enhanced Mode! Enjoy premium features and improved experience.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    setState(() {
      _showWelcomeMessage = false;
    });
  }

  void _toggleMode() {
    setState(() {
      _isEnhancedMode = !_isEnhancedMode;
    });

    if (!_isEnhancedMode) {
      // Navigate to classic mode
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('UPI Pay'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Enhanced',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'toggle_mode':
                  _toggleMode();
                  break;
                case 'logout':
                  _logout();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'toggle_mode',
                child: Row(
                  children: [
                    Icon(Icons.swap_horiz, color: Colors.blue),
                    SizedBox(width: 8),
                    Text('Switch to Classic Mode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF667eea),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 0,
          items: _navItems,
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Quick send money action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quick Send - Enhanced Feature!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              backgroundColor: const Color(0xFF667eea),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.send),
              label: const Text('Quick Send'),
            )
          : null,
    );
  }

  void _logout() async {
    try {
      await context.read<AuthService>().signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/phone-input',
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
