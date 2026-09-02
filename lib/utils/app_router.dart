import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:my_app/screens/homePage.dart';
import 'package:my_app/screens/onboarding_screen.dart';
import 'package:my_app/utils/routes.dart';
import 'package:my_app/utils/scaffold_nav_bar.dart';

// ✅ Restructure by containing the keys explicitly or providing a dedicated root key 
// to prevent shell tree state collisions during active inner view rebuilds.
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final GlobalKey<NavigatorState> _onboardingNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'onboarding');

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey, // ✅ Explicitly define the parent anchor

  routes: [
    /// Detail screen is outside the shell.
    /// Bottom navigation will not be shown here.
    GoRoute(
      path: CustomRoutes.productDetailsRoute,
      name: 'productDetails',
      parentNavigatorKey: _rootNavigatorKey, // ✅ Force details to build on root, separating its lifecycles
      builder: (context, state) {
        final productId =
            int.tryParse(state.pathParameters['productId'] ?? '') ?? 0;

        return ProductDetailsScreen(productId: productId);
      },
    ),

    /// Main application tabs.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(
          navigationShell: navigationShell,
        );
      },

      branches: [
        /// TAB 0 — Home
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => const Homepage(), // ✅ Use const constructor if applicable
            ),
          ],
        ),

        /// TAB 1 — Onboarding
        StatefulShellBranch(
          navigatorKey: _onboardingNavigatorKey,
          routes: [
            GoRoute(
              path: '/onboarding',
              name: 'onboarding',
              builder: (context, state) => const OnboardingScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
