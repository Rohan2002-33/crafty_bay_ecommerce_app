import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
import '../data/data_sources/app_catalog.dart';
import '../data/models/product_model.dart';
import 'cart_controller.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController(this.productId);

  final String productId;

  final Rxn<Product> product = Rxn<Product>();
  final RxBool isLoading = true.obs;
  final RxBool isAdding = false.obs;
  final RxnString errorMessage = RxnString();
  final RxString selectedColor = ''.obs;
  final RxString selectedSize = ''.obs;
  final RxInt quantity = 1.obs;

  @override
  void onInit() {
    super.onInit();
    // Immediate catalog lookup for instantaneous, accurate display
    final catalogProduct = AppCatalog.getById(productId);
    if (catalogProduct != null) {
      _applyProduct(catalogProduct);
      isLoading.value = false;
    }
    load();
  }

  void _applyProduct(Product p) {
    product.value = p;
    if (p.colors.isNotEmpty && selectedColor.value.isEmpty) {
      selectedColor.value = p.colors.first;
    }
    if (p.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      selectedSize.value = p.sizes.first;
    }
  }

  Future<void> load() async {
    // If it's a known catalog product ID, ensure it's loaded
    final catalogProduct = AppCatalog.getById(productId);
    if (catalogProduct != null) {
      _applyProduct(catalogProduct);
      isLoading.value = false;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final res = await ApiClient.get(AppUrls.productById(productId));
      if (res.isSuccess && res.data != null) {
        final json = Json.extractMap(res.data, keys: const ['data', 'product']);
        final loaded = AppCatalog.sanitize(Product.fromJson(json));
        _applyProduct(loaded);
      } else if (product.value == null) {
        // Fallback search in catalog by id or title
        final fallback = AppCatalog.getById(productId) ?? AppCatalog.products.first;
        _applyProduct(fallback);
      }
    } catch (_) {
      if (product.value == null) {
        final fallback = AppCatalog.getById(productId) ?? AppCatalog.products.first;
        _applyProduct(fallback);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart() async {
    final current = product.value;
    if (current == null) return;

    if (current.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      selectedSize.value = current.sizes.first;
    }

    isAdding.value = true;
    await Get.find<CartController>().add(
      current,
      quantity: quantity.value,
      color: selectedColor.value,
      size: selectedSize.value,
    );
    isAdding.value = false;
  }
}
