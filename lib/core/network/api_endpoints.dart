class ApiEndpoints {
  static const baseUrl = 'https://dummyjson.com';
  static const products = "/products";

  static String singleProductUrl(int productId) {
    return '$products/$productId';
  }

  static String getUri(String endpoint) => '$baseUrl$endpoint';
  // static const login = "/auth/login";
}
