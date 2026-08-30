
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_app/widgets/drawer.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  /// Provides the active tab and handles switching between shell branches.
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavBar> createState() =>
      _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState
    extends State<ScaffoldWithNavBar> {
  bool _isBottomNavVisible = true;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      /// Listen to scroll direction from the current screen.
      onNotification: _handleScroll,

      child: Scaffold(
        drawer: const MenuDrawer(),

        /// Displays the currently selected StatefulShellRoute branch.
        body: widget.navigationShell,

        /// Bottom navigation hides on scroll down
        /// and appears again on scroll up.
        bottomNavigationBar: _AnimatedBottomNav(
          isVisible: _isBottomNavVisible,

          child: BottomNavigationBar(
            currentIndex:
                widget.navigationShell.currentIndex,

            /// Switch to the selected shell branch.
            onTap: _goToBranch,

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                activeIcon: Icon(Icons.school),
                label: 'Onboarding',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Switches between StatefulShellRoute tabs.
  ///
  /// Re-tapping the active tab returns to its initial location.
  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation:
          index == widget.navigationShell.currentIndex,
    );
  }

  /// Detects scroll direction:
  /// - Positive delta → scrolling down → hide navbar.
  /// - Negative delta → scrolling up → show navbar.
  bool _handleScroll(
    ScrollUpdateNotification notification,
  ) {
    final delta = notification.scrollDelta;

    if (delta == null || delta.abs() < 5) {
      return false;
    }

    // User scrolls down.
    if (delta > 0 && _isBottomNavVisible) {
      setState(() {
        _isBottomNavVisible = false;
      });
    }

    // User scrolls up.
    if (delta < 0 && !_isBottomNavVisible) {
      setState(() {
        _isBottomNavVisible = true;
      });
    }

    // Allow the notification to continue to other listeners.
    return false;
  }
}

/// Animates the bottom navigation visibility.
///
/// AnimatedSlide moves it vertically.
/// AnimatedOpacity provides a smoother transition.


class _AnimatedBottomNav extends StatelessWidget {
  const _AnimatedBottomNav({
    required this.isVisible,
    required this.child,
  });

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(
        end: isVisible ? 1.0 : 0.0,
      ),
      child: child,
      builder: (context, value, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,

            /// Shrinks the entire bottom navigation layout.
            heightFactor: value,

            child: Transform.translate(
              /// Adds a smooth slide-down effect.
              offset: Offset(0, 80 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
    );
  }
}

