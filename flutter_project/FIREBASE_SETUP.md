# Firebase Setup Instructions

This document provides step-by-step instructions to set up Firebase for the UPI Pay Flutter application.

## Prerequisites

1. Flutter SDK installed
2. Android Studio / VS Code with Flutter extensions
3. Google account for Firebase Console access

## Firebase Console Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `upi-pay-app` (or your preferred name)
4. Enable Google Analytics (optional)
5. Click "Create project"

### 2. Enable Authentication

1. In Firebase Console, go to **Authentication** > **Sign-in method**
2. Enable **Phone** authentication
3. Add your phone number for testing (optional)

### 3. Create Firestore Database

1. Go to **Firestore Database**
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location closest to your users
5. Click "Done"

### 4. Enable Firebase Storage

1. Go to **Storage**
2. Click "Get started"
3. Choose "Start in test mode"
4. Select the same location as Firestore
5. Click "Done"

### 5. Enable Cloud Messaging

1. Go to **Cloud Messaging**
2. The service should be automatically enabled

## Flutter App Configuration

### 1. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### 2. Configure Firebase for Flutter

Run the following command in your project root:

```bash
flutterfire configure
```

This will:
- Create `firebase_options.dart` file
- Add platform-specific configuration files
- Update your app's configuration

### 3. Android Configuration

The FlutterFire CLI should automatically:
- Add `google-services.json` to `android/app/`
- Update `android/build.gradle` and `android/app/build.gradle`

If not done automatically, add to `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

And to `android/build.gradle`:

```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

### 4. iOS Configuration (if targeting iOS)

The FlutterFire CLI should automatically:
- Add `GoogleService-Info.plist` to `ios/Runner/`
- Update iOS configuration

## Firestore Security Rules

Update Firestore rules for development (go to Firestore > Rules):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Transactions - users can read/write their own transactions
    match /transactions/{transactionId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.receiverId);
    }
  }
}
```

## Testing Authentication

### 1. Add Test Phone Numbers (Optional)

In Firebase Console > Authentication > Sign-in method > Phone:
- Add test phone numbers with verification codes
- Example: +91 9999999999 with code 123456

### 2. Enable App Check (Production)

For production apps:
1. Go to App Check in Firebase Console
2. Register your app
3. Enable App Check for Authentication, Firestore, and Storage

## Environment Variables (Optional)

Create a `.env` file for sensitive configuration:

```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
```

## Troubleshooting

### Common Issues:

1. **"Firebase project not found"**
   - Ensure `firebase_options.dart` has correct project ID
   - Run `flutterfire configure` again

2. **"Phone authentication not working"**
   - Check if Phone authentication is enabled in Firebase Console
   - Verify SHA-1/SHA-256 fingerprints are added (Android)

3. **"Firestore permission denied"**
   - Check Firestore security rules
   - Ensure user is authenticated

### Getting SHA-1 Fingerprint (Android):

```bash
cd android
./gradlew signingReport
```

Add the SHA-1 and SHA-256 fingerprints to your Firebase project settings.

## Next Steps

After completing Firebase setup:

1. Test phone authentication
2. Verify Firestore data storage
3. Test on physical devices
4. Set up proper security rules for production
5. Configure App Check for production

## Support

For issues:
1. Check Firebase Console logs
2. Review Flutter logs: `flutter logs`
3. Consult Firebase documentation
4. Check FlutterFire documentation
