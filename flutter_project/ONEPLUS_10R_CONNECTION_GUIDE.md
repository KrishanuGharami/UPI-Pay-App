# 📱 OnePlus 10R Connection Guide - UPI Pay App

## 🚀 **Connect OnePlus 10R for App Development**

Complete guide to connect your OnePlus 10R and run the UPI Pay app.

---

## 📋 **OnePlus 10R Specific Steps**

### **Step 1: Enable Developer Options**
1. **Settings** → **About device**
2. **Tap "Build number" 7 times** (at the bottom)
3. **Enter PIN/Password** when prompted
4. **"Developer options enabled" message appears**

### **Step 2: Configure Developer Options**
1. **Settings** → **Additional settings** → **Developer options**
2. **Enable "Developer options"** (toggle at top)
3. **Enable "USB debugging"**
4. **Enable "Install via USB"**
5. **Enable "USB debugging (Security settings)"**
6. **Set "Select USB Configuration" to "MTP"**

### **Step 3: OnePlus Specific Settings**
1. **Settings** → **Additional settings** → **Developer options**
2. **Find "Default USB configuration"**
3. **Select "File Transfer (MTP)"**
4. **Enable "Verify apps over USB"** (optional)
5. **Enable "Wireless debugging"** (backup option)

---

## 🔌 **Physical Connection**

### **USB Connection Steps:**
1. **Use original OnePlus cable** or high-quality data cable
2. **Connect to USB 3.0 port** on computer (blue port)
3. **On OnePlus 10R notification panel:**
   - Look for "USB" notification
   - Tap and select "File Transfer"
   - NOT "Charging only"

### **Trust Computer:**
1. **"Allow USB debugging?" popup should appear**
2. **Check "Always allow from this computer"**
3. **Tap "Allow"**
4. **If popup doesn't appear, disconnect and reconnect**

---

## 🔧 **Troubleshooting OnePlus 10R**

### **Common OnePlus Issues:**

#### **Issue 1: Device Not Detected**
**Solutions:**
1. **Revoke USB debugging authorizations:**
   - Developer options → "Revoke USB debugging authorizations"
   - Reconnect and allow again
2. **Try different USB cable** (must support data transfer)
3. **Use different USB port** on computer
4. **Restart both devices**

#### **Issue 2: OnePlus USB Mode Issues**
**Solutions:**
1. **Pull down notification panel**
2. **Tap "USB" notification**
3. **Select "File Transfer" or "MTP"**
4. **NOT "Charging only" or "No data transfer"**

#### **Issue 3: OxygenOS Specific**
**Solutions:**
1. **Settings** → **Additional settings** → **Developer options**
2. **"Select USB Configuration"** → **"MTP"**
3. **Disable "USB debugging"** → **Re-enable it**
4. **Clear cache of "USB debugging" if option available**

---

## 🧪 **Verification Commands**

### **Check Device Connection:**
```bash
# Check if device is detected
flutter devices

# Check with longer timeout
flutter devices --device-timeout 30

# Verbose device information
flutter devices --machine
```

### **Expected Output:**
```
Found X connected devices:
  OnePlus 10R (mobile) • [device-id] • android-arm64 • Android X.X (API XX)
  [other devices...]
```

---

## 🚀 **Deploy UPI Pay App**

### **Once OnePlus 10R is Detected:**

#### **Method 1: Direct Run (Recommended)**
```bash
flutter run -d [oneplus-device-id]
```

#### **Method 2: Build and Install**
```bash
# Build APK
flutter build apk --debug

# Install on device
flutter install -d [oneplus-device-id]
```

#### **Method 3: Release Build**
```bash
# Build release APK
flutter build apk --release

# Manual installation via file manager
```

---

## 📱 **OnePlus 10R App Experience**

### **Expected Features:**
- ✅ **Enhanced Mode Active** with green banner
- ✅ **Native Android performance** and animations
- ✅ **Touch gestures** and haptic feedback
- ✅ **Firebase authentication** with real SMS
- ✅ **Camera access** for QR scanning (when implemented)
- ✅ **Native notifications** and system integration

### **OnePlus Specific Benefits:**
- ✅ **120Hz display** for smooth animations
- ✅ **Fast charging** while testing
- ✅ **OxygenOS optimizations** for Flutter apps
- ✅ **Gaming mode** for performance testing
- ✅ **Screen recording** for demos

---

## 🔧 **Alternative Connection Methods**

### **Method 1: Wireless Debugging (Android 11+)**
1. **Enable "Wireless debugging"** in Developer options
2. **Connect to same WiFi** as computer
3. **Pair via QR code** or pairing code
4. **Use wireless connection** for development

### **Method 2: Network ADB**
```bash
# Enable network ADB on device
adb tcpip 5555

# Connect via IP address
adb connect [device-ip]:5555

# Verify connection
flutter devices
```

---

## 🎯 **OnePlus 10R Optimization**

### **Performance Settings:**
1. **Settings** → **Battery** → **High performance mode**
2. **Settings** → **Display** → **120Hz refresh rate**
3. **Developer options** → **Force GPU rendering**
4. **Developer options** → **Disable HW overlays**

### **Testing Settings:**
1. **Enable "Stay awake"** (screen won't sleep while charging)
2. **Enable "Show touches"** (for demo/recording)
3. **Enable "Pointer location"** (for touch debugging)
4. **Set "Animation scale"** to 0.5x (faster testing)

---

## 🚨 **If Connection Still Fails**

### **Last Resort Solutions:**

#### **1. Use Android Studio**
1. **Open Android Studio**
2. **Tools** → **SDK Manager** → **SDK Tools**
3. **Install "Google USB Driver"**
4. **Restart computer and try again**

#### **2. Manual Driver Installation**
1. **Download OnePlus USB drivers**
2. **Install manually** via Device Manager
3. **Restart and reconnect**

#### **3. Alternative Testing**
- **Use Android emulator** (Pixel 9 Pro XL available)
- **Continue web testing** (fully functional)
- **Try wireless debugging**

---

## 🎉 **Success Indicators**

### **✅ Connection Successful:**
- OnePlus 10R appears in `flutter devices`
- Device shows as "android-arm64" platform
- No error messages in Flutter output

### **✅ App Deployment Successful:**
- UPI Pay app icon appears on OnePlus 10R
- App opens without crashes
- Enhanced Mode banner visible
- Smooth 120Hz animations
- All features working

---

## 📞 **Quick Commands for OnePlus 10R**

```bash
# Check connection
flutter devices

# Run app on OnePlus 10R
flutter run -d [device-id]

# Build for OnePlus 10R
flutter build apk --target-platform android-arm64

# Install pre-built APK
flutter install -d [device-id]

# Hot reload during development
# (automatic when running with flutter run)
```

---

## 🎯 **Expected OnePlus 10R Experience**

After successful deployment:
- 🚀 **Enhanced Mode** active by default
- 📱 **Native OnePlus performance** with 120Hz display
- 🔥 **Firebase authentication** with real SMS
- 💫 **Smooth animations** optimized for OxygenOS
- 🎮 **Touch interactions** with haptic feedback
- 📊 **Full UPI payment simulation** features

**Your OnePlus 10R will provide the best mobile experience for testing the UPI Pay app!** 📱✨
