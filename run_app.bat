@echo off
REM TaskPay App Runner Script for Windows
REM This script loads environment variables and runs the Flutter app

echo 🚀 Starting TaskPay...

REM Check if .env file exists
if not exist ".env" (
    echo ❌ .env file not found!
    echo    Please copy .env.example to .env and add your Appwrite credentials
    pause
    exit /b 1
)

REM Load environment variables and run app
echo 📱 Running Flutter app with environment variables...
flutter run --dart-define-from-file=.env

echo ✅ TaskPay started successfully!
pause