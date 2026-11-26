import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_store.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
import '../data/models/product_model.dart';
import '../data/models/wishlist_item_model.dart';
import 'auth_controller.dart';

class WishlistController extends GetxController {
  final RxList<WishlistItem> items = <WishlistItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<AuthController>().user, (u) {
      if (u == null) items.clear();
    });
  }

  bool isWished(String productId) => items.any((i) => i.product.id == productId);

  Future<void> load({bool silent = false}) async {
    if (!SessionStore.hasToken) return;
    if (!silent) isLoading.value = true;
    errorMessage.value = null;

    final res = await ApiClient.get('${AppUrls.wishlist}?count=100');
    if (res.isSuccess) {
      items.assignAll(Json.maps(res.data).map(WishlistItem.fromJson));
    } else if (!silent || items.isEmpty) {
      errorMessage.value = res.errorMessage;
    }
    isLoading.value = false;
  }

  Future<void> toggle(Product product) async {
    final existing = items.firstWhereOrNull((i) => i.product.id == product.id);

    if (existing != null) {
      items.remove(existing);
      final res = await ApiClient.delete(AppUrls.wishlistItem(existing.id));
      if (!res.isSuccess) {
        items.add(existing);
        AppSnack.error(res.errorMessage);
      }
      return;
    }

    items.add(WishlistItem(id: '', product: product)); // optimistic
    final res = await ApiClient.post(
      AppUrls.wishlist,
      body: {'product': product.id},
    );
    if (res.isSuccess) {
      await load(silent: true); // pick up the real wishlist item id
    } else {
      items.removeWhere((i) => i.product.id == product.id);
      AppSnack.error(res.errorMessage);
    }
  }
}