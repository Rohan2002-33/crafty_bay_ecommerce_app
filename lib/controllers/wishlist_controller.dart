import 'dart:convert';
import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_store.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
import '../data/data_sources/app_catalog.dart';
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
    _loadFromStorage();

    ever(Get.find<AuthController>().user, (u) {
      if (u != null) {
        load(silent: true);
      }
    });
  }

  void _loadFromStorage() {
    try {
      final saved = SessionStore.getSavedWishlist();
      if (saved != null && saved.isNotEmpty) {
        final decoded = jsonDecode(saved);
        if (decoded is List) {
          final loaded = decoded
              .map((e) => WishlistItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          if (loaded.isNotEmpty) {
            items.assignAll(loaded);
            return;
          }
        }
      }
    } catch (_) {}

    // Initial authentic reference UI items covering real categories
    if (items.isEmpty) {
      final initialProducts = [
        AppCatalog.getById('681372b57aff1010848eea4c') ?? AppCatalog.products[0], // Mac Mini M4
        AppCatalog.getById('elec_sony_headphones') ?? AppCatalog.products[1], // Sony Headphones
        AppCatalog.getById('fash_crafty_shoe_special') ?? AppCatalog.products[6], // Special Shoe
        AppCatalog.getById('6812554eea40bfc6edc673c1') ?? AppCatalog.products[10], // Recharge Battery Book
        AppCatalog.getById('elec_samsung_monitor') ?? AppCatalog.products[2], // Samsung Monitor
        AppCatalog.getById('elec_apple_watch') ?? AppCatalog.products[4], // Apple Watch
      ];

      items.assignAll(
        initialProducts.map((p) => WishlistItem(id: 'wish_${p.id}', product: p)).toList(),
      );
      _saveToStorage();
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final jsonList = items.map((i) => i.toJson()).toList();
      await SessionStore.saveWishlist(jsonEncode(jsonList));
    } catch (_) {}
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
        if (loaded.isNotEmpty) {
          final existingIds = items.map((i) => i.product.id).toSet();
          for (final serverItem in loaded) {
            if (!existingIds.contains(serverItem.product.id)) {
              items.add(serverItem);
              existingIds.add(serverItem.product.id);
            }
          }
          await _saveToStorage();
        }
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
      await _saveToStorage();
      AppSnack.success('Removed from Wish List');
      if (SessionStore.hasToken && existing.id.isNotEmpty && !existing.id.startsWith('wish_') && !existing.id.startsWith('local_')) {
        try {
          await ApiClient.delete(AppUrls.wishlistItem(existing.id));
        } catch (_) {}
      }
      return;
    }

    final newItem = WishlistItem(id: 'wish_${product.id}', product: product);
    items.insert(0, newItem);
    await _saveToStorage();
    AppSnack.success('Added to Wish List');

    if (SessionStore.hasToken) {
      try {
        final serverProductId = AppCatalog.resolveServerProductId(product.id);
        await ApiClient.post(
          AppUrls.wishlist,
          body: {'product': serverProductId},
        );
      } catch (_) {}
    }
  }
}
