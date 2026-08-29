import 'package:flutter/material.dart';
import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/product_response.dart';
import 'package:my_app/features/products/presentation/widgets/product_card.dart';
import 'package:my_app/features/products/services/product_service.dart';

class RecommendedProducts extends StatefulWidget {
  final String category;

  const RecommendedProducts({super.key, required this.category});

  @override
  State<RecommendedProducts> createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
  late final Future<ProductResponse> _productCategoryFuture;

  @override
  void initState() {
    super.initState();
    _productCategoryFuture = ProductService(ApiClient())
        .getRecommendedItems(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.category.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Products',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          child: FutureBuilder<ProductResponse>(
            future: _productCategoryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Unable to load recommended products.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                );
              }

              final categoryProducts = snapshot.data?.products ?? [];

              if (categoryProducts.isEmpty) {
                return const Center(child: Text('No products found.'));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryProducts.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 180,
                    child: ProductCard(product: categoryProducts[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
