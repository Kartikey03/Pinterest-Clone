import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Pinterest-styled login screen.
///
/// Wraps Clerk's built-in [ClerkAuthentication] widget with
/// Pinterest branding: logo, headline, and themed scaffold.
///
/// Pinterest UX details replicated:
/// - Large red pin icon at top
/// - "Welcome to Pinterest" headline
/// - Clean white background with generous top padding
/// - Rounded, red-accented action buttons (via Clerk theming)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.xxxl,
          ),
          child: Column(
            children: [
              AppSpacing.gapH48,

              // ── Pinterest Logo ──────────────────────────────────────
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.pinterestRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.push_pin,
                  color: AppColors.white,
                  size: 32,
                ),
              ),

              AppSpacing.gapH24,

              // ── Welcome Text ────────────────────────────────────────
              Text(
                'Welcome to Pinterest',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              AppSpacing.gapH8,

              Text(
                'Discover ideas and find inspiration',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),

              AppSpacing.gapH32,

              // ── Clerk Authentication Widget ─────────────────────────
              // Clerk provides the full sign-in/up flow including
              // email, password, and social login options.
              const ClerkAuthentication(),

              AppSpacing.gapH24,

              // ── Terms Notice ────────────────────────────────────────
              Text(
                'By continuing, you agree to Pinterest\'s\nTerms of Service and Privacy Policy',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
