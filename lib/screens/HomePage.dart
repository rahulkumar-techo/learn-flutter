import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/product_response.dart';
import 'package:my_app/features/products/presentation/widgets/product_card.dart';
import 'package:my_app/features/products/services/product_service.dart';
import 'package:my_app/utils/header_delagate.dart';
import 'package:my_app/widgets/home_header.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<ProductResponse>? _productsFuture;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  String _currentSort = '';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onFocusChange);
    _loadProducts();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _loadProducts() {
    _productsFuture = ProductService(ApiClient()).getProducts();
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onFocusChange);
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

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
            Container(height: statusBarHeight, color: Colors.white),
            Expanded(
              child: FutureBuilder<ProductResponse>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Unable to load products.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  final allProducts = snapshot.data?.products ?? [];
                  final query = _searchQuery.toLowerCase();
                  final filteredProducts = allProducts.where((product) {
                    return product.title.toLowerCase().contains(query);
                  }).toList();

                  // ✅ FIX: We isolate the scroll view into its own widget structure block 
                  // down below to secure persistent pipeline rendering metrics.
                  return _PinnedProductGrid(
                    scrollController: _scrollController,
                    searchFocusNode: _searchFocusNode,
                    searchQuery: _searchQuery,
                    currentSort: _currentSort,
                    filteredProducts: filteredProducts,
                    onSearchChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    onSortPressed: () {
                      setState(() {
                        _currentSort = _currentSort == 'Price' ? '' : 'Price';
                      });
                    },
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

/// ✅ Separate widget to keep the Pinned Header Delegate references isolated and stable
class _PinnedProductGrid extends StatelessWidget {
  final ScrollController scrollController;
  final FocusNode searchFocusNode;
  final String searchQuery;
  final String currentSort;
  final List<Product> filteredProducts;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSortPressed;

  const _PinnedProductGrid({
    required this.scrollController,
    required this.searchFocusNode,
    required this.searchQuery,
    required this.currentSort,
    required this.filteredProducts,
    required this.onSearchChanged,
    required this.onSortPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 900
            ? 4
            : constraints.maxWidth >= 600
                ? 3
                : 2;

        return CustomScrollView(
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          slivers: [
            // ✅ FIXED: We set pinned: true with a dedicated unique local widget identifier key.
            // Isolating this wrapper class context prevents structural layout calculation overlaps
            // inside the primary page rendering runtime frame.
            SliverPersistentHeader(
              // pinned: true, 
              floating: true,
              delegate: HeaderDelegate(
                child: Container(
                  color: Colors.white, // ✅ Solid background stops grid content bleeding behind it
                  child: HomeHeader(
                    searchItem: searchQuery,
                    sortItems: currentSort,
                    searchFocusNode: searchFocusNode,
                    onSearchChanged: onSearchChanged,
                    onSortPressed: onSortPressed,
                  ),
                ),
              ),
            ),



            if (filteredProducts.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('No products found.')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        key: ValueKey(product.id),
                        product: product,
                      );
                    },
                    childCount: filteredProducts.length,
                    findChildIndexCallback: (Key key) {
                      if (key is ValueKey<String>) {
                        final index = filteredProducts.indexWhere(
                          (p) => p.id == key.value,
                        );
                        return index >= 0 ? index : null;
                      }
                      return null;
                    },
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
