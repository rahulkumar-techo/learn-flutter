class Dimensions {
  final double width;
  final double height;
  final double depth;

  Dimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory Dimensions.fromJson(Map<String, dynamic>? json) {
    final data = json ?? const <String, dynamic>{};

    return Dimensions(
      width: (data['width'] as num?)?.toDouble() ?? 0,
      height: (data['height'] as num?)?.toDouble() ?? 0,
      depth: (data['depth'] as num?)?.toDouble() ?? 0,
    );
  }
}
