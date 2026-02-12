import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_heart_button.dart';
import '../../../home/domain/entities/photo.dart';
import '../providers/saved_pins_provider.dart';

/// Action bar shown at the bottom of the pin detail screen.
///
/// Pinterest UX replicated:
/// - Save/heart toggle with animated bounce
/// - Share button
/// - Visit photographer link
class PinActionBar extends ConsumerWidget {
  const PinActionBar({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedPins = ref.watch(savedPinsProvider);
    final isSaved = savedPins.contains(photo.id);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // ── Save / Heart Button (animated) ──────────────────────
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                ref.read(savedPinsProvider.notifier).toggle(photo.id);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedHeartButton(
                      isSaved: isSaved,
                      size: 22,
                      onToggle: () {
                        ref.read(savedPinsProvider.notifier).toggle(photo.id);
                      },
                    ),
                    AppSpacing.gapW4,
                    Text(
                      isSaved ? 'Saved' : 'Save',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSaved ? AppColors.pinterestRed : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AppSpacing.gapW16,

            // ── Share Button ─────────────────────────────────────────
            _ActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share coming soon'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),

            const Spacer(),

            // ── Visit Button ────────────────────────────────────────
            FilledButton(
              onPressed: () async {
                final url = Uri.parse(photo.photographerUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.pinterestRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: const Text('Visit'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small icon + label button used in the action bar.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: theme.iconTheme.color),
            AppSpacing.gapW4,
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
