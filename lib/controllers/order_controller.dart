import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_store.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
import '../data/models/order_model.dart';
import 'auth_controller.dart';

class OrderController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  @override
  void onInit() {
    super.onInit();
    ever(Get.find<AuthController>().user, (u) {
      if (u == null) orders.clear();
    });
  }

  Future<void> load() async {
    if (!SessionStore.hasToken) return;
    isLoading.value = true;
    errorMessage.value = null;

    final res = await ApiClient.get('${AppUrls.orders}?count=50');
    if (res.isSuccess) {
      final list = Json.maps(res.data).map(OrderModel.fromJson).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      orders.assignAll(list);
    } else {
      errorMessage.value = res.errorMessage;
    }
    isLoading.value = false;
  }

  Future<OrderModel?> fetchById(String id) async {
    final res = await ApiClient.get(AppUrls.orderById(id));
    if (!res.isSuccess) return null;
    return OrderModel.fromJson(
      Json.extractMap(res.data, keys: const ['data', 'order']),
    );
  }

  Future<bool> cancel(String id) async {
    final res = await ApiClient.patch(AppUrls.cancelOrder(id));
    if (!res.isSuccess) {
      AppSnack.error(res.errorMessage);
      return false;
    }
    AppSnack.success('Order cancelled');
    await load();
    return true;
  }
}