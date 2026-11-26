import '../../core/utils/formatters.dart';
import '../../core/utils/json_helper.dart';
import 'shipping_address_model.dart';

class OrderItem {
  const OrderItem({
    required this.title,
    required this.image,
    required this.quantity,
    required this.price,
  });

  final String title;
  final String image;
  final int quantity;
  final double price;

  factory OrderItem.fromJson(Map<String, dynamic> j) {
    final p = Json.map(j['product']);
    final photos = Json.list(p['photos']);
    return OrderItem(
      title: Json.str(j['title'] ?? p['title'] ?? j['name'], 'Product'),
      image: photos.isNotEmpty ? Json.str(photos.first) : Json.str(j['photo']),
      quantity: Json.integer(j['quantity'], 1),
      price: Json.dbl(
        j['price'] ?? j['unit_price'] ?? j['current_price'] ?? p['current_price'],
      ),
    );
  }
}

class OrderModel {
  const OrderModel({
    required this.id,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.createdAt,
    required this.total,
    required this.items,
    this.address,
  });

  final String id;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String createdAt;
  final double total;
  final List<OrderItem> items;
  final ShippingAddress? address;

  String get displayId => Formatters.shortId(id);
  bool get isCancelled => status.contains('cancel');
  bool get canCancel => status == 'pending' || status == 'confirmed';
  bool get isOnline => paymentMethod.toLowerCase() == 'ssl';
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  factory OrderModel.fromJson(Map<String, dynamic> j) {
    final rawItems =
        Json.list(j['items'] ?? j['products'] ?? j['order_items'] ?? j['cart_items']);
    final items = rawItems
        .whereType<Map>()
        .map((e) => OrderItem.fromJson(Json.map(e)))
        .toList();

    var total = Json.dbl(j['total'] ??
        j['total_amount'] ??
        j['total_price'] ??
        j['amount'] ??
        j['grand_total']);
    if (total == 0) {
      total = items.fold(0.0, (sum, i) => sum + i.price * i.quantity);
    }

    final addr = j['shipping_address'];
    return OrderModel(
      id: Json.id(j),
      status: Json.str(j['status'], 'pending').toLowerCase(),
      paymentMethod: Json.str(j['payment_method']),
      paymentStatus: Json.str(j['payment_status'] ?? j['paymentStatus']),
      createdAt: Json.str(j['createdAt'] ?? j['created_at']),
      total: total,
      items: items,
      address: addr is Map ? ShippingAddress.fromJson(Json.map(addr)) : null,
    );
  }
}