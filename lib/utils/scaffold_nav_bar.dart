import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_app/widgets/drawer.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

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
      // ✅ Intercepts scroll signals safely
      onNotification: _handleScroll,

      child: Scaffold(
        drawer: const MenuDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: _AnimatedBottomNav(
          isVisible: _isBottomNavVisible,
          child: BottomNavigationBar(
            currentIndex: widget.navigationShell.currentIndex,
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

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  /// Detects scroll direction
  bool _handleScroll(ScrollUpdateNotification notification) {
    // ✅ FIX 1: Explicitly check that the notification is coming from the main vertical axis (depth == 0)
    // This immediately stops horizontal list views (like Categories) from triggering setState().
    if (notification.metrics.axis != Axis.vertical || notification.depth != 0) {
      return false;
    }

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

    return false;
  }
}

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
            heightFactor: value,
            child: Transform.translate(
              offset: Offset(0, 80 * (1 - value)),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
