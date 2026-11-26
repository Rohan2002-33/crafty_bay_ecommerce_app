import '../../core/utils/json_helper.dart';
import 'product_model.dart';

class WishlistItem {
  const WishlistItem({required this.id, required this.product});

  final String id;
  final Product product;

  factory WishlistItem.fromJson(Map<String, dynamic> j) {
    final raw = j['product'];
    return WishlistItem(
      id: Json.id(j),
      product: raw is Map
          ? Product.fromJson(Json.map(raw))
          : Product.idOnly(Json.str(raw)),
    );
  }
}