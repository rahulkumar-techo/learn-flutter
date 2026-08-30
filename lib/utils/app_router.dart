import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:my_app/screens/homePage.dart';
import 'package:my_app/screens/onboarding_screen.dart';
import 'package:my_app/utils/routes.dart';
import 'package:my_app/utils/scaffold_nav_bar.dart';

final _homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'home',
);

final _onboardingNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'onboarding',
);

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    /// Detail screen is outside the shell.
    /// Bottom navigation will not be shown here.
    GoRoute(
      path: CustomRoutes.productDetailsRoute,
      name: 'productDetails',
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
              builder: (context, state) => Homepage(),
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
              builder: (context, state) => OnboardingScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);