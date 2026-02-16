/*
 * Abstract auth repository contract for the domain layer.
 */

import '../entities/auth_user.dart';

abstract class AuthRepository {
  bool get isAuthenticated;
  AuthUser? get currentUser;
  Future<void> signOut();
}
