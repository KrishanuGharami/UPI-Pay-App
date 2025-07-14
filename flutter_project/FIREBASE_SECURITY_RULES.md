# 🔐 Firebase Security Rules - Copy & Paste Ready

## 🚨 **URGENT: Set These Rules in Firebase Console**

To fix Firestore and Storage access issues, copy these rules to your Firebase Console.

---

## 🗄️ **Firestore Security Rules**

### **Go to Firebase Console:**
1. Open: https://console.firebase.google.com/project/upi-pay-app/firestore/rules
2. **Replace all existing rules** with this:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Public test collections (for connection testing)
    match /public_test/{document=**} {
      allow read, write: if true;
    }
    
    // User data - authenticated users only
    match /user_data/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Transactions - users can access their own transactions
    match /transactions/{transactionId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.receiverId);
      allow create: if request.auth != null;
    }
    
    // Contacts - users can access their own contacts
    match /contacts/{contactId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
    
    // Allow all authenticated users to read/write (for development)
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. **Click "Publish"**

---

## 📦 **Storage Security Rules**

### **Go to Firebase Console:**
1. Open: https://console.firebase.google.com/project/upi-pay-app/storage/rules
2. **Replace all existing rules** with this:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Public test folder (for connection testing)
    match /public_test/{allPaths=**} {
      allow read, write: if true;
    }
    
    // User data - authenticated users can access their own files
    match /user_data/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Profile images
    match /profile_images/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Transaction receipts
    match /receipts/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Allow all authenticated users (for development)
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

3. **Click "Publish"**

---

## ✅ **Quick Setup Checklist**

### **Step 1: Enable Authentication Services**
- [ ] Go to: https://console.firebase.google.com/project/upi-pay-app/authentication/providers
- [ ] **Enable Phone** authentication
- [ ] **Enable Anonymous** authentication (for testing)
- [ ] **Add test numbers**: `+91 98765 43210` → `123456`

### **Step 2: Create Firestore Database**
- [ ] Go to: https://console.firebase.google.com/project/upi-pay-app/firestore
- [ ] **Create database** in test mode
- [ ] **Set the Firestore rules** (copy from above)

### **Step 3: Enable Storage**
- [ ] Go to: https://console.firebase.google.com/project/upi-pay-app/storage
- [ ] **Create storage bucket**
- [ ] **Set the Storage rules** (copy from above)

---

## 🧪 **Test After Setup**

1. **Refresh your browser** (Ctrl+F5)
2. **Go to Firebase Connection Test**
3. **Click "Run Tests"**
4. **Expected Results**:
   - ✅ Firestore Service: Available
   - ✅ Firestore Connection: Successful
   - ✅ Firestore Write: Working
   - ✅ Storage Service: Available
   - ✅ Storage Reference: Created
   - ✅ Storage Read: Working
   - ✅ Storage Write: Working

---

## 🔧 **Troubleshooting**

### **If you still get permission errors:**

1. **Wait 1-2 minutes** after setting rules (propagation delay)
2. **Hard refresh browser** (Ctrl+Shift+R)
3. **Check rules are published** in Firebase Console
4. **Verify project ID** matches: `upi-pay-app`

### **Common Issues:**

#### **"Permission denied" for Firestore**
- Ensure Firestore rules include the `public_test` section
- Check rules are published (green checkmark)

#### **"Permission denied" for Storage**
- Ensure Storage rules include the `public_test` section
- Verify storage bucket is created

#### **"Service not enabled"**
- Enable Firestore Database in Firebase Console
- Enable Storage in Firebase Console

---

## 🎯 **Production Notes**

**⚠️ These rules are for DEVELOPMENT/TESTING only!**

For production, remove these sections:
```javascript
// Remove this in production:
match /public_test/{document=**} {
  allow read, write: if true;
}
```

Replace with proper authentication and validation rules.

---

## 🚀 **Quick Links**

- **Firestore Rules**: https://console.firebase.google.com/project/upi-pay-app/firestore/rules
- **Storage Rules**: https://console.firebase.google.com/project/upi-pay-app/storage/rules  
- **Authentication**: https://console.firebase.google.com/project/upi-pay-app/authentication/providers
- **Project Overview**: https://console.firebase.google.com/project/upi-pay-app/overview

**After setting these rules, your Firebase Connection Test should pass all checks!** ✅
