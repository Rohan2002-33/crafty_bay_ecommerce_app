import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
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
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    errorMessage.value = null;

    final res = await ApiClient.get(AppUrls.productById(productId));
    if (res.isSuccess) {
      final json = Json.extractMap(res.data, keys: const ['data', 'product']);
      final loaded = Product.fromJson(json);
      product.value = loaded;
      selectedColor.value = loaded.colors.isNotEmpty ? loaded.colors.first : '';
      selectedSize.value = loaded.sizes.isNotEmpty ? loaded.sizes.first : '';
    } else {
      errorMessage.value = res.errorMessage;
    }
    isLoading.value = false;
  }

  Future<void> addToCart() async {
    final current = product.value;
    if (current == null) return;

    if (current.sizes.isNotEmpty && selectedSize.value.isEmpty) {
      AppSnack.error('Please select a size');
      return;
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