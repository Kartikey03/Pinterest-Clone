import 'package:flutter/widgets.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/clerk_auth_datasource.dart';

/// Concrete [AuthRepository] implementation backed by Clerk.
///
/// Requires a [BuildContext] to access the [ClerkAuth] inherited widget.
/// In a production app you'd use a service locator, but Clerk's architecture
/// requires widget-tree access, so we pass context explicitly.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.datasource, required this.context});

  final ClerkAuthDatasource datasource;
  final BuildContext context;

  @override
  bool get isAuthenticated => datasource.isAuthenticated(context);

  @override
  AuthUser? get currentUser => datasource.getCurrentUser(context);

  @override
  Future<void> signOut() => datasource.signOut(context);
}
