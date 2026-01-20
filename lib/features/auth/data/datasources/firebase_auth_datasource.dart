import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

abstract class LocalAuthDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class LocalAuthDataSourceImpl implements LocalAuthDataSource {
  final SharedPreferences prefs;

  LocalAuthDataSourceImpl(this.prefs);

  static const String _currentUserKey = 'current_user_id';
  static const String _usersKey = 'users';

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Get all users
      final usersJson = prefs.getString(_usersKey);
      if (usersJson == null) {
        throw Exception('No users found. Please register first.');
      }

      // Parse users
      final users = (usersJson.split('|||'))
          .where((u) => u.isNotEmpty)
          .map((u) {
            final parts = u.split('::');
            return {
              'id': parts[0],
              'email': parts[1],
              'password': parts[2],
            };
          })
          .toList();

      // Find user
      final user = users.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => throw Exception('Invalid email or password'),
      );

      // Save current user
      await prefs.setString(_currentUserKey, user['id']!);

      return UserModel(
        id: user['id']!,
        email: user['email']!,
        displayName: null,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String email, String password) async {
    try {
      // Validate
      if (password.length < 6) {
        throw Exception('Password should be at least 6 characters');
      }

      // Get existing users
      final usersJson = prefs.getString(_usersKey) ?? '';
      final users = usersJson.isEmpty
          ? []
          : (usersJson.split('|||'))
              .where((u) => u.isNotEmpty)
              .map((u) => u.split('::')[1])
              .toList();

      // Check if email exists
      if (users.contains(email)) {
        throw Exception('An account already exists with this email');
      }

      // Create new user
      final userId = DateTime.now().millisecondsSinceEpoch.toString();
      final newUser = '$userId::$email::$password';
      final updatedUsers = usersJson.isEmpty ? newUser : '$usersJson|||$newUser';

      // Save
      await prefs.setString(_usersKey, updatedUsers);
      await prefs.setString(_currentUserKey, userId);

      return UserModel(
        id: userId,
        email: email,
        displayName: null,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await prefs.remove(_currentUserKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = prefs.getString(_currentUserKey);
      if (userId == null) return null;

      final usersJson = prefs.getString(_usersKey);
      if (usersJson == null) return null;

      final users = (usersJson.split('|||'))
          .where((u) => u.isNotEmpty)
          .map((u) {
            final parts = u.split('::');
            return {
              'id': parts[0],
              'email': parts[1],
            };
          })
          .toList();

      final user = users.firstWhere(
        (u) => u['id'] == userId,
        orElse: () => throw Exception('User not found'),
      );

      return UserModel(
        id: user['id']!,
        email: user['email']!,
        displayName: null,
      );
    } catch (e) {
      return null;
    }
  }
}
