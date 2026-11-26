import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/checkout_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_urls.dart';
import '../../core/utils/app_snack.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/primary_button.dart';
import '../orders/orders_screen.dart';
import 'order_success_screen.dart';
import 'payment_webview_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late final CheckoutController _c;
  final CartController _cart = Get.find();

  @override
  void initState() {
    super.initState();
    _c = Get.put(CheckoutController());
  }

  @override
  void dispose() {
    Get.delete<CheckoutController>();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    FocusScope.of(context).unfocus();
    if (!_c.formKey.currentState!.validate()) return;
    if (_cart.items.isEmpty) {
      AppSnack.error('Your cart is empty');
      return;
    }

    final result = await _c.placeOrder();
    if (!mounted) return;

    if (!result.success) {
      AppSnack.error(result.error ?? 'Could not place the order');
      return;
    }

    if (_c.paymentMethod.value == PaymentMethod.online) {
      final url = result.paymentUrl;
      if (url == null) {
        await _c.refreshAfterOrder();
        AppSnack.error('Order placed, but no payment link was returned. Check My Orders.');
        Get.off(() => const OrdersScreen());
        return;
      }

      final payment = await Get.to<PaymentResult>(
        () => PaymentWebViewScreen(
          paymentUrl: url,
          redirectUrl: AppUrls.paymentRedirect,
        ),
      );
      await _c.refreshAfterOrder();
      if (!mounted) return;

      if (payment == PaymentResult.success) {
        Get.offAll(() => OrderSuccessScreen(orderId: result.orderId, paid: true));
      } else {
        AppSnack.error(payment == PaymentResult.failed
            ? 'Payment failed. You can retry from My Orders.'
            : 'Payment cancelled. Your order is saved in My Orders.');
        Get.off(() => const OrdersScreen());
      }
      return;
    }

    await _c.refreshAfterOrder();
    Get.offAll(() => OrderSuccessScreen(orderId: result.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Shipping address'),
                _card(Column(
                  children: [
                    _field(_c.nameCtrl, 'Full Name',
                        validator: (v) => Validators.required(v, 'Full name')),
                    _field(_c.phoneCtrl, 'Phone',
                        type: TextInputType.phone, validator: Validators.phone),
                    Row(
                      children: [
                        Expanded(
                          child: _field(_c.cityCtrl, 'City',
                              validator: (v) => Validators.required(v, 'City')),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(_c.postalCtrl, 'Postal Code',
                              type: TextInputType.number,
                              validator: (v) =>
                                  Validators.required(v, 'Postal code')),
                        ),
                      ],
                    ),
                    _field(_c.addressCtrl, 'Full Address',
                        lines: 3,
                        last: true,
                        validator: (v) => Validators.required(v, 'Address')),
                  ],
                )),
                _sectionTitle('Payment method'),
                Obx(() => Column(
                      children: PaymentMethod.values
                          .map((m) => _PaymentTile(
                                method: m,
                                selected: _c.paymentMethod.value == m,
                                onTap: () => _c.paymentMethod.value = m,
                              ))
                          .toList(),
                    )),
                _sectionTitle('Order summary'),
                _card(Obx(() => Column(
                      children: [
                        ..._cart.items.map((i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${i.product.title} × ${i.quantity}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    Formatters.price(i.lineTotal),
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            )),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              Formatters.price(_cart.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ))),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: const BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: SafeArea(
          top: false,
          child: Obx(() => PrimaryButton(
                label: _c.paymentMethod.value == PaymentMethod.online
                    ? 'Pay ${Formatters.price(_cart.total)}'
                    : 'Place Order • ${Formatters.price(_cart.total)}',
                isLoading: _c.isPlacing.value,
                onPressed: _placeOrder,
              )),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
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

  Widget _field(
    TextEditingController controller,
    String hint, {
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
    int lines = 1,
    bool last = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 12),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        validator: validator,
        textInputAction: last ? TextInputAction.done : TextInputAction.next,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(method.icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.subtitle,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.primary : AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}