import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_store.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
import '../data/models/cart_item_model.dart';
import '../data/models/product_model.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final RxList<CartItem> items = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  double get total => items.fold(0.0, (sum, i) => sum + i.lineTotal);
  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<AuthController>().user, (u) {
      if (u != null) {
        syncLocalCartToServer();
        load(silent: true);
      }
    });
  }

  Future<void> load({bool silent = false}) async {
    if (!SessionStore.hasToken) return;
    if (!silent) isLoading.value = true;
    errorMessage.value = null;

    try {
      final res = await ApiClient.get('${AppUrls.cart}?count=100');
      if (res.isSuccess && res.data != null) {
        final loaded = Json.maps(res.data).map(CartItem.fromJson).toList();
        if (loaded.isNotEmpty) items.assignAll(loaded);
      } else if (!silent && items.isEmpty) {
        errorMessage.value = res.errorMessage;
      }
    } catch (_) {
      // offline support
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> syncLocalCartToServer() async {
    if (!SessionStore.hasToken) return;
    for (final item in items) {
      // If it's a real server item, skip
      if (!item.id.startsWith('cart_') && item.id.length > 10) continue;
      try {
        await ApiClient.post(AppUrls.cart, body: {
          'product': item.product.id,
          'quantity': item.quantity,
          if (item.color.isNotEmpty) 'color': item.color,
          if (item.size.isNotEmpty) 'size': item.size,
        });
      } catch (_) {}
    }
  }

  Future<bool> add(
    Product product, {
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    final existingIndex = items.indexWhere(
      (i) => i.product.id == product.id && i.color == (color ?? '') && i.size == (size ?? ''),
    );

    if (existingIndex != -1) {
      final existing = items[existingIndex];
      items[existingIndex] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      items.add(CartItem(
        id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        unitPrice: product.currentPrice > 0 ? product.currentPrice : 100.0,
        color: color ?? '',
        size: size ?? '',
      ));
    }

    if (SessionStore.hasToken) {
      try {
        await ApiClient.post(AppUrls.cart, body: {
          'product': product.id,
          'quantity': quantity,
          if (color != null && color.isNotEmpty) 'color': color,
          if (size != null && size.isNotEmpty) 'size': size,
        });
        await load(silent: true);
      } catch (_) {}
    }

    AppSnack.success('Added to cart');
    return true;
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    items[index] = item.copyWith(quantity: quantity); // optimistic
    if (SessionStore.hasToken && !item.id.startsWith('cart_')) {
      final res = await ApiClient.patch(
        AppUrls.cartItem(item.id),
        body: {'quantity': quantity},
      );
      if (!res.isSuccess) {
        items[index] = item; // roll back
        AppSnack.error(res.errorMessage);
      }
    }
  }

  Future<void> remove(CartItem item) async {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    items.removeAt(index);
    if (SessionStore.hasToken && !item.id.startsWith('cart_')) {
      final res = await ApiClient.delete(AppUrls.cartItem(item.id));
      if (!res.isSuccess) {
        items.insert(index, item);
        AppSnack.error(res.errorMessage);
      }
    }
  }
}
