import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

class FirebaseSetupHelper extends StatefulWidget {
  const FirebaseSetupHelper({super.key});

  @override
  State<FirebaseSetupHelper> createState() => _FirebaseSetupHelperState();
}

class _FirebaseSetupHelperState extends State<FirebaseSetupHelper> {
  Map<String, dynamic> _configStatus = {};

  @override
  void initState() {
    super.initState();
    _checkConfiguration();
  }

  void _checkConfiguration() {
    try {
      final app = Firebase.app();
      final options = app.options;
      
      setState(() {
        _configStatus = {
          'projectId': options.projectId,
          'apiKey': options.apiKey,
          'appId': options.appId,
          'messagingSenderId': options.messagingSenderId,
          'isDummy': _isDummyConfig(options),
        };
      });
    } catch (e) {
      setState(() {
        _configStatus = {'error': e.toString()};
      });
    }
  }

  bool _isDummyConfig(FirebaseOptions options) {
    return options.projectId == 'your-project-id' ||
           options.apiKey.contains('Dummy') ||
           options.projectId.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Setup Helper'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Configuration Status
            _buildConfigurationStatus(),
            
            const SizedBox(height: 24),
            
            // Setup Steps
            _buildSetupSteps(),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationStatus() {
    final isDummy = _configStatus['isDummy'] ?? true;
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDummy 
              ? Colors.red.withValues(alpha: 0.1)
              : Colors.green.withValues(alpha: 0.1),
        ),
        child: Column(
          children: [
            Icon(
              isDummy ? Icons.error : Icons.check_circle,
              size: 48,
              color: isDummy ? Colors.red : Colors.green,
            ),
            const SizedBox(height: 12),
            Text(
              isDummy 
                  ? 'Using Dummy Configuration'
                  : 'Real Firebase Configuration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDummy ? Colors.red : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDummy
                  ? 'OTP will not work with dummy configuration'
                  : 'Firebase is properly configured',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            
            if (_configStatus.isNotEmpty && !_configStatus.containsKey('error')) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              _buildConfigDetail('Project ID', _configStatus['projectId']),
              _buildConfigDetail('API Key', _maskApiKey(_configStatus['apiKey'])),
              _buildConfigDetail('App ID', _configStatus['appId']),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _maskApiKey(String apiKey) {
    if (apiKey.length > 10) {
      return '${apiKey.substring(0, 10)}...';
    }
    return apiKey;
  }

  Widget _buildSetupSteps() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Setup Steps',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildStep(
              1,
              'Create Firebase Project',
              'Go to console.firebase.google.com',
              Icons.cloud,
              Colors.blue,
            ),
            
            _buildStep(
              2,
              'Add Android App',
              'Package: com.example.flutter_project',
              Icons.android,
              Colors.green,
            ),
            
            _buildStep(
              3,
              'Download google-services.json',
              'Replace the dummy file in android/app/',
              Icons.download,
              Colors.orange,
            ),
            
            _buildStep(
              4,
              'Enable Phone Authentication',
              'Authentication → Sign-in method → Phone',
              Icons.phone,
              Colors.purple,
            ),
            
            _buildStep(
              5,
              'Add Test Phone Numbers',
              '+91 98765 43210 → 123456',
              Icons.numbers,
              Colors.teal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, color: color, size: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(
                    text: 'https://console.firebase.google.com/',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Firebase Console URL copied to clipboard'),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Firebase Console URL'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF667eea),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(const ClipboardData(
                    text: 'com.example.flutter_project',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Package name copied to clipboard'),
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Package Name'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _checkConfiguration,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh Configuration'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
