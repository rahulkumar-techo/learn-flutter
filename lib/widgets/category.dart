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

        final categoryList = snapshot.data?.categories ?? [];

        if (categoryList.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 38,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) =>
                notification.metrics.axis == Axis.horizontal,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              // ✅ FIXED: Prevents scroll interference with the main vertical viewport
              physics: const ClampingScrollPhysics(), 
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
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    // ✅ FIXED: Changed from Column to Row so the icon fits perfectly 
                    // within the 38px bounds without getting truncated out of view.
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (category.image != null && category.image!.isNotEmpty) ...[
                          Image.network(
                            category.image!,
                            width: 18,
                            height: 18,
                            fit: BoxFit.contain,
                            // ✅ FIXED: Now fits cleanly inside the Row structure
                            errorBuilder: (context, _, _) => const Icon(
                              Icons.category_rounded, 
                              size: 16,
                              color: Color(0xFF8A8A8E),
                            ),
                          ),
                          const SizedBox(width: 6), // Adds horizontal breathing space
                        ] else ...[
                          // ✅ Fallback if the image URL string itself is completely missing
                          const Icon(
                            Icons.category_rounded, 
                            size: 16,
                            color: Color(0xFF8A8A8E),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 13,
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
          ),
        );
      },
    );
  }
}
