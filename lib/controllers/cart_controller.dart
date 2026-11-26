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
      if (u == null) items.clear();
    });
  }

  Future<void> load({bool silent = false}) async {
    if (!SessionStore.hasToken) return;
    if (!silent) isLoading.value = true;
    errorMessage.value = null;

    final res = await ApiClient.get('${AppUrls.cart}?count=100');
    if (res.isSuccess) {
      items.assignAll(Json.maps(res.data).map(CartItem.fromJson));
    } else if (!silent || items.isEmpty) {
      errorMessage.value = res.errorMessage;
    }
    isLoading.value = false;
  }

  Future<bool> add(
    Product product, {
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    final res = await ApiClient.post(AppUrls.cart, body: {
      'product': product.id,
      'quantity': quantity,
      if (color != null && color.isNotEmpty) 'color': color,
      if (size != null && size.isNotEmpty) 'size': size,
    });
    if (!res.isSuccess) {
      AppSnack.error(res.errorMessage);
      return false;
    }
    AppSnack.success('Added to cart');
    await load(silent: true);
    return true;
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    items[index] = item.copyWith(quantity: quantity); // optimistic
    final res = await ApiClient.patch(
      AppUrls.cartItem(item.id),
      body: {'quantity': quantity},
    );
    if (!res.isSuccess) {
      items[index] = item; // roll back
      AppSnack.error(res.errorMessage);
    }
  }

  Future<void> remove(CartItem item) async {
    final index = items.indexWhere((i) => i.id == item.id);
    if (index == -1) return;

    items.removeAt(index);
    final res = await ApiClient.delete(AppUrls.cartItem(item.id));
    if (!res.isSuccess) {
      items.insert(index, item);
      AppSnack.error(res.errorMessage);
    }
  }
}