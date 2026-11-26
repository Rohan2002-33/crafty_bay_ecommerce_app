import '../../core/utils/json_helper.dart';
import '../data_sources/app_catalog.dart';
import 'product_model.dart';

class WishlistItem {
  const WishlistItem({required this.id, required this.product});

  final String id;
  final Product product;

  factory WishlistItem.fromJson(Map<String, dynamic> j) {
    final raw = j['product'];
    final product = raw is Map
        ? AppCatalog.sanitize(Product.fromJson(Json.map(raw)))
        : (AppCatalog.getById(Json.str(raw)) ?? Product.idOnly(Json.str(raw)));
    return WishlistItem(
      id: Json.id(j),
      product: product,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
      };
}
