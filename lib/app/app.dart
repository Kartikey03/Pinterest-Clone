import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import 'theme_provider.dart';

/// Root application widget.
///
/// Wraps the entire app with [ClerkAuth] for session management.
/// [ClerkErrorListener] catches and displays auth errors.
/// [MaterialApp.router] provides GoRouter navigation + Pinterest theme.
class PinterestApp extends ConsumerWidget {
  const PinterestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publishableKey = dotenv.env['CLERK_PUBLISHABLE_KEY'] ?? '';
    final themeMode = ref.watch(themeModeProvider);

    return ClerkAuth(
      config: ClerkAuthConfig(publishableKey: publishableKey),
      child: MaterialApp.router(
        title: 'Pinterest',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,

        // Routing
        routerConfig: AppRouter.router,

        // ClerkErrorListener needs ScaffoldMessenger (provided by MaterialApp),
        // so it must be placed inside the builder, not above MaterialApp.
        builder:
            (context, child) =>
                ClerkErrorListener(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
