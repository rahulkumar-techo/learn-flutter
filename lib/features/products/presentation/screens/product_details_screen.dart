import 'package:flutter/material.dart';
import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/features/products/data/models/product_response.dart';
import 'package:my_app/features/products/presentation/widgets/meta_info.dart';
import 'package:my_app/features/products/presentation/widgets/review_card.dart';
import 'package:my_app/features/products/services/product_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final Future<Product> _productDetailsFuture;

  @override
  void initState() {
    super.initState();
    _productDetailsFuture = ProductService(ApiClient())
        .getProductDetails(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(title: const Text("Product Details"), centerTitle: true),
      body: FutureBuilder<Product>(
        future: _productDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return _MessageState(
              icon: Icons.error_outline,
              title: 'Unable to load product details',
              message: snapshot.error.toString(),
            );
          }

          final product = snapshot.data;

          if (product == null) {
            return const _MessageState(
              icon: Icons.inventory_2_outlined,
              title: 'Product details not found',
              message: 'Please go back and select another product.',
            );
          }

          return ProductDetailsContent(product: product);
        },
      ),
    );
  }
}

class ProductDetailsContent extends StatelessWidget {
  final Product product;

  const ProductDetailsContent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        ProductImageGallery(
          thumbnail: product.thumbnail,
          images: product.images,
        ),
        const SizedBox(height: 18),
        ProductSummary(product: product),
        const SizedBox(height: 14),
        ProductDescription(description: product.description),
        const SizedBox(height: 14),
        ProductInfoGrid(product: product),
        const SizedBox(height: 18),
        MetaInfo(metaData: product.meta),
        const SizedBox(height: 18),
        Reviews(product: product),
      ],
    );
  }
}

class ProductImageGallery extends StatefulWidget {
  final String thumbnail;
  final List<String> images;

  const ProductImageGallery({
    super.key,
    required this.thumbnail,
    required this.images,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late final PageController _pageController;
  late final List<String> _galleryImages;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _galleryImages = widget.images.isEmpty ? [widget.thumbnail] : widget.images;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _galleryImages.length,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  child: Image.network(
                    _galleryImages[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey,
                          size: 42,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                );
              },
            ),
          ),
        ),
        if (_galleryImages.length > 1) ...[
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _galleryImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Theme.of(context).primaryColor
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class ProductSummary extends StatelessWidget {
  final Product product;

  const ProductSummary({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _SectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (product.brand.isNotEmpty) _Pill(label: product.brand),
              _Pill(label: product.category),
              _Pill(label: product.availabilityStatus),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            product.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _RatingBadge(rating: product.rating),
            ],
          ),
          if (product.discountPercentage > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${product.discountPercentage.toStringAsFixed(1)}% discount applied',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return _SectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: Icons.notes_outlined, title: 'Description'),
          const SizedBox(height: 10),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: Colors.grey.shade800, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class ProductInfoGrid extends StatelessWidget {
  final Product product;

  const ProductInfoGrid({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final dimensions = product.dimensions;

    return _SectionSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.local_shipping_outlined,
            title: 'Product Info',
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _InfoTile(
                icon: Icons.inventory_2_outlined,
                label: 'Stock',
                value: '${product.stock} left',
              ),
              _InfoTile(
                icon: Icons.verified_outlined,
                label: 'Warranty',
                value: product.warrantyInformation,
              ),
              _InfoTile(
                icon: Icons.local_shipping_outlined,
                label: 'Shipping',
                value: product.shippingInformation,
              ),
              _InfoTile(
                icon: Icons.assignment_return_outlined,
                label: 'Returns',
                value: product.returnPolicy,
              ),
              _InfoTile(
                icon: Icons.scale_outlined,
                label: 'Weight',
                value: '${product.weight} kg',
              ),
              _InfoTile(
                icon: Icons.straighten_outlined,
                label: 'Size',
                value:
                    '${dimensions.width.toStringAsFixed(1)} x ${dimensions.height.toStringAsFixed(1)} x ${dimensions.depth.toStringAsFixed(1)}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Reviews extends StatelessWidget {
  final Product product;

  const Reviews({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(icon: Icons.rate_review_outlined, title: 'Reviews'),
        const SizedBox(height: 10),
        SizedBox(
          height: 178,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.reviews.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = product.reviews[index];
              final review = ProductReview(
                rating: item.rating,
                comment: item.comment,
                date: DateTime.parse(item.date),
                reviewerName: item.reviewerName,
                reviewerEmail: item.reviewerEmail,
              );

              final reviewWidth =
                  MediaQuery.sizeOf(context).width.clamp(320, 520).toDouble() *
                  0.84;

              return SizedBox(
                width: reviewWidth,
                child: ReviewCard(review: review),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionSurface extends StatelessWidget {
  final Widget child;

  const _SectionSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;

    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;

  const _Pill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  final double rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth >= 520
            ? (constraints.maxWidth - 10) / 2
            : constraints.maxWidth;

        return SizedBox(
          width: tileWidth,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value.isEmpty ? 'Not available' : value,
                        style: TextStyle(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 42, color: Theme.of(context).primaryColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
