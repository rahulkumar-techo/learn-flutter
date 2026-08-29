import 'package:go_router/go_router.dart';
import 'package:my_app/features/products/presentation/screens/product_details_screen.dart';
import 'package:my_app/screens/HomePage.dart';
import 'package:my_app/utils/routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) {
        // state ===>like path,query,params etc..
        return Homepage();
      },
    ),

    GoRoute(path: CustomRoutes.productDetailsRoute,name: 'Product Detils',
    builder: (context, state) {
      final productIdString  = state.pathParameters['productId'];
      final productId = int.tryParse(productIdString ?? '') ?? 0; 
       return ProductDetailsScreen(productId: productId); 
    },
    )
  ],
);
