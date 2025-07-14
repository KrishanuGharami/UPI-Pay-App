# 🔐 Firebase Security Rules Setup

## 🚨 **Critical: Set Up Firebase Services**

To fix the Firebase Connection Test issues, you need to enable services in your Firebase Console.

---

## 📋 **Step 1: Enable Authentication**

### **1.1 Go to Firebase Console**
- Open: https://console.firebase.google.com/
- Select your project: **upi-pay-app**

### **1.2 Enable Phone Authentication**
1. Go to **Authentication** → **Sign-in method**
2. Click **Phone** provider
3. **Enable** Phone authentication
4. **Add test phone numbers**:
   ```
   Phone Number: +91 98765 43210
   Verification Code: 123456
   
   Phone Number: +1 555 123 4567
   Verification Code: 654321
   ```
5. Click **Save**

---

## 🗄️ **Step 2: Create Firestore Database**

### **2.1 Create Database**
1. Go to **Firestore Database**
2. Click **"Create database"**
3. **Start in test mode** (for development)
4. Choose your **location** (closest to your users)
5. Click **"Done"**

### **2.2 Set Security Rules**
1. Go to **"Rules"** tab in Firestore
2. Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write access on all documents to any user signed in to the application
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Allow anonymous access for testing (remove in production)
    match /test/{document=**} {
      allow read, write: if true;
    }
  }
}
```

3. Click **"Publish"**

---

## 📦 **Step 3: Enable Storage**

### **3.1 Create Storage**
1. Go to **Storage**
2. Click **"Get started"**
3. **Start in test mode**
4. Choose same location as Firestore
5. Click **"Done"**

### **3.2 Set Storage Rules**
1. Go to **"Rules"** tab in Storage
2. Replace the rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Allow access to any authenticated user
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    
    // Allow anonymous access for testing (remove in production)
    match /test/{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

3. Click **"Publish"**

---

## 🌐 **Step 4: Add Web App to Firebase**

### **4.1 Add Web App**
1. In Firebase Console, click **"Add app"** → **Web** icon
2. **App nickname**: `UPI Pay Web`
3. **Enable Firebase Hosting**: No (for now)
4. Click **"Register app"**

### **4.2 Copy Web Configuration**
You'll see a configuration like this:
```javascript
const firebaseConfig = {
  apiKey: "AIzaSyCss337XcRDBpFT5ghd_6ddkz0x1O6HJK8",
  authDomain: "upi-pay-app.firebaseapp.com",
  projectId: "upi-pay-app",
  storageBucket: "upi-pay-app.firebasestorage.app",
  messagingSenderId: "532533031917",
  appId: "1:532533031917:web:YOUR_WEB_APP_ID"
};
```

**Note**: The `appId` for web will be different from Android. Update the `firebase_options.dart` file with the correct web `appId`.

---

## 🔧 **Step 5: Update Web App ID**

If you get a different web app ID, update the `firebase_options.dart` file:

1. **Copy the web `appId`** from Firebase Console
2. **Update** `lib/firebase_options.dart`:
   ```dart
   static const FirebaseOptions web = FirebaseOptions(
     apiKey: 'AIzaSyCss337XcRDBpFT5ghd_6ddkz0x1O6HJK8',
     appId: 'YOUR_ACTUAL_WEB_APP_ID_HERE', // Update this
     messagingSenderId: '532533031917',
     projectId: 'upi-pay-app',
     authDomain: 'upi-pay-app.firebaseapp.com',
     storageBucket: 'upi-pay-app.firebasestorage.app',
   );
   ```

---

## ✅ **Step 6: Test the Connection**

After completing the setup:

1. **Rebuild the web app**:
   ```bash
   flutter build web
   ```

2. **Refresh your browser** (Ctrl+F5)

3. **Run the Firebase Connection Test** again

4. **Expected Results**:
   - ✅ Firebase Core: Connected to upi-pay-app
   - ✅ Firebase Auth: Service available
   - ✅ Phone Auth Test: Properly configured
   - ✅ Firestore: Database connection successful
   - ✅ Storage: Service available
   - ✅ Configuration: All items valid

---

## 🎯 **Quick Checklist**

- [ ] Enabled Phone Authentication in Firebase Console
- [ ] Added test phone numbers (+91 98765 43210 → 123456)
- [ ] Created Firestore Database in test mode
- [ ] Set Firestore security rules (allow authenticated users)
- [ ] Enabled Firebase Storage in test mode
- [ ] Set Storage security rules (allow authenticated users)
- [ ] Added Web app to Firebase project
- [ ] Updated firebase_options.dart with correct web app ID
- [ ] Rebuilt the Flutter web app
- [ ] Refreshed browser and tested connection

---

## 🚨 **Common Issues & Solutions**

### **"Permission denied" errors**
- Check Firestore rules allow authenticated users
- Ensure user is signed in before accessing database

### **"App not found" errors**
- Verify web app is added to Firebase project
- Check web app ID matches in firebase_options.dart

### **"Network request failed"**
- Check internet connection
- Verify Firebase project is active
- Try different browser/incognito mode

### **"Invalid API key"**
- Ensure API key is correct in firebase_options.dart
- Check API key restrictions in Firebase Console

---

## 🎉 **Success Indicators**

When everything is working:
- All Firebase Connection Tests pass ✅
- Phone authentication works with test numbers
- Database reads/writes succeed
- Storage access works
- No console errors in browser

Your UPI Pay app will then have full Firebase backend functionality! 🚀
