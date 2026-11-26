import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/nav_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/quantity_stepper.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/cart_item_model.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cart'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (cart.isLoading.value && cart.items.isEmpty) return const LoadingView();
        if (cart.errorMessage.value != null && cart.items.isEmpty) {
          return ErrorState(message: cart.errorMessage.value!, onRetry: cart.load);
        }
        if (cart.items.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_basket_outlined,
            title: 'Your cart is empty',
            message: 'Looks like you have not added anything yet.',
            actionLabel: 'Start shopping',
            onAction: () => Get.find<NavController>().change(0),
          );
        }
        return RefreshIndicator(
          onRefresh: cart.load,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: cart.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _CartItemTile(item: cart.items[i]),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        if (cart.items.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
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
                    Formatters.price(cart.total),
                    style: const TextStyle(
                      fontSize: 20,
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
                  onPressed: () => Get.to(() => const CheckoutScreen()),
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: AppNetworkImage(url: item.product.thumbnail, radius: 10),
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          height: 1.25,
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
                      Formatters.price(item.lineTotal),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
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