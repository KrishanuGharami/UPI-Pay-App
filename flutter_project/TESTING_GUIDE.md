# Authentication Testing Guide

This guide will help you test the OTP-based authentication system we've built.

## Prerequisites for Testing

### 1. Enable Windows Developer Mode (Required for Android Emulator)
```bash
# Run this command to open Developer Settings
start ms-settings:developers
```
Then toggle "Developer Mode" to ON.

### 2. Firebase Project Setup (Required for Real Testing)
Follow the `FIREBASE_SETUP.md` guide to:
- Create a Firebase project
- Enable Phone Authentication
- Run `flutterfire configure`
- Replace the placeholder `google-services.json` with the real one

## Testing Options

### Option 1: Web Testing (Easiest - No Developer Mode Required)
```bash
flutter run -d edge
```
**Note**: Phone authentication on web requires additional setup and may have limitations.

### Option 2: Android Emulator Testing (Recommended)
```bash
# After enabling Developer Mode
flutter run -d emulator-5554
```

### Option 3: Physical Device Testing (Best for Phone Auth)
```bash
# Connect your Android device via USB with USB Debugging enabled
flutter run
```

## What to Test

### 1. Phone Input Screen
- ✅ **UI Elements**:
  - Gradient background displays correctly
  - UPI Pay logo and title visible
  - International phone field with country picker
  - "Send OTP" button with loading state

- ✅ **Functionality**:
  - Country picker works (default: India +91)
  - Phone number validation (minimum 10 digits)
  - Loading indicator shows when sending OTP
  - Error messages display for invalid input

### 2. OTP Verification Screen
- ✅ **UI Elements**:
  - Back button navigation
  - 6-digit PIN input fields
  - "Verify OTP" button
  - "Resend OTP" option

- ✅ **Functionality**:
  - Auto-focus on PIN input
  - Auto-submit when 6 digits entered
  - Resend OTP functionality
  - Loading states and error handling

### 3. Home Screen (After Authentication)
- ✅ **UI Elements**:
  - User profile section with phone number
  - Balance card (shows ₹0.00)
  - Quick action buttons (Send, Request, Scan, History)
  - Sign out functionality

- ✅ **Functionality**:
  - User data loads from Firestore
  - Quick action buttons show "Coming Soon" messages
  - Sign out returns to phone input screen

## Testing Scenarios

### Scenario 1: Valid Phone Number Flow
1. Enter a valid phone number (e.g., +91 9876543210)
2. Tap "Send OTP"
3. Should navigate to OTP screen
4. **Expected**: Loading indicator, then navigation to OTP screen

### Scenario 2: Invalid Phone Number
1. Enter invalid number (e.g., 123)
2. Tap "Send OTP"
3. **Expected**: Validation error message

### Scenario 3: OTP Verification (With Firebase)
1. Complete phone number entry
2. Enter received OTP
3. **Expected**: Navigation to home screen, user data created in Firestore

### Scenario 4: OTP Verification (Without Firebase)
1. Complete phone number entry
2. Enter any 6-digit code
3. **Expected**: Error message (Firebase not configured)

## Mock Testing (Without Firebase)

If you want to test the UI flow without Firebase setup, you can temporarily modify the `AuthService`:

```dart
// In lib/services/auth_service.dart, temporarily replace sendOTP method:
Future<bool> sendOTP(String phoneNumber) async {
  _setLoading(true);
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));
  _verificationId = "mock_verification_id";
  _setLoading(false);
  return true; // Always return success for testing
}

// And replace verifyOTP method:
Future<bool> verifyOTP(String otp) async {
  _setLoading(true);
  await Future.delayed(Duration(seconds: 1));
  
  if (otp == "123456") { // Accept test OTP
    _setLoading(false);
    return true;
  } else {
    _setError("Invalid OTP. Use 123456 for testing.");
    _setLoading(false);
    return false;
  }
}
```

## Expected Behavior

### ✅ Successful Flow:
1. **Phone Input** → Loading → **OTP Screen**
2. **OTP Input** → Loading → **Home Screen**
3. **Home Screen** → Shows user data and quick actions
4. **Sign Out** → Returns to **Phone Input**

### ❌ Error Scenarios:
- Invalid phone: Shows validation error
- Network error: Shows error message with retry option
- Invalid OTP: Shows error, clears input, allows retry
- Firebase not configured: Shows connection error

## Troubleshooting

### Build Issues:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Firebase Issues:
- Check `firebase_options.dart` has correct project ID
- Verify `google-services.json` is in `android/app/`
- Ensure Phone Auth is enabled in Firebase Console

### Developer Mode Issues:
- Enable Developer Mode in Windows Settings
- Restart Android Studio/VS Code after enabling
- Try web version if Android emulator fails

## Next Steps After Testing

Once authentication is working:
1. ✅ Test user data storage in Firestore
2. ✅ Verify profile creation and updates
3. ✅ Test sign out and re-authentication
4. 🔄 Move to next development phase (User Data Management)

## Test Results Checklist

- [ ] Phone input screen loads correctly
- [ ] Country picker works
- [ ] Phone validation works
- [ ] OTP screen navigation works
- [ ] OTP input and validation works
- [ ] Home screen loads after authentication
- [ ] User data displays correctly
- [ ] Sign out functionality works
- [ ] Error handling works properly
- [ ] Loading states display correctly
