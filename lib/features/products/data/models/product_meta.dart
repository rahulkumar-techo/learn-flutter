class ProductMeta {
  final String createdAt;
  final String updatedAt;
  final String barcode;
  final String qrCode;

  ProductMeta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  factory ProductMeta.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const <String, dynamic>{};

    return ProductMeta(
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      barcode: data['barcode'] ?? '',
      qrCode: data['qrCode'] ?? '',
    );
  }
}
