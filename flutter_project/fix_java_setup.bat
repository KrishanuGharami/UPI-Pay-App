@echo off
echo 🔧 Java JDK Setup Helper for Flutter
echo.

echo Checking current Java version...
java -version
echo.

echo Current JAVA_HOME (if set):
echo %JAVA_HOME%
echo.

echo 📋 To fix the JDK issue, follow these steps:
echo.
echo 1. Download JDK 17 from: https://adoptium.net/temurin/releases/
echo 2. Install JDK 17 (note the installation path)
echo 3. Set JAVA_HOME environment variable
echo.

echo 🔍 Common JDK 17 installation paths:
echo - C:\Program Files\Eclipse Adoptium\jdk-17.0.x-hotspot
echo - C:\Program Files\Java\jdk-17.0.x
echo - C:\Program Files\OpenJDK\jdk-17.0.x
echo.

echo 💡 To set JAVA_HOME:
echo 1. Open System Properties (Win + R, type: sysdm.cpl)
echo 2. Click "Environment Variables"
echo 3. Under "System Variables", click "New"
echo 4. Variable name: JAVA_HOME
echo 5. Variable value: [Your JDK 17 installation path]
echo 6. Click OK and restart your terminal
echo.

echo 🚀 Alternative: Use Flutter's embedded JDK
echo Run: flutter config --jdk-dir="[path-to-jdk-17]"
echo.

pause
