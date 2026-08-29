import 'package:flutter/material.dart';
import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/categories.dart';
import 'package:my_app/features/products/services/product_service.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<CategoriesModalResponse>? _categories;

  @override
  void initState() {
    super.initState();

    _loadCategories();
  }

  void _loadCategories() {
    _categories = ProductService(ApiClient()).getCategoriesItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categories,
      builder: (context, snapshot) {
        // Display Indicator while loading data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 40,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const SizedBox.shrink();
        }

        // Adjust this mapping path depending on how your actual CategoriesModalResponse is structured
        final categoryList = snapshot.data?.categories ?? [];

        if (categoryList.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemCount: categoryList.length,

            itemBuilder: (context, index) {
              final category = categoryList[index];

              return InkWell(
                onTap: () {
                  // Handle filtering items by category.slug here
                },

                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // Renders remote networks image smoothly; defaults safely if missing
                      if (category.image.isNotEmpty) ...[
                        Image.network(
                          category.image,
                          width: 20,
                          height: 20,
                          errorBuilder: (context, _, __) =>
                              const Icon(Icons.category_rounded, size: 16),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C1E),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
// child: FutureBuilder<ProductResponse>(
