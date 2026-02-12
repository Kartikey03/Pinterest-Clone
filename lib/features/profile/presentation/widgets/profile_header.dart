import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/domain/entities/auth_user.dart';

/// Profile header with avatar, name, email, and stats.
///
/// Matches Pinterest's centered profile layout with
/// large circular avatar, display name, and follower counts.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.savedCount,
    required this.boardsCount,
    this.followingCount = 0,
  });

  final AuthUser? user;
  final int savedCount;
  final int boardsCount;
  final int followingCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayName = user?.displayName ?? 'Pinterest User';
    final initials = user?.initials ?? 'P';

    return Column(
      children: [
        AppSpacing.gapH24,

        // ── Avatar ─────────────────────────────────────────────────
        CircleAvatar(
          radius: 48,
          backgroundColor: AppColors.pinterestRed,
          backgroundImage:
              user?.imageUrl != null ? NetworkImage(user!.imageUrl!) : null,
          child:
              user?.imageUrl == null
                  ? Text(
                    initials,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                  : null,
        ),

        AppSpacing.gapH16,

        // ── Display Name ──────────────────────────────────────────
        Text(
          displayName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        AppSpacing.gapH4,

        // ── Email ─────────────────────────────────────────────────
        if (user?.email != null && user!.email.isNotEmpty)
          Text(
            user!.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),

        AppSpacing.gapH16,

        // ── Stats Row ────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _StatItem(count: savedCount, label: 'Saved'),
            AppSpacing.gapW32,
            _StatItem(count: boardsCount, label: 'Boards'),
            AppSpacing.gapW32,
            _StatItem(count: followingCount, label: 'Following'),
          ],
        ),

        AppSpacing.gapH16,
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          '$count',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
