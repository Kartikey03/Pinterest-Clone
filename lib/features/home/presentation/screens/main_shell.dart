import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';

/// Root scaffold with bottom navigation bar.
///
/// 5 tabs matching the real Pinterest app:
/// Home, Search, Create (+), Messages, Profile.
/// Labels are hidden — icon-only nav bar like the real app.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRouter.searchPath)) return 1;
    // index 2 is Create (no route, shows bottom sheet)
    if (location.startsWith(AppRouter.inboxPath)) return 3;
    if (location.startsWith(AppRouter.profilePath)) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRouter.home);
        break;
      case 1:
        context.goNamed(AppRouter.search);
        break;
      case 2:
        _showCreateSheet(context);
        break;
      case 3:
        context.goNamed(AppRouter.inbox);
        break;
      case 4:
        context.goNamed(AppRouter.profile);
        break;
    }
  }

  void _showCreateSheet(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Icon(
                  Icons.add_circle_outline,
                  size: 48,
                  color: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Create',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create pins and boards — coming soon!',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(context, index),
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: theme.colorScheme.onSurface,
          unselectedItemColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.5,
          ),
          items: const [
            // Home — filled rounded house
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 28),
              activeIcon: Icon(Icons.home_filled, size: 28),
              label: '',
            ),
            // Search — magnifying glass
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 28),
              activeIcon: Icon(Icons.search, size: 28),
              label: '',
            ),
            // Create — simple plus
            BottomNavigationBarItem(
              icon: Icon(Icons.add, size: 30),
              activeIcon: Icon(Icons.add, size: 30),
              label: '',
            ),
            // Messages — speech bubble
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 26),
              activeIcon: Icon(Icons.chat_bubble, size: 26),
              label: '',
            ),
            // Profile — person silhouette
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, size: 28),
              activeIcon: Icon(Icons.person, size: 28),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
