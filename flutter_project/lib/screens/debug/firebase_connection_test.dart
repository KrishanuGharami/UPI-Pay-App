import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseConnectionTest extends StatefulWidget {
  const FirebaseConnectionTest({super.key});

  @override
  State<FirebaseConnectionTest> createState() => _FirebaseConnectionTestState();
}

class _FirebaseConnectionTestState extends State<FirebaseConnectionTest> {
  final List<Map<String, dynamic>> _testResults = [];
  bool _isRunning = false;

  void _addResult(String test, bool success, String message) {
    setState(() {
      _testResults.add({
        'test': test,
        'success': success,
        'message': message,
        'timestamp': DateTime.now(),
      });
    });
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isRunning = true;
      _testResults.clear();
    });

    await _testFirebaseCore();
    await _testFirebaseAuth();
    await _testAnonymousAuth();
    await _testFirestore();
    await _testStorage();
    await _testConfiguration();

    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _testFirebaseCore() async {
    try {
      final app = Firebase.app();
      final projectId = app.options.projectId;
      final apiKey = app.options.apiKey;

      if (projectId == 'your-project-id' ||
          apiKey.contains('Dummy') ||
          apiKey.contains('your-')) {
        _addResult(
          'Firebase Core',
          false,
          'Still using dummy configuration! Please replace firebase_options.dart',
        );
      } else if (projectId == 'upi-pay-app') {
        _addResult('Firebase Core', true, 'Connected to project: $projectId ✅');
      } else {
        _addResult('Firebase Core', true, 'Connected to project: $projectId');
      }
    } catch (e) {
      _addResult('Firebase Core', false, 'Error: $e');
    }
  }

  Future<void> _testFirebaseAuth() async {
    try {
      final auth = FirebaseAuth.instance;

      // Test if we can access auth instance
      final currentUser = auth.currentUser;

      _addResult(
        'Firebase Auth',
        true,
        'Auth service available. Current user: ${currentUser?.uid ?? 'None'}',
      );

      // Test phone auth availability
      try {
        await auth.verifyPhoneNumber(
          phoneNumber: '+1 555 123 4567', // Dummy number for testing
          verificationCompleted: (credential) {},
          verificationFailed: (exception) {
            _addResult(
              'Phone Auth Test',
              exception.code != 'invalid-phone-number',
              'Phone auth response: ${exception.code}',
            );
          },
          codeSent: (verificationId, resendToken) {
            _addResult(
              'Phone Auth Test',
              true,
              'Phone auth is properly configured',
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {},
          timeout: const Duration(seconds: 5),
        );
      } catch (e) {
        _addResult('Phone Auth Test', false, 'Phone auth error: $e');
      }
    } catch (e) {
      _addResult('Firebase Auth', false, 'Error: $e');
    }
  }

  Future<void> _testAnonymousAuth() async {
    try {
      final auth = FirebaseAuth.instance;

      // Check if user is already authenticated
      if (auth.currentUser != null) {
        _addResult(
          'User Authentication',
          true,
          'User already authenticated: ${auth.currentUser!.uid}',
        );
        return;
      }

      // Try anonymous authentication for testing
      try {
        final userCredential = await auth.signInAnonymously();
        _addResult(
          'Anonymous Auth',
          true,
          'Anonymous authentication successful: ${userCredential.user?.uid}',
        );

        // Update authentication status
        _addResult(
          'User Authentication',
          true,
          'User authenticated for testing: ${userCredential.user?.uid}',
        );
      } catch (e) {
        if (e.toString().contains('operation-not-allowed')) {
          _addResult(
            'Anonymous Auth',
            false,
            'Anonymous auth disabled - Enable in Firebase Console',
          );
        } else {
          _addResult(
            'Anonymous Auth',
            false,
            'Anonymous auth error: ${e.toString().substring(0, 100)}...',
          );
        }

        _addResult(
          'User Authentication',
          false,
          'No authenticated user - authenticated tests will fail',
        );
      }
    } catch (e) {
      _addResult('Anonymous Auth', false, 'Service error: $e');
    }
  }

  Future<void> _authenticateForTesting() async {
    try {
      final auth = FirebaseAuth.instance;
      final messenger = ScaffoldMessenger.of(context);

      // Check if already authenticated
      if (auth.currentUser != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Already authenticated: ${auth.currentUser!.uid}'),
            backgroundColor: Colors.green,
          ),
        );
        return;
      }

      // Show loading
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Authenticating anonymously...'),
          duration: Duration(seconds: 2),
        ),
      );

      // Sign in anonymously
      final userCredential = await auth.signInAnonymously();

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Authenticated successfully: ${userCredential.user?.uid}',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the page state
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testFirestore() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Test basic Firestore service availability
      _addResult(
        'Firestore Service',
        true,
        'Firestore instance created successfully',
      );

      // Test connection with better error handling
      try {
        await firestore.collection('public_test').limit(1).get();
        _addResult(
          'Firestore Connection',
          true,
          'Database connection successful',
        );
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          _addResult(
            'Firestore Connection',
            false,
            'Permission denied - Need to set up security rules in Firebase Console',
          );
        } else if (e.toString().contains('not-found')) {
          _addResult(
            'Firestore Connection',
            true,
            'Database accessible (collection not found is normal)',
          );
        } else {
          _addResult(
            'Firestore Connection',
            false,
            'Connection error: ${e.toString().substring(0, 100)}...',
          );
        }
      }

      // Test write with better error handling
      try {
        await firestore.collection('public_test').doc('connection_test').set({
          'timestamp': FieldValue.serverTimestamp(),
          'test': true,
          'platform': 'web',
        });
        _addResult('Firestore Write', true, 'Write permissions working');
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          _addResult(
            'Firestore Write',
            false,
            'Permission denied - Set Firestore rules to allow public writes',
          );
        } else {
          _addResult(
            'Firestore Write',
            false,
            'Write error: ${e.toString().substring(0, 100)}...',
          );
        }
      }

      // Test authenticated operations
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        try {
          await firestore
              .collection('user_data')
              .doc(auth.currentUser!.uid)
              .set({
                'timestamp': FieldValue.serverTimestamp(),
                'test': true,
                'userId': auth.currentUser!.uid,
              });
          _addResult(
            'Authenticated Write',
            true,
            'Authenticated write successful',
          );
        } catch (e) {
          _addResult(
            'Authenticated Write',
            false,
            'Auth write failed: ${e.toString().substring(0, 100)}...',
          );
        }
      } else {
        _addResult(
          'Authenticated Write',
          false,
          'No authenticated user - sign in to test',
        );
      }
    } catch (e) {
      _addResult(
        'Firestore',
        false,
        'Service error: ${e.toString().substring(0, 100)}...',
      );
    }
  }

  Future<void> _testStorage() async {
    try {
      final storage = FirebaseStorage.instance;

      // Test basic Storage service availability
      _addResult(
        'Storage Service',
        true,
        'Storage instance created successfully',
      );

      // Test storage reference creation
      try {
        storage.ref().child('test/connection_test.txt');
        _addResult(
          'Storage Reference',
          true,
          'Storage reference created successfully',
        );
      } catch (e) {
        _addResult(
          'Storage Reference',
          false,
          'Reference creation failed: ${e.toString().substring(0, 100)}...',
        );
      }

      // Test storage read access
      try {
        await storage.ref().child('public_test').listAll();
        _addResult('Storage Read', true, 'Storage read access working');
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          _addResult(
            'Storage Read',
            false,
            'Permission denied - Set Storage rules to allow public reads',
          );
        } else if (e.toString().contains('object-not-found')) {
          _addResult(
            'Storage Read',
            true,
            'Storage accessible (folder not found is normal)',
          );
        } else {
          _addResult(
            'Storage Read',
            false,
            'Read error: ${e.toString().substring(0, 100)}...',
          );
        }
      }

      // Test storage write access
      try {
        final testData =
            'Firebase connection test - ${DateTime.now().toIso8601String()}';
        await storage
            .ref()
            .child('public_test/connection_test.txt')
            .putString(testData);
        _addResult('Storage Write', true, 'Storage write access working');
      } catch (e) {
        if (e.toString().contains('permission-denied')) {
          _addResult(
            'Storage Write',
            false,
            'Permission denied - Set Storage rules to allow public writes',
          );
        } else {
          _addResult(
            'Storage Write',
            false,
            'Write error: ${e.toString().substring(0, 100)}...',
          );
        }
      }

      // Test authenticated storage operations
      final auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        try {
          final userData = 'User test data - ${auth.currentUser!.uid}';
          await storage
              .ref()
              .child('user_data/${auth.currentUser!.uid}/test.txt')
              .putString(userData);
          _addResult(
            'Authenticated Storage',
            true,
            'Authenticated storage write successful',
          );
        } catch (e) {
          _addResult(
            'Authenticated Storage',
            false,
            'Auth storage failed: ${e.toString().substring(0, 100)}...',
          );
        }
      } else {
        _addResult(
          'Authenticated Storage',
          false,
          'No authenticated user - sign in to test',
        );
      }
    } catch (e) {
      _addResult(
        'Storage',
        false,
        'Service error: ${e.toString().substring(0, 100)}...',
      );
    }
  }

  Future<void> _testConfiguration() async {
    try {
      final app = Firebase.app();
      final options = app.options;

      // Check if configuration looks valid
      final checks = <String, bool>{
        'Project ID set':
            options.projectId.isNotEmpty &&
            options.projectId != 'your-project-id',
        'API Key set':
            options.apiKey.isNotEmpty && !options.apiKey.contains('Dummy'),
        'App ID set': options.appId.isNotEmpty,
        'Messaging Sender ID set': options.messagingSenderId.isNotEmpty,
      };

      final validChecks = checks.values.where((v) => v).length;
      final totalChecks = checks.length;

      _addResult(
        'Configuration',
        validChecks == totalChecks,
        '$validChecks/$totalChecks configuration items valid',
      );

      // Show detailed configuration status
      checks.forEach((key, value) {
        _addResult(key, value, value ? 'Valid' : 'Invalid or missing');
      });
    } catch (e) {
      _addResult('Configuration', false, 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connection Test'),
        backgroundColor: const Color(0xFF667eea),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _isRunning ? null : _runAllTests,
            icon: const Icon(Icons.play_arrow),
            tooltip: 'Run Tests',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Summary
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getOverallStatus() == 'success'
                  ? Colors.green.withValues(alpha: 0.1)
                  : _getOverallStatus() == 'error'
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getOverallStatus() == 'success'
                    ? Colors.green
                    : _getOverallStatus() == 'error'
                    ? Colors.red
                    : Colors.orange,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  _getOverallStatus() == 'success'
                      ? Icons.check_circle
                      : _getOverallStatus() == 'error'
                      ? Icons.error
                      : Icons.info,
                  size: 48,
                  color: _getOverallStatus() == 'success'
                      ? Colors.green
                      : _getOverallStatus() == 'error'
                      ? Colors.red
                      : Colors.orange,
                ),
                const SizedBox(height: 8),
                Text(
                  _getStatusMessage(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_testResults.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${_testResults.where((r) => r['success']).length}/${_testResults.length} tests passed',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ],
            ),
          ),

          // Action Buttons
          if (_testResults.isEmpty && !_isRunning)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _runAllTests,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Run Firebase Tests'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _authenticateForTesting,
                      icon: const Icon(Icons.person_add),
                      label: const Text('Authenticate for Testing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Loading Indicator
          if (_isRunning)
            const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),

          // Test Results
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _testResults.length,
              itemBuilder: (context, index) {
                final result = _testResults[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      result['success'] ? Icons.check_circle : Icons.error,
                      color: result['success'] ? Colors.green : Colors.red,
                    ),
                    title: Text(
                      result['test'],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(result['message']),
                    trailing: Text(
                      '${result['timestamp'].hour}:${result['timestamp'].minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getOverallStatus() {
    if (_testResults.isEmpty) return 'pending';

    final hasErrors = _testResults.any((r) => !r['success']);
    final hasConfigIssues = _testResults.any(
      (r) => r['test'] == 'Firebase Core' && !r['success'],
    );

    if (hasConfigIssues) return 'error';
    if (hasErrors) return 'warning';
    return 'success';
  }

  String _getStatusMessage() {
    switch (_getOverallStatus()) {
      case 'success':
        return 'Firebase Fully Connected!';
      case 'error':
        return 'Configuration Issues Detected';
      case 'warning':
        return 'Partial Connection';
      default:
        return 'Ready to Test Firebase Connection';
    }
  }
}
