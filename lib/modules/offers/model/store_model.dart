class StoreModel {
  final String id;
  final String name;
  final String monogram;
  final String searchUrl;
  final bool featured;

  const StoreModel({
    required this.id,
    required this.name,
    required this.monogram,
    required this.searchUrl,
    required this.featured,
  });

  /// Link to the product search on the store's website.
  String linkFor(String query) => searchUrl.replaceAll('{q}', Uri.encodeComponent(query));

  bool get hasSearch => searchUrl.contains('{q}');

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      monogram: json['monogram'] as String,
      searchUrl: json['searchUrl'] as String,
      featured: json['featured'] as bool? ?? false,
    );
  }
}
