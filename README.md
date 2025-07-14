# Flutter UPI Pay App 💳

<img src="https://github.com/user-attachments/assets/f8a1a490-9177-44e3-8abe-2e01793125d4" width="200" />
<img src="https://github.com/user-attachments/assets/f8a1a490-9177-44e3-8abe-2e01793125d4" width="200" />



A complete Flutter UPI payment application with Firebase integration, QR code scanning, and modern Material Design 3 UI.

## 🌐 **Live Demo**
**🔗 Try the app now**: [https://upi-pay-app.web.app](https://upi-pay-app.web.app)

*The app is deployed on Firebase Hosting and ready to use!*

## 🚀 Features

- **Firebase Authentication** - Phone number OTP verification
- **QR Code Scanner** - Scan QR codes for payments
- **User Profile Management** - Complete profile setup and management
- **Transaction History** - Track all payment transactions
- **Bank Account Management** - Add and manage multiple bank accounts
- **Request Money** - Send payment requests to contacts
- **Modern UI** - Material Design 3 with enhanced user experience
- **Multi-platform** - Android, iOS, Web, Windows, macOS, Linux support

## 📱 Screenshots

*Screenshots will be added here*

## 🛠️ Installation

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase project setup
- Android Studio / VS Code
- Git

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/flutter-upi-pay.git
   cd flutter-upi-pay
   ```

2. **Navigate to the Flutter project**
   ```bash
   cd flutter_project
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication with Phone provider
   - Add your `google-services.json` to `android/app/`
   - Update Firebase configuration in `lib/firebase_options.dart`

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Build for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### Web Deployment (Firebase Hosting)
```bash
# Build web version
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting
```

**Live URL**: https://upi-pay-app.web.app

## 📁 Project Structure

```
flutter_project/
├── lib/
│   ├── models/          # Data models
│   ├── screens/         # UI screens
│   ├── services/        # Business logic
│   ├── widgets/         # Reusable widgets
│   └── main.dart        # App entry point
├── android/             # Android-specific files
├── ios/                 # iOS-specific files
├── web/                 # Web-specific files
└── test/                # Unit tests
```

## 🔧 Configuration

### Firebase Setup
1. Create Firebase project
2. Enable Phone Authentication
3. Add platform configurations
4. Update security rules

### Android Configuration
- Minimum SDK: API 23 (Android 6.0)
- Target SDK: Latest
- Permissions: Internet, Camera, Network State

## 🧪 Testing

Run unit tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## 📚 Documentation

- [Firebase Setup Guide](flutter_project/FIREBASE_SETUP_GUIDE.md)
- [Android Deployment](flutter_project/ANDROID_EMULATOR_DEPLOYMENT.md)
- [Testing Guide](flutter_project/TESTING_GUIDE.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues:
1. Check the [Troubleshooting Guide](flutter_project/AUTHENTICATION_TROUBLESHOOTING.md)
2. Open an issue on GitHub
3. Contact the development team

## 🔄 Version History

- **v1.0.0** - Initial release with core UPI functionality
- **v1.1.0** - Enhanced UI and bug fixes
- **v1.2.0** - Added real device compatibility fixes

---

**Made with ❤️ using Flutter**
