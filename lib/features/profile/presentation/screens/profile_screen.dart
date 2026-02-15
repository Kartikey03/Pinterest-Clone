import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme_provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../home/domain/entities/photo.dart';
import '../../../home/presentation/widgets/pin_card.dart';
import '../../../pin/presentation/providers/followed_users_provider.dart';
import '../../../pin/presentation/providers/saved_pins_provider.dart';
import '../providers/boards_provider.dart';
import '../widgets/boards_grid.dart';
import '../widgets/profile_header.dart';

/// Pinterest-style profile screen.
///
/// Features replicated:
/// - Centered profile header with avatar and stats
/// - Tab bar: "Saved" pins and "Boards"
/// - Create board dialog
/// - Settings gear icon in app bar
/// - Sign out option
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule auth sync after the current frame to avoid
    // modifying provider state during the widget tree build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(authNotifierProvider.notifier).updateFromClerk(context);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider);
    final savedPins = ref.watch(savedPinsProvider);
    final boards = ref.watch(boardsProvider);
    final followedUsers = ref.watch(followedUsersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          user?.displayName ?? 'Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          // Settings / Sign out menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.settings_outlined),
            onSelected: (value) {
              if (value == 'signout') {
                _signOut(context);
              } else if (value == 'theme') {
                ref.read(themeModeProvider.notifier).toggleTheme();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'theme',
                    child: Row(
                      children: [
                        Icon(
                          ref.read(themeModeProvider.notifier).isDark
                              ? Icons.light_mode
                              : Icons.dark_mode,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          ref.read(themeModeProvider.notifier).isDark
                              ? 'Light mode'
                              : 'Dark mode',
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'signout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: AppSpacing.sm),
                        Text('Sign out'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              // ── Profile Header ──────────────────────────────────────
              SliverToBoxAdapter(
                child: ProfileHeader(
                  user: user,
                  savedCount: savedPins.length,
                  boardsCount: boards.length,
                  followingCount: followedUsers.length,
                ),
              ),

              // ── Tab Bar ─────────────────────────────────────────────
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.pinterestRed,
                    labelColor: theme.colorScheme.onSurface,
                    unselectedLabelColor: theme.colorScheme.secondary,
                    labelStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    tabs: const [
                      Tab(text: 'Saved'),
                      Tab(text: 'Boards'),
                      Tab(text: 'Following'),
                    ],
                  ),
                  backgroundColor: theme.scaffoldBackgroundColor,
                ),
              ),
            ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // ── Saved Tab ─────────────────────────────────────────
            _buildSavedTab(savedPins),

            // ── Boards Tab ────────────────────────────────────────
            SingleChildScrollView(
              child: BoardsGrid(
                boards: boards,
                onCreateBoard: () => _showCreateBoardDialog(context),
              ),
            ),

            // ── Following Tab ─────────────────────────────────────
            _buildFollowingTab(followedUsers),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedTab(Map<int, Photo> savedPins) {
    if (savedPins.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.pinterestRed.withValues(alpha: 0.3),
            ),
            AppSpacing.gapH16,
            Text(
              'No saved pins yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            Text(
              'Tap the heart icon on any pin to save it',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }

    final photos = savedPins.values.toList().reversed.toList();

    return Padding(
      padding: AppSpacing.paddingAllSm,
      child: MasonryGridView.count(
        crossAxisCount: AppConstants.masonryColumnCount,
        mainAxisSpacing: AppConstants.masonryMainAxisSpacing,
        crossAxisSpacing: AppConstants.masonryCrossAxisSpacing,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          return PinCard(
            photo: photo,
            index: index,
            onTap: () {
              context.push('/pin/${photo.id}', extra: photo);
            },
          );
        },
      ),
    );
  }

  Widget _buildFollowingTab(Map<String, FollowedUser> followedUsers) {
    if (followedUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_add_outlined,
              size: 64,
              color: AppColors.pinterestRed.withValues(alpha: 0.3),
            ),
            AppSpacing.gapH16,
            Text(
              'Not following anyone yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            Text(
              'Follow photographers to see them here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      );
    }

    final users = followedUsers.values.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: users.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.pinterestRed,
            child: Text(
              user.avatarInitial,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          title: Text(
            user.photographerName,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: const Text('Photographer'),
          trailing: FilledButton(
            onPressed: () {
              ref
                  .read(followedUsersProvider.notifier)
                  .toggle(
                    photographerName: user.photographerName,
                    photographerUrl: user.photographerUrl,
                  );
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.pinterestRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
            ),
            child: const Text('Following'),
          ),
        );
      },
    );
  }

  void _showCreateBoardDialog(BuildContext context) {
    final controller = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            title: Text(
              'Create board',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            content: TextField(
              controller: controller,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Board name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  final name = controller.text.trim();
                  if (name.isNotEmpty) {
                    ref.read(boardsProvider.notifier).createBoard(name);
                    Navigator.pop(context);
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.pinterestRed,
                ),
                child: const Text('Create'),
              ),
            ],
          ),
    );
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            title: const Text('Sign out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final auth = ClerkAuth.of(context);
                    await auth.signOut();
                    if (context.mounted) {
                      ref.read(authNotifierProvider.notifier).clear();
                    }
                  } catch (_) {
                    // Clerk may not be available
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.pinterestRed,
                ),
                child: const Text('Sign out'),
              ),
            ],
          ),
    );
  }
}

/// Delegate to pin the TabBar below the profile header.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate({required this.tabBar, required this.backgroundColor});

  final TabBar tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}
