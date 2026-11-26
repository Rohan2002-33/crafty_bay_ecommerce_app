import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/nav_controller.dart';
import '../../controllers/order_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/order_model.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderController _c = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _c.load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Orders')),
      body: Obx(() {
        if (_c.isLoading.value && _c.orders.isEmpty) return const LoadingView();
        if (_c.errorMessage.value != null && _c.orders.isEmpty) {
          return ErrorState(message: _c.errorMessage.value!, onRetry: _c.load);
        }
        if (_c.orders.isEmpty) {
          return EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No orders yet',
            message: 'When you place an order it will show up here.',
            actionLabel: 'Start shopping',
            onAction: () {
              Get.find<NavController>().change(0);
              Get.until((route) => route.isFirst);
            },
          );
        }
        return RefreshIndicator(
          onRefresh: _c.load,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: _c.orders.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _OrderCard(order: _c.orders[i]),
          ),
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final firstImage = order.items.isNotEmpty ? order.items.first.image : '';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.to(() => OrderDetailsScreen(order: order)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                height: 64,
                child: AppNetworkImage(url: firstImage, radius: 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Order #${order.displayId}',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        OrderStatusChip(status: order.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      [
                        Formatters.date(order.createdAt),
                        if (order.itemCount > 0)
                          '${order.itemCount} item${order.itemCount > 1 ? 's' : ''}',
                      ].where((e) => e.isNotEmpty).join(' • '),
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      Formatters.price(order.total),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({super.key, required this.status});

  final String status;

  Color get _color {
    if (status.contains('cancel')) return AppColors.danger;
    switch (status) {
      case 'delivered':
        return AppColors.success;
      case 'shipped':
        return Colors.purple;
      case 'processing':
        return Colors.indigo;
      case 'confirmed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        Formatters.titleCase(status),
        style: TextStyle(
          color: _color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}