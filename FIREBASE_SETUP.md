# Firebase Configuration Instructions

This file provides instructions for setting up Firebase in your Flutter app.

## Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click "Add project"
3. Enter project name: "Task Manager App"
4. Follow the setup wizard

## Step 2: Enable Services

### Authentication
1. In Firebase Console, go to "Authentication"
2. Click "Get Started"
3. Enable "Email/Password" provider

### Firestore Database
1. In Firebase Console, go to "Firestore Database"
2. Click "Create database"
3. Start in "test mode" (for development)
4. Choose your preferred location

## Step 3: Add Firebase to Android

1. In Firebase Console, click the Android icon (⚙️)
2. Register app with package name: `com.whatbytes.task_manager_app`
3. Download `google-services.json`
4. Place the file in: `android/app/google-services.json`

## Step 4: Add Firebase to iOS (Optional)

1. In Firebase Console, click the iOS icon
2. Register app with bundle ID: `com.whatbytes.taskManagerApp`
3. Download `GoogleService-Info.plist`
4. Place the file in: `ios/Runner/GoogleService-Info.plist`

## Step 5: Update Firestore Security Rules

For production, update your Firestore security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, write: if request.auth != null && 
                          request.auth.uid == resource.data.userId;
      allow create: if request.auth != null;
    }
  }
}
```

## Important Notes

- The `google-services.json` and `GoogleService-Info.plist` files are NOT included in the repository
- You MUST add these files before running the app
- Never commit these files to public repositories
- For test mode Firestore, data is publicly accessible for 30 days

## Troubleshooting

If you encounter Firebase initialization errors:
1. Ensure `google-services.json` is in the correct location
2. Run `flutter clean` and `flutter pub get`
3. Rebuild the app
