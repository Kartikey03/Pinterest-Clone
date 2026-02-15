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

/// Centralized GoRouter configuration with auth-aware redirects.
///
/// Uses [ShellRoute] for the bottom navigation scaffold so that
/// tab state (including scroll position) is preserved when switching
/// between Home, Search, and Profile.
///
/// Route guard logic:
/// - Unauthenticated user → redirect to `/login`
/// - Authenticated user on `/login` → redirect to `/`
abstract final class AppRouter {
  // ── Route Names ────────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String login = 'login';
  static const String home = 'home';
  static const String search = 'search';
  static const String inbox = 'inbox';
  static const String profile = 'profile';
  static const String pinDetail = 'pin-detail';

  // ── Route Paths ────────────────────────────────────────────────────────
  static const String splashPath = '/splash';
  static const String loginPath = '/login';
  static const String homePath = '/';
  static const String searchPath = '/search';
  static const String inboxPath = '/inbox';
  static const String profilePath = '/profile';
  static const String pinDetailPath = '/pin/:id';

  // ── Navigator Keys ─────────────────────────────────────────────────────
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  /// The [GoRouter] instance used by [MaterialApp.router].
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: homePath,
    debugLogDiagnostics: true,

    // ── Auth Redirect Guard ──────────────────────────────────────────
    redirect: (BuildContext context, GoRouterState state) {
      // Check if user is authenticated via Clerk's inherited widget
      bool isAuthenticated;
      try {
        final auth = ClerkAuth.of(context);
        isAuthenticated = auth.user != null;
      } catch (_) {
        // ClerkAuth not yet available in tree during initial build
        isAuthenticated = false;
      }

      final isOnLoginPage = state.matchedLocation == loginPath;

      // Not authenticated and not on login → go to login
      if (!isAuthenticated && !isOnLoginPage) {
        return loginPath;
      }

      // Authenticated but on login → go to home
      if (isAuthenticated && isOnLoginPage) {
        return homePath;
      }

      // No redirect needed
      return null;
    },

    routes: [
      // ── Login Route (full-screen, outside shell) ───────────────────
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => const LoginScreen(),
      ),

      // ── Pin Detail (full-screen, outside shell for hero animation) ─
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

      // ── Bottom Navigation Shell ──────────────────────────────────────
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
