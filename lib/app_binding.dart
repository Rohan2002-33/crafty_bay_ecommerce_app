import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/cart_controller.dart';
import 'controllers/home_controller.dart';
import 'controllers/nav_controller.dart';
import 'controllers/order_controller.dart';
import 'controllers/wishlist_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Order matters: Cart, Wishlist and Order listen to Auth.
    Get.put(AuthController(), permanent: true);
    Get.put(NavController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
    Get.put(OrderController(), permanent: true);
  }
}