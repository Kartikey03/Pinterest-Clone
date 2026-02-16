/*
 * Root application widget: wraps app with ClerkAuth, MaterialApp.router, and Pinterest theme.
 */

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import 'theme_provider.dart';

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
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: AppRouter.router,
        builder:
            (context, child) =>
                ClerkErrorListener(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
