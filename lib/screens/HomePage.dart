import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/product_response.dart';
import 'package:my_app/features/products/presentation/widgets/product_card.dart';
import 'package:my_app/features/products/services/product_service.dart';
import 'package:my_app/utils/header_delagate.dart';
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
    // Obtain the precise system height occupied by the native status bar notch
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        //  Changed to white background
        statusBarColor: Colors.white,

        //  Dark icons for a light status bar background
        statusBarIconBrightness: Brightness.dark,

        //  iOS text icon brightness matching (light theme mode)
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        drawer: const MenuDrawer(),
        body: Column(
          children: [
            //  This forces an explicit white background behind the status bar notch area
            Container(height: statusBarHeight, color: Colors.white),
            Expanded(
              child: SafeArea(
                top: false, //  Prevents SafeArea from blanking out or fighting the status bar area
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth >= 900
                        ? 4
                        : constraints.maxWidth >= 600
                        ? 3
                        : 2;

                    return RefreshIndicator(
                      edgeOffset: 0,
                      onRefresh: () async {
                        setState(() {
                          _loadProducts();
                        });
                      },
                      child: CustomScrollView(
                        // Always listens to gestures but prevents the grid items from stretching
                        physics: const ClampingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        slivers: [
                          SliverPersistentHeader(
                            floating: true,
                            pinned: false,
                            delegate: HeaderDelegate(
                              child: HomeHeader(
                                searchItem: _searchQuery,
                                sortItems: _currentSort,
                                onSearchChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                                onSortPressed: () {
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
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
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

                              final allProducts = snapshot.data?.products ?? [];
                              final filteredProducts = allProducts.where((
                                product,
                              ) {
                                final title = product.title.toLowerCase();
                                return title.contains(
                                  _searchQuery.toLowerCase(),
                                );
                              }).toList();

                              if (filteredProducts.isEmpty) {
                                return const SliverFillRemaining(
                                  child: Center(
                                    child: Text('No products found.'),
                                  ),
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
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
