# 🔥 Firebase OTP Authentication Setup Guide

## 🚨 **Current Issue: Using Dummy Firebase Configuration**

Your app is currently using placeholder Firebase configuration, which is why OTP is not being sent. Here's how to fix it:

---

## 📋 **Step 1: Create Real Firebase Project**

### **1.1 Go to Firebase Console**
- Open: https://console.firebase.google.com/
- Sign in with your Google account

### **1.2 Create New Project**
1. Click **"Create a project"**
2. **Project name**: `upi-pay-app` (or your choice)
3. **Enable Google Analytics**: Yes (recommended)
4. **Choose Analytics account**: Default or create new
5. Click **"Create project"**
6. Wait for project creation (1-2 minutes)

---

## 📱 **Step 2: Add Android App**

### **2.1 Add Android App to Firebase**
1. In your Firebase project, click **"Add app"**
2. Select **Android** icon
3. Fill in the details:
   - **Android package name**: `com.example.flutter_project`
   - **App nickname**: `UPI Pay Android`
   - **Debug signing certificate SHA-1**: (leave blank for now)
4. Click **"Register app"**

### **2.2 Download Configuration File**
1. **Download** the `google-services.json` file
2. **IMPORTANT**: This file contains your real Firebase configuration
3. **Don't close the browser tab yet!**

---

## 🔧 **Step 3: Replace Configuration File**

### **3.1 Replace the Dummy File**
1. **Navigate to**: `android/app/` in your project
2. **Replace** the existing `google-services.json` with your downloaded file
3. **Verify** the new file contains real data (not dummy values)

### **3.2 Verify Configuration**
Your new file should look like this:
```json
{
  "project_info": {
    "project_id": "your-real-project-id",  // ✅ Real project ID
    "project_number": "123456789012",      // ✅ Real project number
    "storage_bucket": "your-real-project-id.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:real-app-id",  // ✅ Real app ID
        "android_client_info": {
          "package_name": "com.example.flutter_project"
        }
      },
      "api_key": [
        {
          "current_key": "AIzaSyReal-API-Key-Here"  // ✅ Real API key
        }
      ]
    }
  ]
}
```

---

## 🔐 **Step 4: Enable Phone Authentication**

### **4.1 Enable Phone Provider**
1. In Firebase Console, go to **Authentication**
2. Click **"Get started"** (if first time)
3. Go to **"Sign-in method"** tab
4. Find **"Phone"** provider
5. Click **"Phone"** to configure
6. **Enable** the Phone provider
7. Click **"Save"**

### **4.2 Add Test Phone Numbers (for Development)**
1. In the Phone provider settings
2. Scroll down to **"Phone numbers for testing"**
3. Click **"Add phone number"**
4. Add these test numbers:
   ```
   Phone Number: +91 98765 43210
   Verification Code: 123456
   
   Phone Number: +1 555 123 4567
   Verification Code: 654321
   ```
5. Click **"Save"**

---

## 🗄️ **Step 5: Set Up Firestore Database**

### **5.1 Create Database**
1. Go to **Firestore Database**
2. Click **"Create database"**
3. **Start in test mode** (for development)
4. Choose your **location** (closest to your users)
5. Click **"Done"**

### **5.2 Configure Security Rules**
1. Go to **"Rules"** tab in Firestore
2. Replace the rules with:
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
      allow create: if request.auth != null;
    }
  }
}
```
3. Click **"Publish"**

---

## 🧪 **Step 6: Test the Connection**

### **6.1 Rebuild the App**
```bash
flutter clean
flutter pub get
flutter build web
```

### **6.2 Test Firebase Connection**
1. **Run the app**: `flutter run -d edge`
2. **Click the debug button (🐛)** on the phone input screen
3. **Click "Run Full Connection Test"**
4. **Verify all tests pass**:
   - ✅ Firebase Core: Connected to your real project
   - ✅ Firebase Auth: Service available
   - ✅ Phone Auth Test: Properly configured
   - ✅ Firestore: Database connection successful

### **6.3 Test Phone Authentication**
1. **Use test phone number**: `+91 98765 43210`
2. **Click "Send OTP"**
3. **Enter verification code**: `123456`
4. **Should authenticate successfully**

---

## 📱 **Step 7: Test with Real Phone Numbers**

### **7.1 Add SHA-1 Fingerprint (for Android)**
1. **Get your SHA-1 fingerprint**:
   ```bash
   cd android
   ./gradlew signingReport
   ```
2. **Copy the SHA-1 fingerprint**
3. **In Firebase Console**: Project Settings → Your apps
4. **Add the SHA-1 fingerprint**
5. **Save**

### **7.2 Test Real Phone Authentication**
1. **Enter your real phone number**: `+91 XXXXXXXXXX`
2. **Click "Send OTP"**
3. **Wait for SMS** (should arrive in 1-2 minutes)
4. **Enter the received code**
5. **Should authenticate successfully**

---

## 🔍 **Troubleshooting**

### **Common Issues:**

#### **"Still using dummy configuration"**
- Ensure you replaced the `google-services.json` file
- Restart the app after replacing the file
- Check the file contains real project data

#### **"Network request failed"**
- Check internet connection
- Verify Firebase project is active
- Try different network (WiFi vs mobile data)

#### **"App not authorized"**
- Add SHA-1 fingerprint to Firebase project
- Verify package name matches exactly
- Wait a few minutes after adding fingerprint

#### **"Too many requests"**
- Use test phone numbers for development
- Wait 24 hours for quota reset
- Create new Firebase project if needed

#### **"Invalid phone number"**
- Use international format: `+91XXXXXXXXXX`
- Ensure no spaces or special characters
- Try test phone numbers first

---

## ✅ **Verification Checklist**

After completing setup:

- [ ] Created real Firebase project
- [ ] Downloaded real `google-services.json`
- [ ] Replaced dummy configuration file
- [ ] Enabled Phone Authentication in Firebase
- [ ] Added test phone numbers
- [ ] Created Firestore database
- [ ] Set up security rules
- [ ] Rebuilt the app
- [ ] Tested Firebase connection (all green)
- [ ] Tested authentication with test number
- [ ] Added SHA-1 fingerprint
- [ ] Tested with real phone number

---

## 🎯 **Expected Results**

After proper setup:

### **✅ With Test Phone Number:**
1. Enter: `+91 98765 43210`
2. Click "Send OTP"
3. Debug logs show: "✅ Code sent successfully!"
4. Enter: `123456`
5. Authentication succeeds
6. User appears in Firebase Console → Authentication → Users

### **✅ With Real Phone Number:**
1. Enter: `+91 XXXXXXXXXX` (your number)
2. Click "Send OTP"
3. Receive SMS with 6-digit code
4. Enter received code
5. Authentication succeeds
6. User data saved to Firestore

---

## 🚀 **Next Steps**

Once OTP authentication works:
1. Test user profile creation
2. Test transaction creation (mock)
3. Verify data appears in Firebase Console
4. Set up production security rules
5. Deploy to production

Your UPI Pay app will then have fully functional OTP authentication! 🎉
