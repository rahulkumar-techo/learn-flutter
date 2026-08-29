class ApiEndpoints {
  static const baseUrl = 'https://dummyjson.com';
  static const products = "/products";
  static const categoriesUrl = "$products/categories";

  static String singleProductUrl(int productId) {
    return '$products/$productId';
  }

  static String recommendedProductsUrl(String category) {
    return '$products/category/$category';
  }

  static String getUri(String endpoint) => '$baseUrl$endpoint';
  // static const login = "/auth/login";
}
