/*
 * Full-screen pin detail view with hero image, photographer info, and similar photos grid.
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/animated_heart_button.dart';
import '../../../../services/cache_service.dart';
import '../../../home/domain/entities/photo.dart';
import '../../../home/presentation/widgets/pin_card.dart';
import '../providers/followed_users_provider.dart';
import '../providers/saved_pins_provider.dart';
import '../providers/similar_photos_provider.dart';
import '../widgets/pin_action_bar.dart';

class PinDetailScreen extends ConsumerWidget {
  const PinDetailScreen({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final savedPins = ref.watch(savedPinsProvider);
    final isSaved = savedPins.containsKey(photo.id);
    final similarPhotos = ref.watch(similarPhotosProvider(photo));
    final followedUsers = ref.watch(followedUsersProvider);
    final isFollowing = followedUsers.containsKey(photo.photographerUrl);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back,
              color: theme.iconTheme.color,
              size: 20,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: AnimatedHeartButton(
                isSaved: isSaved,
                size: 20,
                onToggle: () {
                  ref.read(savedPinsProvider.notifier).toggle(photo.id, photo);
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'pin-image-${photo.id}',
                    child: CachedNetworkImage(
                      imageUrl: photo.imageUrl,
                      cacheManager: CacheService.fullImageCacheManager,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                      placeholder:
                          (context, url) => AspectRatio(
                            aspectRatio: 1 / photo.aspectRatio,
                            child: Shimmer.fromColors(
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
                          ),
                      errorWidget:
                          (context, url, error) => AspectRatio(
                            aspectRatio: 1 / photo.aspectRatio,
                            child: Container(
                              color: theme.colorScheme.surfaceContainerHighest,
                              child: const Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                              ),
                            ),
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.pinterestRed,
                          child: Text(
                            photo.photographer.isNotEmpty
                                ? photo.photographer[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        AppSpacing.gapW12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                photo.photographer,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Photographer',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        isFollowing
                            ? FilledButton(
                              onPressed: () {
                                ref
                                    .read(followedUsersProvider.notifier)
                                    .toggle(
                                      photographerName: photo.photographer,
                                      photographerUrl: photo.photographerUrl,
                                    );
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.pinterestRed,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusXl,
                                  ),
                                ),
                              ),
                              child: const Text('Following'),
                            )
                            : OutlinedButton(
                              onPressed: () {
                                ref
                                    .read(followedUsersProvider.notifier)
                                    .toggle(
                                      photographerName: photo.photographer,
                                      photographerUrl: photo.photographerUrl,
                                    );
                              },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppSpacing.radiusXl,
                                  ),
                                ),
                              ),
                              child: const Text('Follow'),
                            ),
                      ],
                    ),
                  ),
                  if (photo.alt.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Text(photo.alt, style: theme.textTheme.bodyLarge),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_size_select_actual_outlined,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        AppSpacing.gapW4,
                        Text(
                          '${photo.width} × ${photo.height}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    child: Text(
                      'More like this',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  similarPhotos.when(
                    loading:
                        () => const Padding(
                          padding: EdgeInsets.all(AppSpacing.xxl),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.pinterestRed,
                              strokeWidth: 2.5,
                            ),
                          ),
                        ),
                    error:
                        (e, _) => Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Center(
                            child: Text(
                              'Could not load similar photos',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                    data: (photos) {
                      if (photos.isEmpty) {
                        return const SizedBox(height: AppSpacing.lg);
                      }
                      return Padding(
                        padding: AppSpacing.paddingAllSm,
                        child: MasonryGridView.count(
                          crossAxisCount: AppConstants.masonryColumnCount,
                          mainAxisSpacing: AppConstants.masonryMainAxisSpacing,
                          crossAxisSpacing:
                              AppConstants.masonryCrossAxisSpacing,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: photos.length,
                          itemBuilder: (context, index) {
                            final similarPhoto = photos[index];
                            return PinCard(
                              photo: similarPhoto,
                              index: index,
                              onTap: () {
                                context.push(
                                  '/pin/${similarPhoto.id}',
                                  extra: similarPhoto,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  AppSpacing.gapH32,
                ],
              ),
            ),
          ),
          PinActionBar(photo: photo),
        ],
      ),
    );
  }
}
