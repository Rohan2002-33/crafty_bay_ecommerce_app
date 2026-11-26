import '../../core/utils/json_helper.dart';

class Product {
  const Product({
    required this.id,
    required this.title,
    this.slug = '',
    this.description = '',
    this.brand = '',
    this.photos = const [],
    this.colors = const [],
    this.sizes = const [],
    this.tags = const [],
    this.currentPrice = 0,
    this.regularPrice = 0,
    this.rating = 0,
  });

  final String id;
  final String title;
  final String slug;
  final String description;
  final String brand;
  final List<String> photos;
  final List<String> colors;
  final List<String> sizes;
  final List<String> tags;
  final double currentPrice;
  final double regularPrice;
  final double rating;

  String get thumbnail => photos.isEmpty ? '' : photos.first;
  bool get hasDiscount => regularPrice > currentPrice && currentPrice > 0;

  factory Product.idOnly(String id) => Product(id: id, title: 'Product');

  factory Product.fromJson(Map<String, dynamic> j) {
    List<String> strings(dynamic v) => Json.list(v)
        .map((e) => e is Map ? Json.str(e['url']) : Json.str(e))
        .where((e) => e.isNotEmpty)
        .toList();

    final brandRaw = j['brand'];
    return Product(
      id: Json.id(j),
      title: Json.str(j['title'] ?? j['name'], 'Untitled product'),
      slug: Json.str(j['slug']),
      description: Json.str(j['description']),
      brand: brandRaw is Map ? Json.str(brandRaw['title']) : '',
      photos: strings(j['photos']),
      colors: strings(j['colors']),
      sizes: strings(j['sizes']),
      tags: strings(j['tags']),
      currentPrice: Json.dbl(j['current_price']),
      regularPrice: Json.dbl(j['regular_price']),
      rating: Json.dbl(j['rating'] ?? j['average_rating'] ?? j['avg_rating']),
    );
  }
}