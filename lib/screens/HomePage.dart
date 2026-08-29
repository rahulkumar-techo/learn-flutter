import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/product_response.dart';
import 'package:my_app/features/products/presentation/widgets/product_card.dart';
import 'package:my_app/features/products/services/product_service.dart';
import 'package:my_app/widgets/drawer.dart';
import 'package:my_app/widgets/home_header.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<ProductResponse>? _productsFuture;
  String _searchQuery = '';
  String _currentSort = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = ProductService(ApiClient()).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // Moving LayoutBuilder to the top allows CustomScrollView to stay alive
    // even while data loads, preventing focus loss in the Search bar.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // Change the status bar color.
        statusBarColor: Colors.black,

        // Dark icons for a light status bar.
        statusBarIconBrightness: Brightness.dark,

        // iOS icon brightness.
        statusBarBrightness: Brightness.light,
      ),

      child: Scaffold(
        drawer: const MenuDrawer(),
            backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 600
                  ? 3
                  : 2;

              return CustomScrollView(
                slivers: [
                  SliverPersistentHeader(
                    floating: true,
                    pinned: false,

                    delegate: _HomeHeaderDelegate(
                      child: HomeHeader(
                        searchItem: _searchQuery,
                        sortItems: _currentSort,
                        onSearchChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        onSortPressed: () {
                          // Implement your sorting state logic here
                          setState(() {
                            _currentSort = _currentSort == 'Price'
                                ? ''
                                : 'Price';
                          });
                        },
                      ),
                    ),
                  ),

                  FutureBuilder<ProductResponse>(
                    future: _productsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(
                                'Unable to load products.\n${snapshot.error}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }

                      // Apply filter updates safely locally across state changes
                      final allProducts = snapshot.data?.products ?? [];
                      final filteredProducts = allProducts.where((product) {
                        final title = product.title.toLowerCase();
                        return title.contains(_searchQuery.toLowerCase());
                      }).toList();

                      if (filteredProducts.isEmpty) {
                        return const SliverFillRemaining(
                          child: Center(child: Text('No products found.')),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.68,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return ProductCard(
                              product: filteredProducts[index],
                            );
                          }, childCount: filteredProducts.length),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _HomeHeaderDelegate({required this.child});

  static const double _height = 126;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: overlapsContent
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
