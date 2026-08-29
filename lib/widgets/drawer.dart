import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  // Profile image URL.
  static const String profileImageUrl =
      'https://plus.unsplash.com/premium_photo-1739786996022-5ed5b56834e2'
      '?w=600&auto=format&fit=crop&q=60';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,

      // Main drawer background.
      // backgroundColor: Colors.white,

      child: SafeArea(
        child: Column(
          children: [
            // =========================
            // USER PROFILE HEADER
            // =========================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),

              decoration: const BoxDecoration(
                // color: Colors.white,

                // Adds a subtle border below the profile section.
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFEAEAEA),
                  ),
                ),
              ),

              child: Row(
                children: [
                  // =========================
                  // PROFILE IMAGE
                  // =========================
                  ClipOval(
                    child: Image.network(
                      profileImageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,

                      // Display loader while the image loads.
                      loadingBuilder: (
                        context,
                        child,
                        loadingProgress,
                      ) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFFF5F5F7),
                          alignment: Alignment.center,
                          child: const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },

                      // Show fallback avatar if image loading fails.
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          width: 56,
                          height: 56,
                          color: const Color(0xFFF5F5F7),
                          child: const Icon(
                            Icons.person_outline,
                            size: 30,
                            color: Color(0xFF8A8A8E),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(width: 14),

                  // =========================
                  // USER INFORMATION
                  // =========================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rahul Kumar',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1C1C1E),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'mrrhl02@gmail.com',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF8A8A8E),
                                ),
                              ),
                            ),

                            const SizedBox(width: 4),

                            const Icon(
                              Icons.verified_rounded,
                              size: 16,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =========================
            // DRAWER MENU
            // =========================
            const SizedBox(height: 12),

            _DrawerItem(
              icon: Icons.home_outlined,
              title: 'Home',
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            _DrawerItem(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                Navigator.pop(context);

                // Navigate to profile screen here.
              },
            ),

            _DrawerItem(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () {
                Navigator.pop(context);

                // Navigate to settings screen here.
              },
            ),

            const Spacer(),

            // =========================
            // BOTTOM SECTION
            // =========================
            const Divider(
              height: 1,
              color: Color(0xFFEAEAEA),
            ),

            _DrawerItem(
              icon: Icons.logout_rounded,
              title: 'Logout',
              isLogout: true,
              onTap: () {
                // Handle logout here.
              },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}


// ==========================================
// REUSABLE DRAWER MENU ITEM
// ==========================================

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  // Indicates the currently active page.
  final bool isSelected;

  // Used for special actions such as logout.
  final bool isLogout;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isSelected = false,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    // Use red styling only for destructive actions.
    final Color itemColor = isLogout
        ? Colors.red
        : const Color(0xFF1C1C1E);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),

      child: Material(
        color: isSelected
            ? const Color(0xFFF5F5F7)
            : Colors.transparent,

        borderRadius: BorderRadius.circular(12),

        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : itemColor,
                ),

                const SizedBox(width: 16),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : itemColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

