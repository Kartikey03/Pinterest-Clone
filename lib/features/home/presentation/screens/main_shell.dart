import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../profile/presentation/providers/uploaded_pins_provider.dart';

/// Root scaffold with bottom navigation bar.
///
/// 5 tabs matching the real Pinterest app:
/// Home, Search, Create (+), Messages, Profile.
/// Labels are hidden — icon-only nav bar like the real app.
class MainShell extends ConsumerWidget {
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

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRouter.home);
        break;
      case 1:
        context.goNamed(AppRouter.search);
        break;
      case 2:
        _pickAndUpload(context, ref);
        break;
      case 3:
        context.goNamed(AppRouter.inbox);
        break;
      case 4:
        context.goNamed(AppRouter.profile);
        break;
    }
  }

  void _pickAndUpload(BuildContext context, WidgetRef ref) async {
    final success =
        await ref.read(uploadedPinsProvider.notifier).pickAndUpload();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Pin uploaded successfully!' : 'Upload cancelled',
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onTap: (index) => _onTap(context, ref, index),
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
