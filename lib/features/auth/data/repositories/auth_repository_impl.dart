/*
 * AuthRepository implementation backed by ClerkAuthDatasource.
 */

import 'package:flutter/widgets.dart';

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/clerk_auth_datasource.dart';

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
