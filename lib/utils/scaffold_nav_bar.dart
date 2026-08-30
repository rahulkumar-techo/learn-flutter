import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/widgets/drawer.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  bool _isBottomNavVisible = true;

  /// How much the user must scroll before
  /// showing or hiding the navigation bar.
  static const double _scrollThreshold = 40;

  /// Stores accumulated scroll movement.
  double _scrollDelta = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        /// delta is null when Flutter cannot calculate
        /// the scroll movement.
        final delta = notification.scrollDelta;

        if (delta == null) {
          return false;
        }

        /// Ignore very tiny movements.
        if (delta.abs() < 1) {
          return false;
        }

        /// User scrolls DOWN.
        ///
        /// Positive delta normally means content
        /// is moving upward / user is scrolling down.
        if (delta > 0) {
          _scrollDelta += delta;

          /// Reset opposite direction accumulation.
          if (_scrollDelta < 0) {
            _scrollDelta = delta;
          }

          /// Hide only after meaningful scrolling.
          if (_scrollDelta >= _scrollThreshold && _isBottomNavVisible) {
            setState(() {
              _isBottomNavVisible = false;
            });

            _scrollDelta = 0;
          }
        }
        /// User scrolls UP.
        else {
          _scrollDelta += delta;

          /// Reset opposite direction accumulation.
          if (_scrollDelta > 0) {
            _scrollDelta = delta;
          }

          /// Show only after meaningful scrolling.
          if (_scrollDelta <= -_scrollThreshold && !_isBottomNavVisible) {
            setState(() {
              _isBottomNavVisible = true;
            });

            _scrollDelta = 0;
          }
        }

        return false;
      },

      child: Scaffold(
        drawer: const MenuDrawer(),
        body: widget.navigationShell,

        bottomNavigationBar: _AnimatedBottomNav(
          isVisible: _isBottomNavVisible,
          child: _buildBottomNav(),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Material(
      color: Colors.white,
      elevation: 8,
      child: SafeArea(
        // top: false,
        // Navigation bar button 
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: InkWell(
            
            onTap: () {
              widget.navigationShell.goBranch(0);
            },
            child: const SizedBox(
              height: 52,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(Icons.home), SizedBox(width: 8),
                       Text('Home')
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedBottomNav extends StatelessWidget {
  const _AnimatedBottomNav({required this.isVisible, required this.child});

  final bool isVisible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,

      tween: Tween<double>(end: isVisible ? 1 : 0),

      child: child,

      builder: (context, value, child) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,

            /// Removes layout space smoothly.
            heightFactor: value,

            child: Transform.translate(
              /// Slides down smoothly.
              offset: Offset(0, 64 * (1 - value)),

              child: child,
            ),
          ),
        );
      },
    );
  }
}
