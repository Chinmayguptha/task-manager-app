@echo off
echo ========================================
echo Building Task Manager App
echo ========================================
echo.
echo Building for web...
echo.
flutter build web --release
echo.
echo ========================================
echo Build complete!
echo Output: build\web
echo.
echo You can now:
echo 1. Open build\web\index.html in a browser
echo 2. Deploy to any static hosting
echo ========================================
pause
