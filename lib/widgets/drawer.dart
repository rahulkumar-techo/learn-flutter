import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  // Fixed the invalid constructor Key syntax to meet proper null-safety rules
  const MenuDrawer({super.key});

  final String profileImageUrl =
      'https://plus.unsplash.com/premium_photo-1739786996022-5ed5b56834e2?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cHJvZmlsZSUyMHBpY3R1cmV8ZW58MHwyfDB8fHww';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 280,
      backgroundColor: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header section
            // Remove the nested wrapping 'DrawerHeader' entirely and place this inside your Column children []

            // Place this directly as a child in your Column inside the Drawer
            UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              accountName: const Text('Rahul kumar'),
              accountEmail: Row(
                children: [
                  const Text('mrrhl02@gmail.com'),
                  const Spacer(), // Automatically pushes the icon to the far right edge
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 16.0,
                    ), // Keeps it clean from touching the side
                    child: Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),

              // make image in Oval or Circular
              currentAccountPicture: ClipOval(
                child: Image.network(
                  profileImageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  // 1. Manages smooth fading animation when the raw bytes load
                  gaplessPlayback: true,

                  // 2. Visual loader wrapper while bytes stream from network
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },

                  // 3. CRITICAL: Catches the 'unimplemented' data structure crash cleanly
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint(
                      "Image Loading Failed: $error",
                    ); // Logs out the exact asset issue safely
                    return Container(
                      color: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 45,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Standardizing your items with interactive, clickable ListTiles
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: const Icon(Icons.home_outlined),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context); // Closes the drawer smoothly
                // Handle item 1 routing here
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: const Icon(Icons.person_outline),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pop(context);
                // Handle item 2 routing here
              },
            ),
            ListTile(
              textColor: Colors.white,
              iconColor: Colors.white,
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                // Handle item 3 routing here
              },
            ),
          ],
        ),
      ),
    );
  }
}
