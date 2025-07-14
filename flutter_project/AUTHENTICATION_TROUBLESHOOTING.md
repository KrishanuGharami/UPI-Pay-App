# 🔧 Authentication Troubleshooting Guide

## 🚨 **Current Issue: OTP Not Coming & Authentication Failed**

### **Quick Diagnosis Steps**

1. **Open the app and click the debug button (🐛) in the top-right corner**
2. **Check the Firebase Debug Screen for connection status**
3. **Follow the specific fixes below based on the error messages**

---

## 🔍 **Step 1: Check Firebase Configuration**

### **Issue: Dummy Firebase Configuration**
The current `google-services.json` contains placeholder values:
```json
{
  "project_id": "your-project-id",  // ❌ DUMMY
  "api_key": "AIzaSyDummyKeyForTestingPurposes123456789"  // ❌ DUMMY
}
```

### **✅ Solution:**
1. **Create Real Firebase Project**: https://console.firebase.google.com/
2. **Add Android App** with package name: `com.example.flutter_project`
3. **Download REAL google-services.json**
4. **Replace** the dummy file at `android/app/google-services.json`

---

## 🔍 **Step 2: Enable Phone Authentication**

### **Issue: Phone Authentication Not Enabled**

### **✅ Solution:**
1. **Go to Firebase Console** → Your Project
2. **Authentication** → **Sign-in method**
3. **Click "Phone"** provider
4. **Enable** the Phone provider
5. **Click "Save"**

---

## 🔍 **Step 3: Add Test Phone Numbers**

### **Issue: SMS Quota or Real Phone Testing**

### **✅ Solution for Development:**
1. **In Firebase Console** → Authentication → Sign-in method → Phone
2. **Scroll to "Phone numbers for testing"**
3. **Add test numbers:**
   ```
   Phone Number: +91 98765 43210
   Verification Code: 123456
   ```
4. **Use these test numbers** during development

### **✅ Solution for Production:**
1. **Add SHA-1 fingerprint** to Firebase project
2. **Enable reCAPTCHA** verification
3. **Test with real phone numbers**

---

## 🔍 **Step 4: Check Network & Permissions**

### **Common Network Issues:**
- ❌ No internet connection
- ❌ Firewall blocking Firebase
- ❌ Corporate network restrictions

### **✅ Solutions:**
1. **Check internet connection**
2. **Try different network** (mobile data vs WiFi)
3. **Disable VPN** if using one
4. **Check firewall settings**

---

## 🔍 **Step 5: Debug with Enhanced Logging**

### **Use the Debug Screen:**
1. **Open app** → Click 🐛 button
2. **Check connection status**
3. **Click "Test Phone Auth"**
4. **Read debug logs** for specific errors

### **Common Error Messages & Solutions:**

#### **❌ "network-request-failed"**
- **Solution**: Check internet connection
- **Try**: Different network or restart router

#### **❌ "app-not-authorized"**
- **Solution**: Add correct SHA-1 fingerprint to Firebase
- **Get SHA-1**: `keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android`

#### **❌ "too-many-requests"**
- **Solution**: Use test phone numbers or wait 24 hours
- **Alternative**: Create new Firebase project

#### **❌ "invalid-phone-number"**
- **Solution**: Use international format (+91XXXXXXXXXX)
- **Example**: +91 98765 43210

#### **❌ "captcha-check-failed"**
- **Solution**: Enable reCAPTCHA in Firebase Console
- **Alternative**: Use test phone numbers

#### **❌ "quota-exceeded"**
- **Solution**: SMS quota exceeded, wait 24 hours
- **Alternative**: Use test phone numbers

---

## 🔍 **Step 6: Test Authentication Flow**

### **Testing with Test Numbers:**
1. **Enter test phone**: +91 98765 43210
2. **Click "Send OTP"**
3. **Enter test code**: 123456
4. **Should authenticate successfully**

### **Testing with Real Numbers:**
1. **Enter your real phone**: +91 XXXXXXXXXX
2. **Click "Send OTP"**
3. **Wait for SMS** (may take 1-2 minutes)
4. **Enter received code**
5. **Should authenticate successfully**

---

## 🔍 **Step 7: Advanced Debugging**

### **Check Firebase Console Logs:**
1. **Go to Firebase Console** → Your Project
2. **Authentication** → **Users**
3. **Check if users are being created**
4. **Look for error logs**

### **Check Android Logs:**
```bash
flutter logs
```
Look for Firebase-related error messages.

### **Verify Package Name:**
Ensure the package name in:
- `android/app/build.gradle.kts`
- Firebase Console
- `google-services.json`

All match: `com.example.flutter_project`

---

## 🎯 **Quick Fix Checklist**

- [ ] **Replace google-services.json** with real Firebase config
- [ ] **Enable Phone Authentication** in Firebase Console
- [ ] **Add test phone numbers** (+91 98765 43210 → 123456)
- [ ] **Check internet connection**
- [ ] **Test with debug screen**
- [ ] **Use test phone number first**
- [ ] **Check Firebase Console for errors**
- [ ] **Verify package name consistency**

---

## 🚀 **Expected Results After Fix**

### **✅ With Test Phone Number:**
1. Enter: +91 98765 43210
2. Click "Send OTP"
3. Debug logs show: "✅ Code sent successfully!"
4. Enter: 123456
5. Authentication succeeds

### **✅ With Real Phone Number:**
1. Enter: +91 XXXXXXXXXX (your number)
2. Click "Send OTP"
3. Receive SMS with 6-digit code
4. Enter received code
5. Authentication succeeds

---

## 📞 **Support**

If issues persist after following this guide:
1. **Check debug logs** in the Firebase Debug Screen
2. **Share specific error messages** from the logs
3. **Verify Firebase Console configuration**
4. **Test with multiple phone numbers**

The enhanced AuthService now provides detailed error messages and logging to help identify the exact issue!
