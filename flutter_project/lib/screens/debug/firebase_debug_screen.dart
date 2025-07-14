import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_connection_test.dart';
import 'firebase_setup_helper.dart';

class FirebaseDebugScreen extends StatefulWidget {
  const FirebaseDebugScreen({super.key});

  @override
  State<FirebaseDebugScreen> createState() => _FirebaseDebugScreenState();
}

class _FirebaseDebugScreenState extends State<FirebaseDebugScreen> {
  final List<String> _debugLogs = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  void _addLog(String message) {
    setState(() {
      _debugLogs.insert(
        0,
        '${DateTime.now().toString().substring(11, 19)}: $message',
      );
    });
  }

  Future<void> _checkFirebaseConnection() async {
    try {
      _addLog('🔍 Checking Firebase connection...');

      // Check Firebase initialization
      final app = Firebase.app();
      _addLog('✅ Firebase app initialized: ${app.name}');
      _addLog('📱 Project ID: ${app.options.projectId}');
      _addLog('🔑 API Key: ${app.options.apiKey.substring(0, 10)}...');

      // Check Auth connection
      final auth = FirebaseAuth.instance;
      _addLog('🔐 Firebase Auth instance created');
      _addLog('👤 Current user: ${auth.currentUser?.uid ?? 'None'}');

      // Check Firestore connection
      final firestore = FirebaseFirestore.instance;
      _addLog('🗄️ Firestore instance created');

      // Test Firestore connection
      await firestore.collection('test').limit(1).get();
      _addLog('✅ Firestore connection successful');

      setState(() {
        _isConnected = true;
      });

      _addLog('🎉 All Firebase services connected successfully!');
    } catch (e) {
      _addLog('❌ Firebase connection failed: $e');
      setState(() {
        _isConnected = false;
      });
    }
  }

  Future<void> _testPhoneAuth() async {
    try {
      _addLog('📞 Testing phone authentication...');

      const testPhone = '+91 98765 43210'; // Test phone number
      _addLog('📱 Using test phone: $testPhone');

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: testPhone,
        verificationCompleted: (PhoneAuthCredential credential) {
          _addLog('✅ Auto-verification completed');
        },
        verificationFailed: (FirebaseAuthException e) {
          _addLog('❌ Verification failed: ${e.code} - ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _addLog(
            '✅ Code sent successfully! Verification ID: ${verificationId.substring(0, 10)}...',
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _addLog('⏰ Code auto-retrieval timeout');
        },
        timeout: const Duration(seconds: 30),
      );
    } catch (e) {
      _addLog('❌ Phone auth test failed: $e');
    }
  }

  void _clearLogs() {
    setState(() {
      _debugLogs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Debug'),
        backgroundColor: _isConnected ? Colors.green : Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _clearLogs,
            icon: const Icon(Icons.clear),
            tooltip: 'Clear logs',
          ),
          IconButton(
            onPressed: _checkFirebaseConnection,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isConnected
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isConnected ? Colors.green : Colors.red,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _isConnected ? Icons.check_circle : Icons.error,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  _isConnected
                      ? 'Firebase Connected'
                      : 'Firebase Connection Failed',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isConnected ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isConnected
                      ? 'All Firebase services are working correctly'
                      : 'Check your Firebase configuration',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isConnected ? Colors.green[700] : Colors.red[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _testPhoneAuth,
                        icon: const Icon(Icons.phone),
                        label: const Text('Test Phone Auth'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF667eea),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _checkFirebaseConnection,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh Status'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FirebaseSetupHelper(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Setup Guide'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const FirebaseConnectionTest(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.science),
                        label: const Text('Full Test'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Debug Logs
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Debug Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _debugLogs.isEmpty
                        ? const Center(
                            child: Text(
                              'No logs yet. Click "Refresh Status" to start debugging.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: _debugLogs.length,
                            itemBuilder: (context, index) {
                              final log = _debugLogs[index];
                              Color textColor = Colors.white;

                              if (log.contains('❌')) {
                                textColor = Colors.red[300]!;
                              } else if (log.contains('✅')) {
                                textColor = Colors.green[300]!;
                              } else if (log.contains('⚠️')) {
                                textColor = Colors.orange[300]!;
                              } else if (log.contains('🔍') ||
                                  log.contains('📞')) {
                                textColor = Colors.blue[300]!;
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
