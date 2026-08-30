import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:my_app/screens/homePage.dart';
import 'package:my_app/utils/routes.dart';
import 'package:my_app/utils/scaffold_nav_bar.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'homeNav',
);

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Product details stays outside the tab shell, so it opens without tabs.
    GoRoute(
      path: CustomRoutes.productDetailsRoute,
      name: 'productDetails',
      builder: (context, state) {
        final productIdString = state.pathParameters['productId'];
        final productId = int.tryParse(productIdString ?? '') ?? 0;
        return ProductDetailsScreen(productId: productId);
      },
    ),

    // Routes inside this shell are wrapped by ScaffoldWithNavBar, which is
    // where the bottom tab bar is created.
    StatefulShellRoute.indexedStack(
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: <RouteBase>[
            GoRoute(
              // This is the app's initial route. Keeping it inside the shell
              // makes the bottom tab bar visible on Homepage.
              path: '/',
              name: 'home',
              builder: (context, state) {
                return Homepage();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
