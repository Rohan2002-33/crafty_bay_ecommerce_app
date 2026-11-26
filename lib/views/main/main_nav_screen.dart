import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/nav_controller.dart';
import '../../controllers/wishlist_controller.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../cart/cart_screen.dart';
import '../categories/categories_screen.dart';
import '../home/home_screen.dart';
import '../wishlist/wishlist_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  final NavController _nav = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<HomeController>().load();
      Get.find<CartController>().load();
      Get.find<WishlistController>().load();
      final auth = Get.find<AuthController>();
      if (auth.user.value == null) auth.fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PopScope(
          canPop: _nav.index.value == 0,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _nav.change(0);
          },
          child: Scaffold(
            body: IndexedStack(
              index: _nav.index.value,
              children: const [
                HomeScreen(),
                CategoriesScreen(),
                CartScreen(),
                WishlistScreen(),
              ],
            ),
            bottomNavigationBar: const AppBottomNavBar(),
          ),
        ));
  }
}
