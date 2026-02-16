/*
 * Riverpod auth notifier that syncs state from Clerk's inherited widget.
 */

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_user.dart';

class AuthNotifier extends StateNotifier<AuthUser?> {
  AuthNotifier() : super(null);

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

  void clear() {
    state = null;
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthUser?>((
  ref,
) {
  return AuthNotifier();
});
