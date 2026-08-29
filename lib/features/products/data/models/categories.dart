class CategoriesModal {
  final String slug;
  final String name;
  final String image;

  CategoriesModal({
    required this.slug,
    required this.name,
    required this.image,
  });

  factory CategoriesModal.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const <String, dynamic>{};

    return CategoriesModal(
      slug: data['slug'] ?? "",
      name: data['name'] ?? "",
      image: data['image'] ?? "",
    );
  }
}

class CategoriesModalResponse {
  final List<CategoriesModal> categories;

  CategoriesModalResponse({required this.categories});

  factory CategoriesModalResponse.fromJson(dynamic json) {
    return CategoriesModalResponse(
      categories: (json as List? ?? [])
          .whereType<Map<String, dynamic>>()
          .map(CategoriesModal.fromJson)
          .toList(),
    );
  }
}
