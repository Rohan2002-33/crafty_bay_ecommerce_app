import '../../core/utils/json_helper.dart';
import '../data_sources/app_catalog.dart';
import 'product_model.dart';

class CartItem {
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    this.color = '',
    this.size = '',
  });

  final String id;
  final Product product;
  final int quantity;
  final double unitPrice;
  final String color;
  final String size;

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        id: id,
        product: product,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice,
        color: color,
        size: size,
      );

  factory CartItem.fromJson(Map<String, dynamic> j) {
    final raw = j['product'];
    final product = raw is Map
        ? AppCatalog.sanitize(Product.fromJson(Json.map(raw)))
        : (AppCatalog.getById(Json.str(raw)) ?? Product.idOnly(Json.str(raw)));
    final unit = product.currentPrice > 0
        ? product.currentPrice
        : Json.dbl(j['price'] ?? j['unit_price'] ?? j['unitPrice']);
    return CartItem(
      id: Json.id(j),
      product: product,
      quantity: Json.integer(j['quantity'], 1),
      unitPrice: unit > 0 ? unit : 100.0,
      color: Json.str(j['color']),
      size: Json.str(j['size']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'product': product.toJson(),
        'quantity': quantity,
        'unitPrice': unitPrice,
        'color': color,
        'size': size,
      };
}