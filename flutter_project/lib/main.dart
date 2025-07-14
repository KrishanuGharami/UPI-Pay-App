import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/user_data_service.dart';
// import 'services/upi_payment_service.dart'; // Temporarily commented out
import 'screens/auth/phone_input_screen.dart';
import 'screens/enhanced_main_navigation_screen.dart';
import 'screens/profile/profile_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Run app with basic functionality if Firebase fails
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => UserDataService()),
        // ChangeNotifierProvider(create: (_) => UpiPaymentService()), // Temporarily commented out
      ],
      child: MaterialApp(
        title: 'UPI Pay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF667eea),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, UserDataService>(
      builder: (context, authService, userDataService, child) {
        if (authService.isAuthenticated) {
          // Initialize user data when authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            userDataService.initializeUserData();
          });

          // Check if profile is complete
          if (userDataService.currentUser?.isProfileComplete == false) {
            return const ProfileSetupScreen();
          }

          return const EnhancedMainNavigationScreen();
        } else {
          return const PhoneInputScreen();
        }
      },
    );
  }
}
