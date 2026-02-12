import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_user.dart';

/// Provides the current authentication state as a Riverpod provider.
///
/// Since Clerk's state lives in the widget tree (inherited widget),
/// we expose a helper that can be called from widget `build` methods
/// to extract the auth user.
///
/// Usage:
/// ```dart
/// final authNotifier = ref.read(authNotifierProvider.notifier);
/// authNotifier.updateFromClerk(context);
/// final user = ref.watch(authNotifierProvider);
/// ```
class AuthNotifier extends StateNotifier<AuthUser?> {
  AuthNotifier() : super(null);

  /// Sync state from the Clerk inherited widget.
  void updateFromClerk(BuildContext context) {
    try {
      final auth = ClerkAuth.of(context);
      final user = auth.user;
      if (user != null) {
        state = AuthUser(
          id: user.id,
          email: user.email ?? '',
          firstName: user.firstName,
          lastName: user.lastName,
          imageUrl: user.imageUrl,
        );
      } else {
        state = null;
      }
    } catch (_) {
      state = null;
    }
  }

  /// Clear auth state (called on sign out).
  void clear() {
    state = null;
  }
}

/// Global auth state provider.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthUser?>((
  ref,
) {
  return AuthNotifier();
});
