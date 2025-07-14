import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_data_service.dart';
import '../../models/user_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserDataService>(
        builder: (context, userDataService, child) {
          final user = userDataService.currentUser;
          final preferences = user?.preferences ?? UserPreferences();

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: const Color(0xFF667eea),
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'Settings',
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
                        colors: [
                          Color(0xFF667eea),
                          Color(0xFF764ba2),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Settings Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Notifications Section
                      _buildSectionHeader('Notifications'),
                      _buildSwitchTile(
                        icon: Icons.notifications_outlined,
                        title: 'Push Notifications',
                        subtitle: 'Receive notifications for transactions',
                        value: preferences.notificationsEnabled,
                        onChanged: (value) {
                          _updatePreferences(
                            userDataService,
                            preferences.copyWith(notificationsEnabled: value),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Security Section
                      _buildSectionHeader('Security'),
                      _buildSwitchTile(
                        icon: Icons.fingerprint,
                        title: 'Biometric Authentication',
                        subtitle: 'Use fingerprint or face unlock',
                        value: preferences.biometricEnabled,
                        onChanged: (value) {
                          _updatePreferences(
                            userDataService,
                            preferences.copyWith(biometricEnabled: value),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: 'Change PIN',
                        subtitle: 'Update your transaction PIN',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Change PIN - Coming Soon!')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.security,
                        title: 'Transaction Limit',
                        subtitle: '₹${preferences.transactionLimit.toStringAsFixed(0)} per transaction',
                        onTap: () => _showTransactionLimitDialog(context, userDataService, preferences),
                      ),

                      const SizedBox(height: 24),

                      // Appearance Section
                      _buildSectionHeader('Appearance'),
                      _buildSwitchTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        value: preferences.darkMode,
                        onChanged: (value) {
                          _updatePreferences(
                            userDataService,
                            preferences.copyWith(darkMode: value),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: _getLanguageName(preferences.language),
                        onTap: () => _showLanguageDialog(context, userDataService, preferences),
                      ),

                      const SizedBox(height: 24),

                      // App Section
                      _buildSectionHeader('App'),
                      _buildSettingsTile(
                        icon: Icons.update,
                        title: 'Check for Updates',
                        subtitle: 'Version 1.0.0',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You are using the latest version!')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.storage,
                        title: 'Clear Cache',
                        subtitle: 'Free up storage space',
                        onTap: () => _showClearCacheDialog(context),
                      ),
                      _buildSettingsTile(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy Policy',
                        subtitle: 'Read our privacy policy',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Privacy Policy - Coming Soon!')),
                          );
                        },
                      ),
                      _buildSettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms of Service',
                        subtitle: 'Read our terms of service',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Terms of Service - Coming Soon!')),
                          );
                        },
                      ),

                      const SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF667eea),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF667eea),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF667eea).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF667eea),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  void _updatePreferences(UserDataService userDataService, UserPreferences newPreferences) {
    userDataService.updateUserPreferences(newPreferences);
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिंदी';
      case 'ta':
        return 'தமிழ்';
      case 'te':
        return 'తెలుగు';
      default:
        return 'English';
    }
  }

  void _showTransactionLimitDialog(BuildContext context, UserDataService userDataService, UserPreferences preferences) {
    final controller = TextEditingController(text: preferences.transactionLimit.toStringAsFixed(0));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transaction Limit'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Maximum amount per transaction',
            prefixText: '₹',
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
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                _updatePreferences(
                  userDataService,
                  preferences.copyWith(transactionLimit: amount),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, UserDataService userDataService, UserPreferences preferences) {
    final languages = {
      'en': 'English',
      'hi': 'हिंदी',
      'ta': 'தமிழ்',
      'te': 'తెలుగు',
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.entries.map((entry) {
            return RadioListTile<String>(
              title: Text(entry.value),
              value: entry.key,
              groupValue: preferences.language,
              onChanged: (value) {
                if (value != null) {
                  _updatePreferences(
                    userDataService,
                    preferences.copyWith(language: value),
                  );
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully!')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

extension UserPreferencesExtension on UserPreferences {
  UserPreferences copyWith({
    bool? notificationsEnabled,
    bool? biometricEnabled,
    String? language,
    String? currency,
    bool? darkMode,
    double? transactionLimit,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      darkMode: darkMode ?? this.darkMode,
      transactionLimit: transactionLimit ?? this.transactionLimit,
    );
  }
}
