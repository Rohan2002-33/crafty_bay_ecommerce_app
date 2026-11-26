import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/order_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_network_image.dart';
import '../../data/models/order_model.dart';
import 'orders_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final OrderModel order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderController _controller = Get.find();
  late OrderModel _order = widget.order;
  bool _cancelling = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// List endpoint may skip line items, so load the full order.
  Future<void> _refresh() async {
    final fresh = await _controller.fetchById(widget.order.id);
    if (fresh != null && mounted) setState(() => _order = fresh);
  }

  Future<void> _cancel() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel order?'),
        content: const Text('This order will be cancelled. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Keep order'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _cancelling = true);
    final ok = await _controller.cancel(_order.id);
    if (!mounted) return;
    setState(() => _cancelling = false);
    if (ok) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Order #${order.displayId}')),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _card(
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order status',
                          style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        OrderStatusChip(status: order.status),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Placed on',
                        style: TextStyle(color: AppColors.textGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        Formatters.date(order.createdAt),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _title('Items'),
            _card(
              order.items.isEmpty
                  ? const Text(
                      'Item details are not available for this order.',
                      style: TextStyle(color: AppColors.textGrey),
                    )
                  : Column(
                      children: order.items
                          .map((i) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 52,
                                      height: 52,
                                      child: AppNetworkImage(url: i.image, radius: 8),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            i.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Qty ${i.quantity}',
                                            style: const TextStyle(
                                              color: AppColors.textGrey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (i.price > 0)
                                      Text(
                                        Formatters.price(i.price * i.quantity),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
            ),
            if (order.address != null) ...[
              _title('Shipping address'),
              _card(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.address!.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.address!.address}, ${order.address!.city} ${order.address!.postalCode}',
                    style: const TextStyle(color: AppColors.textGrey, height: 1.4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.address!.phone,
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                ],
              )),
            ],
            _title('Payment'),
            _card(Column(
              children: [
                _row('Method', order.isOnline ? 'Online Payment' : 'Cash on Delivery'),
                if (order.paymentStatus.isNotEmpty)
                  _row('Payment status', Formatters.titleCase(order.paymentStatus)),
                const Divider(height: 24),
                _row('Total', Formatters.price(order.total), bold: true),
              ],
            )),
            if (order.canCancel) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: _cancelling ? null : _cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: const BorderSide(color: AppColors.danger),
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _cancelling
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Cancel Order'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _title(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      );

  Widget _card(Widget child) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      );

  Widget _row(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: AppColors.textGrey)),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                fontSize: bold ? 17 : 14,
                color: bold ? AppColors.primary : AppColors.textDark,
              ),
            ),
          ],
        ),
      );
}