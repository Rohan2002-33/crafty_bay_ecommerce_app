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
      if (u == null) {
        // guest mode can keep local items
      } else {
        load(silent: true);
      }
    });
  }

  bool isWished(String productId) => items.any((i) => i.product.id == productId);

  Future<void> load({bool silent = false}) async {
    if (!SessionStore.hasToken) return;
    if (!silent) isLoading.value = true;
    errorMessage.value = null;

    try {
      final res = await ApiClient.get('${AppUrls.wishlist}?count=100');
      if (res.isSuccess && res.data != null) {
        final loaded = Json.maps(res.data).map(WishlistItem.fromJson).toList();
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

  Future<void> toggle(Product product) async {
    final existing = items.firstWhereOrNull((i) => i.product.id == product.id);

    if (existing != null) {
      items.remove(existing);
      if (SessionStore.hasToken && existing.id.isNotEmpty && !existing.id.startsWith('local_')) {
        final res = await ApiClient.delete(AppUrls.wishlistItem(existing.id));
        if (!res.isSuccess) {
          items.add(existing);
          AppSnack.error(res.errorMessage);
        }
      }
      return;
    }

    items.add(WishlistItem(id: 'local_${product.id}', product: product));
    if (SessionStore.hasToken) {
      final res = await ApiClient.post(
        AppUrls.wishlist,
        body: {'product': product.id},
      );
      if (res.isSuccess) {
        await load(silent: true);
      } else {
        AppSnack.error(res.errorMessage);
      }
    }
  }
}
