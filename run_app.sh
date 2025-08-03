#!/bin/bash

# TaskPay App Runner Script
# This script loads environment variables and runs the Flutter app

echo "🚀 Starting TaskPay..."

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found!"
    echo "   Please copy .env.example to .env and add your Appwrite credentials"
    exit 1
fi

# Load environment variables and run app
echo "📱 Running Flutter app with environment variables..."
flutter run --dart-define-from-file=.env

echo "✅ TaskPay started successfully!"