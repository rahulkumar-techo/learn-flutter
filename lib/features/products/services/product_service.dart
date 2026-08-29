import 'package:my_app/core/network/api_client.dart';
import 'package:my_app/core/network/api_endpoints.dart';
import 'package:my_app/features/products/data/models/product_response.dart';

class ProductService {
  final ApiClient apiClient;

  ProductService(this.apiClient);

  Future<ProductResponse> getProducts() async {
    final response = await apiClient.get(ApiEndpoints.products);

    return ProductResponse.fromJson(response as Map<String, dynamic>);
  }

  // Return the details view of a single Item
  Future<Product> getProductDetails(int productId) async {
    final response = await apiClient.get(
      ApiEndpoints.singleProductUrl(productId),
    );

    return Product.fromJson(response as Map<String, dynamic>);
  }

  Future<ProductResponse> getRecommendedItems(String category) async {
    final response = await apiClient.get(
      ApiEndpoints.recommendedProductsUrl(category),
    );
    return ProductResponse.fromJson(response as Map<String, dynamic>);
  }
}
