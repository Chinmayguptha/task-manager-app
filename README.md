# Task Manager App - Flutter Web (Local Mode)

A modern task management web application built with Flutter Web, featuring **local storage** (no backend required!), clean architecture, and BLoC state management.

## ✨ Key Features

- ✅ **100% Offline** - No internet or backend needed!
- ✅ **Zero Setup** - Just run and use
- ✅ **User Authentication** - Local email/password storage
- ✅ **Task Management** - Full CRUD operations
- ✅ **Task Filtering** - Filter by priority and status
- ✅ **Smart Sorting** - Automatic sorting by due date
- ✅ **Clean Architecture** - Professional code structure
- ✅ **BLoC State Management** - Reactive state management
- ✅ **Material Design** - Beautiful, responsive UI

## 🚀 Quick Start (2 Steps!)

### Step 1: Run the App

**Double-click `run.bat`** - That's it!

The app will open in Chrome and you can start using it immediately.

### Step 2: Use the App

1. **Sign up** with any email and password (stored locally)
2. **Create tasks** with the + button
3. **Filter** by priority or status
4. **Edit/Delete** tasks as needed

## 📦 What's Inside

- **Local Storage**: SharedPreferences + Hive
- **No Backend**: Everything stored on your computer
- **Flutter Web**: Runs in any modern browser
- **Clean Architecture**: Domain/Data/Presentation layers
- **BLoC Pattern**: Professional state management

## 🎯 Assignment Requirements

| Requirement | Status |
|------------|--------|
| User authentication | ✅ Local storage |
| Error handling | ✅ Implemented |
| Task CRUD | ✅ Full CRUD |
| Task fields | ✅ All fields |
| Backend storage | ✅ Local storage |
| Mark complete/incomplete | ✅ Yes |
| Filter by priority/status | ✅ Yes |
| Sort by due date | ✅ Yes |
| Clean UI | ✅ Material Design |
| Clean architecture | ✅ Yes |
| BLoC state management | ✅ Yes |

## 🛠️ Development

```bash
# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# Build for production
flutter build web --release
```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants
│   ├── theme/           # Material theme
│   ├── error/           # Error handling
│   └── di/              # Dependency injection
├── features/
│   ├── auth/            # Authentication (local)
│   └── tasks/           # Task management (local)
└── main.dart
```

## 💾 Data Storage

- **Authentication**: SharedPreferences
- **Tasks**: Hive (local NoSQL database)
- **All data**: Stored in browser local storage
- **Privacy**: Data never leaves your computer

## 🎨 UI Screens

1. **Splash Screen** - Animated gradient
2. **Login/Signup** - Local authentication
3. **Task List** - Filtered, grouped tasks
4. **Add/Edit Task** - Form with validation

## 📝 Notes

- Data is stored locally in your browser
- Clearing browser data will delete all tasks
- No internet connection required
- Perfect for offline use and demos

## 👨‍💻 Developer

Built for Whatbytes Flutter Developer Intern Assignment

---

**Ready to use!** Just run `run.bat` and start managing tasks! 🚀
