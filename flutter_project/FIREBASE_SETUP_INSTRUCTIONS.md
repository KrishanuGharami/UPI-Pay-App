# 🔥 Firebase Backend Connection Instructions

## 📋 **Step-by-Step Setup**

### **1. Replace google-services.json**

1. **Download your real `google-services.json`** from Firebase Console
2. **Replace the dummy file** at: `android/app/google-services.json`
3. **Verify the file contains your real project data** (not dummy values)

### **2. Enable Required Firebase Services**

In your Firebase Console, enable these services:

#### **Authentication**
1. Go to **Authentication** → **Sign-in method**
2. **Enable Phone** provider
3. **Add test phone numbers** for development:
   ```
   Phone Number: +91 98765 43210
   Verification Code: 123456
   ```

#### **Firestore Database**
1. Go to **Firestore Database**
2. Click **Create database**
3. **Start in test mode** (for development)
4. Choose your preferred location
5. Click **Done**

#### **Storage**
1. Go to **Storage**
2. Click **Get started**
3. **Start in test mode** (for development)
4. Choose same location as Firestore
5. Click **Done**

### **3. Configure Security Rules**

#### **Firestore Rules** (for development):
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
    
    // Allow authenticated users to create transactions
    match /transactions/{transactionId} {
      allow create: if request.auth != null;
    }
  }
}
```

#### **Storage Rules** (for development):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload their profile images
    match /profile_images/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### **4. Get SHA-1 Fingerprint (for Android)**

Run this command in your project directory:

**Windows:**
```bash
cd android
./gradlew signingReport
```

**Or use keytool:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Copy the SHA-1 fingerprint and add it to your Firebase project:
1. Go to **Project Settings** → **Your apps**
2. Click on your Android app
3. Add the SHA-1 fingerprint

### **5. Test Firebase Connection**

1. **Run the app** with your new Firebase configuration
2. **Click the debug button (🐛)** in the phone input screen
3. **Check Firebase connection status**
4. **Test phone authentication** with test numbers

### **6. Production Setup (Later)**

For production deployment:

1. **Update Firestore Rules** to be more restrictive
2. **Update Storage Rules** for production security
3. **Add production SHA-1** fingerprints
4. **Enable App Check** for additional security
5. **Set up monitoring** and alerts

## 🔧 **Troubleshooting**

### **Common Issues:**

1. **"Network Error"**
   - Check internet connection
   - Verify Firebase project is active

2. **"App not authorized"**
   - Add correct SHA-1 fingerprint
   - Verify package name matches

3. **"Invalid phone number"**
   - Use international format: +91XXXXXXXXXX
   - Try test phone numbers first

4. **"Too many requests"**
   - Use test phone numbers
   - Wait 24 hours for quota reset

## ✅ **Verification Checklist**

- [ ] Downloaded real google-services.json
- [ ] Replaced dummy configuration file
- [ ] Enabled Phone Authentication
- [ ] Created Firestore Database
- [ ] Enabled Storage
- [ ] Added test phone numbers
- [ ] Added SHA-1 fingerprint
- [ ] Tested connection with debug screen
- [ ] Successfully authenticated with test number

## 🎯 **Next Steps**

After completing this setup:
1. Test authentication with real phone numbers
2. Test user profile creation and updates
3. Test transaction creation (mock data)
4. Verify data appears in Firebase Console
5. Test on different devices/networks

Your UPI Pay app will then be fully connected to your Firebase backend!
