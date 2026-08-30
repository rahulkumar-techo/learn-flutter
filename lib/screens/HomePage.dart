import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/product_response.dart';
import 'package:my_app/features/products/presentation/widgets/product_card.dart';
import 'package:my_app/features/products/services/product_service.dart';
import 'package:my_app/utils/header_delagate.dart';
// import 'package:my_app/widgets/drawer.dart';
import 'package:my_app/widgets/home_header.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<ProductResponse>? _productsFuture;

  /// Controls the product scroll position.
  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';
  String _currentSort = '';

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _searchFocusNode.addListener(() => setState(() {}));

    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = ProductService(ApiClient()).getProducts();
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(() {});
    _searchFocusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // Block route pop while the search field is focused so that the
    // Android back swipe only dismisses the keyboard instead of
    // navigating away from Homepage.
    return PopScope(
      canPop: !_searchFocusNode.hasFocus,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),

        child: Column(
          children: [
            /// Status bar background.
            Container(height: statusBarHeight, color: Colors.white),

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth >= 900
                      ? 4
                      : constraints.maxWidth >= 600
                      ? 3
                      : 2;

                  // Re-featch the data
                  return RefreshIndicator.adaptive(
                    edgeOffset: 0,

                    onRefresh: () async {
                      setState(() {
                        _loadProducts();
                      });
                    },

                    child: CustomScrollView(
                      controller: _scrollController,

                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,

                      /// Let Flutter use the platform's natural physics.
                      physics: const AlwaysScrollableScrollPhysics(),

                      slivers: [
                        SliverPersistentHeader(
                          floating: true,
                          pinned: false,

                          delegate: HeaderDelegate(
                            child: HomeHeader(
                              searchItem: _searchQuery,
                              sortItems: _currentSort,
                              searchFocusNode: _searchFocusNode,

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
                                      'Unable to load products.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final allProducts = snapshot.data?.products ?? [];

                            final query = _searchQuery.toLowerCase();

                            final filteredProducts = allProducts.where((
                              product,
                            ) {
                              return product.title.toLowerCase().contains(
                                query,
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
          ],
        ),
      ),
    );
  }
}
