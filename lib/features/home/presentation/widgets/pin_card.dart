/*
 * Pin card widget with press animation, shimmer loading, and three-dot options menu.
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../services/cache_service.dart';
import '../../domain/entities/photo.dart';
import '../../../pin/presentation/providers/saved_pins_provider.dart';
import '../providers/home_feed_provider.dart';

class PinCard extends ConsumerStatefulWidget {
  const PinCard({super.key, required this.photo, this.onTap, this.index = 0});

  final Photo photo;
  final VoidCallback? onTap;
  final int index;

  @override
  ConsumerState<PinCard> createState() => _PinCardState();
}

class _PinCardState extends ConsumerState<PinCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
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

  void _showOptionsSheet(BuildContext context) {
    final theme = Theme.of(context);
    final photo = widget.photo;
    final savedPins = ref.read(savedPinsProvider);
    final isSaved = savedPins.containsKey(photo.id);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: const Text('Download image'),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image download started'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('Share'),
                  onTap: () {
                    Navigator.pop(ctx);
                    final text =
                        '📌 Check out this photo by ${photo.photographer}!\n'
                        '${photo.photographerUrl}';
                    Share.share(text);
                  },
                ),
                ListTile(
                  leading: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                  ),
                  title: Text(isSaved ? 'Unsave' : 'Save'),
                  onTap: () {
                    Navigator.pop(ctx);
                    ref
                        .read(savedPinsProvider.notifier)
                        .toggle(photo.id, photo);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.visibility_off_outlined),
                  title: const Text('See less like this'),
                  onTap: () {
                    Navigator.pop(ctx);
                    ref.read(homeFeedProvider.notifier).removePhoto(photo.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Got it — we'll show less like this"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('Report Pin'),
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
    );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                onTap: _onTap,
                child: AnimatedScale(
                  scale: _isPressed ? 0.96 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeInOut,
                  child: Hero(
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
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 28,
                  width: 28,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                    onPressed: () => _showOptionsSheet(context),
                    icon: Icon(
                      Icons.more_horiz,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
