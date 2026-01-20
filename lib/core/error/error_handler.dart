abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error.toString().contains('user-not-found')) {
      return 'No user found with this email.';
    } else if (error.toString().contains('wrong-password')) {
      return 'Wrong password provided.';
    } else if (error.toString().contains('email-already-in-use')) {
      return 'An account already exists with this email.';
    } else if (error.toString().contains('weak-password')) {
      return 'Password should be at least 6 characters.';
    } else if (error.toString().contains('invalid-email')) {
      return 'Please enter a valid email address.';
    } else if (error.toString().contains('network-request-failed')) {
      return 'Network error. Please check your connection.';
    } else if (error.toString().contains('too-many-requests')) {
      return 'Too many attempts. Please try again later.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
