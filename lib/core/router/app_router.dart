/*
 * GoRouter configuration with auth-aware redirects and bottom-nav shell.
 */

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/home/domain/entities/photo.dart';
import '../../features/home/presentation/screens/main_shell.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/inbox/presentation/screens/inbox_screen.dart';
import '../../features/pin/presentation/screens/pin_detail_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

abstract final class AppRouter {
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String search = 'search';
  static const String inbox = 'inbox';
  static const String profile = 'profile';
  static const String pinDetail = 'pin-detail';

  static const String splashPath = '/splash';
  static const String loginPath = '/login';
  static const String homePath = '/';
  static const String searchPath = '/search';
  static const String inboxPath = '/inbox';
  static const String profilePath = '/profile';
  static const String pinDetailPath = '/pin/:id';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: homePath,
    debugLogDiagnostics: true,
    redirect: (BuildContext context, GoRouterState state) {
      bool isAuthenticated;
      try {
        final auth = ClerkAuth.of(context);
        isAuthenticated = auth.user != null;
      } catch (_) {
        isAuthenticated = false;
      }

      final isOnLoginPage = state.matchedLocation == loginPath;

      if (!isAuthenticated && !isOnLoginPage) {
        return loginPath;
      }

      if (isAuthenticated && isOnLoginPage) {
        return homePath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: pinDetailPath,
        name: pinDetail,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          final photo = state.extra! as Photo;
          return CustomTransitionPage(
            key: state.pageKey,
            child: PinDetailScreen(photo: photo),
            transitionDuration: const Duration(milliseconds: 350),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              final slideAnimation = Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: slideAnimation, child: child),
              );
            },
          );
        },
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: homePath,
            name: home,
            pageBuilder:
                (context, state) => const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: searchPath,
            name: search,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: SearchScreen()),
          ),
          GoRoute(
            path: inboxPath,
            name: inbox,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: InboxScreen()),
          ),
          GoRoute(
            path: profilePath,
            name: profile,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),
    ],
  );
}
