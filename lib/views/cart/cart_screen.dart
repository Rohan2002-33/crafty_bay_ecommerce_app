import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/nav_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/storage/session_store.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../data/data_sources/app_catalog.dart';
import '../../data/models/cart_item_model.dart';
import '../auth/login_screen.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  List<CartItem> _getDemoItems() {
    final shoe = AppCatalog.getById('fash_crafty_shoe_special') ?? AppCatalog.products.first;
    final mac = AppCatalog.getById('681372b57aff1010848eea4c') ?? AppCatalog.products[0];
    final book = AppCatalog.getById('6812554eea40bfc6edc673c1') ?? AppCatalog.products[10];
    return [
      CartItem(
        id: 'cart_demo_shoe',
        product: shoe,
        quantity: 1,
        unitPrice: shoe.currentPrice > 0 ? shoe.currentPrice : 100.0,
        color: 'Red',
        size: '42',
      ),
      CartItem(
        id: 'cart_demo_mac',
        product: mac,
        quantity: 1,
        unitPrice: mac.currentPrice > 0 ? mac.currentPrice : 699.0,
        color: 'Space Gray',
        size: '512GB',
      ),
      CartItem(
        id: 'cart_demo_book',
        product: book,
        quantity: 1,
        unitPrice: book.currentPrice > 0 ? book.currentPrice : 10.0,
        color: 'Hardcover',
        size: 'Standard',
      ),
    ];
  }

  void _handleCheckout(BuildContext context) {
    final cart = Get.find<CartController>();
    if (cart.items.isEmpty) {
      cart.items.assignAll(_getDemoItems());
    }
    if (!SessionStore.hasToken) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 36),
              ),
              const SizedBox(height: 16),
              const Text(
                'Sign In & Complete Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'To place an order and proceed with online payment, please enter your email and complete your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, height: 1.4),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Complete Profile / Sign In',
                onPressed: () async {
                  Get.back();
                  final loggedIn = await Get.to(() => const LoginScreen(redirectToCheckout: true));
                  if (loggedIn == true || SessionStore.hasToken) {
                    Get.to(() => const CheckoutScreen());
                  }
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
      return;
    }
    Get.to(() => const CheckoutScreen());
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.find<NavController>().change(0),
        ),
      ),
      body: Obx(() {
        final items = cart.items.isNotEmpty ? cart.items : _getDemoItems();
        return RefreshIndicator(
          onRefresh: cart.load,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(14),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _CartItemTile(item: items[i]),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final items = cart.items.isNotEmpty ? cart.items : _getDemoItems();
        final total = cart.items.isNotEmpty
            ? cart.total
            : items.fold(0.0, (s, e) => s + e.lineTotal * 1000);
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Price',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    cart.items.isNotEmpty
                        ? Formatters.price(total)
                        : '\$100,000.00',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Expanded(
                child: PrimaryButton(
                  label: 'Checkout',
                  onPressed: () => _handleCheckout(context),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final options = [
      if (item.color.isNotEmpty) 'Color: ${item.color}',
      if (item.size.isNotEmpty) 'Size: ${item.size}',
    ].join(', ');

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AppNetworkImage(
              url: item.product.thumbnail,
              fit: BoxFit.contain,
              fallbackAsset: (item.product.title.toLowerCase().contains('shoe') ||
                      item.product.photos.any((p) => p.contains('shoe')))
                  ? AppAssets.shoe
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => cart.remove(item),
                      child: const Padding(
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 20,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ),
                  ],
                ),
                if (options.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      options,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      Formatters.price(item.lineTotal > 0 ? item.lineTotal : 100),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    QuantityStepper(
                      value: item.quantity,
                      onChanged: (v) => cart.updateQuantity(item, v),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
