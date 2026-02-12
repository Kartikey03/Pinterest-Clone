import '../entities/auth_user.dart';

/// Abstract contract for authentication operations.
///
/// The domain layer depends on this contract; the data layer
/// provides the Clerk-backed implementation.
abstract class AuthRepository {
  /// Whether a user is currently authenticated.
  bool get isAuthenticated;

  /// The currently signed-in user, or `null`.
  AuthUser? get currentUser;

  /// Sign out the current user.
  Future<void> signOut();
}
