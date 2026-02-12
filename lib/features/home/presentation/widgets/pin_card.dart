import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../services/cache_service.dart';
import '../../domain/entities/photo.dart';

/// Individual pin card in the masonry grid.
///
/// Pinterest UX details replicated:
/// - Rounded corners (16px)
/// - CachedNetworkImage with shimmer placeholder
/// - Photographer name overlay at bottom
/// - Aspect-ratio-aware height (natural photo proportions)
/// - **Scale-down press effect** (0.96x on tap, Pinterest signature)
/// - **Staggered fade-in** when appearing in the grid
/// - **Haptic feedback** on tap
class PinCard extends StatefulWidget {
  const PinCard({super.key, required this.photo, this.onTap, this.index = 0});

  final Photo photo;
  final VoidCallback? onTap;
  final int index;

  @override
  State<PinCard> createState() => _PinCardState();
}

class _PinCardState extends State<PinCard> with SingleTickerProviderStateMixin {
  // ── Press animation ──────────────────────────────────────────────
  bool _isPressed = false;

  // ── Fade-in animation ────────────────────────────────────────────
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    // Stagger based on index (capped at 300ms delay)
    Future.delayed(Duration(milliseconds: (widget.index % 10) * 30), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  void _onTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RepaintBoundary(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: _onTap,
            child: AnimatedScale(
              scale: _isPressed ? 0.96 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeInOut,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image ─────────────────────────────────────────────
                  Hero(
                    tag: 'pin-image-${widget.photo.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppConstants.pinBorderRadius,
                      ),
                      child: AspectRatio(
                        aspectRatio: 1 / widget.photo.aspectRatio,
                        child: CachedNetworkImage(
                          imageUrl: widget.photo.thumbnailUrl,
                          cacheManager: CacheService.thumbnailCacheManager,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Shimmer.fromColors(
                                baseColor:
                                    isDark
                                        ? AppColors.shimmerBaseDark
                                        : AppColors.shimmerBase,
                                highlightColor:
                                    isDark
                                        ? AppColors.shimmerHighlightDark
                                        : AppColors.shimmerHighlight,
                                child: Container(
                                  color:
                                      isDark
                                          ? AppColors.shimmerBaseDark
                                          : AppColors.shimmerBase,
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: theme.colorScheme.secondary,
                                  size: 32,
                                ),
                              ),
                        ),
                      ),
                    ),
                  ),

                  // ── Photographer Attribution ──────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.xs,
                      right: AppSpacing.xs,
                      top: AppSpacing.sm,
                      bottom: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: AppColors.pinterestRed,
                          child: Text(
                            widget.photo.photographer.isNotEmpty
                                ? widget.photo.photographer[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        AppSpacing.gapW4,
                        Expanded(
                          child: Text(
                            widget.photo.photographer,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
