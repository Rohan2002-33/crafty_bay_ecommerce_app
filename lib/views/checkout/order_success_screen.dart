import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/models/order_model.dart';
import '../orders/orders_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  const OrderSuccessScreen({super.key, this.orderId, this.paid = false});

  final String? orderId;
  final bool paid;

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  OrderModel? _order;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  Future<void> _loadOrder() async {
    final id = widget.orderId;
    if (id == null) return;
    final order = await Get.find<OrderController>().fetchById(id);
    if (mounted) setState(() => _order = order);
  }

  void _goHome() => Get.offAllNamed('/main');

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 64,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Order Confirmed!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.paid
                      ? 'Payment received. Thank you for shopping with Crafty Bay.'
                      : 'Thank you! We have received your order and will contact you soon.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textGrey, height: 1.45),
                ),
                const SizedBox(height: 28),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      _row(
                        'Order ID',
                        order != null
                            ? '#${order.displayId}'
                            : (widget.orderId != null
                                ? '#${Formatters.shortId(widget.orderId!)}'
                                : '—'),
                      ),
                      if (order != null) ...[
                        _row('Status', Formatters.titleCase(order.status)),
                        _row('Total', Formatters.price(order.total)),
                      ],
                      _row('Payment', widget.paid ? 'Paid online' : 'Cash on Delivery'),
                    ],
                  ),
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'View My Orders',
                  onPressed: () {
                    Get.offAllNamed('/main');
                    Get.to(() => const OrdersScreen());
                  },
                ),
                const SizedBox(height: 4),
                TextButton(
                  onPressed: _goHome,
                  child: const Text('Continue Shopping'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: AppColors.textGrey)),
            const Spacer(),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
}