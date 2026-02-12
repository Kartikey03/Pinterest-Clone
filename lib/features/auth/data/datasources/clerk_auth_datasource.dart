import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/auth_user.dart';

/// Data source that wraps Clerk SDK calls.
///
/// Reads auth state from the [ClerkAuthProvider] inherited widget.
/// This is the only file in the project that directly calls Clerk APIs.
class ClerkAuthDatasource {
  /// Extract the current user from the Clerk auth state.
  AuthUser? getCurrentUser(BuildContext context) {
    final auth = ClerkAuth.of(context);
    final user = auth.user;
    if (user == null) return null;

    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      firstName: user.firstName,
      lastName: user.lastName,
      imageUrl: user.imageUrl,
    );
  }

  /// Whether a user session currently exists.
  bool isAuthenticated(BuildContext context) {
    final auth = ClerkAuth.of(context);
    return auth.user != null;
  }

  /// Sign out via Clerk.
  Future<void> signOut(BuildContext context) async {
    final auth = ClerkAuth.of(context);
    await auth.signOut();
  }
}
