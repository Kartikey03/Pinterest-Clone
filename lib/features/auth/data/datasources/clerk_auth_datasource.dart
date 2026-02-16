/*
 * Clerk auth data source: reads auth state and handles sign-out via ClerkAuth widget.
 */

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/widgets.dart';

import '../../domain/entities/auth_user.dart';

class ClerkAuthDatasource {
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

  bool isAuthenticated(BuildContext context) {
    final auth = ClerkAuth.of(context);
    return auth.user != null;
  }

  Future<void> signOut(BuildContext context) async {
    final auth = ClerkAuth.of(context);
    await auth.signOut();
  }
}
