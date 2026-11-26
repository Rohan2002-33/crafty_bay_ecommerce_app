import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/nav_controller.dart';
import '../../controllers/wishlist_controller.dart';
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
  final CartController _cart = Get.find();

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
            bottomNavigationBar: NavigationBar(
              selectedIndex: _nav.index.value,
              onDestinationSelected: _nav.change,
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Categories',
                ),
                NavigationDestination(
                  icon: Badge(
                    isLabelVisible: _cart.itemCount > 0,
                    label: Text('${_cart.itemCount}'),
                    child: const Icon(Icons.shopping_basket_outlined),
                  ),
                  selectedIcon: const Icon(Icons.shopping_basket_rounded),
                  label: 'Cart',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.favorite_border_rounded),
                  selectedIcon: Icon(Icons.favorite_rounded),
                  label: 'Wish',
                ),
              ],
            ),
          ),
        ));
  }
}