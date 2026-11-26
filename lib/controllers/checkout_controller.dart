import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/utils/json_helper.dart';
import '../data/models/shipping_address_model.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import 'order_controller.dart';

enum PaymentMethod { cod, online }

extension PaymentMethodX on PaymentMethod {
  String get apiValue => this == PaymentMethod.cod ? 'cod' : 'ssl';
  String get title =>
      this == PaymentMethod.cod ? 'Cash on Delivery' : 'Online Payment';
  String get subtitle => this == PaymentMethod.cod
      ? 'Pay when your order arrives'
      : 'Cards, mobile banking & internet banking';
  IconData get icon => this == PaymentMethod.cod
      ? Icons.payments_outlined
      : Icons.credit_card_rounded;
}

class PlaceOrderResult {
  const PlaceOrderResult({
    required this.success,
    this.orderId,
    this.paymentUrl,
    this.error,
  });

  final bool success;
  final String? orderId;
  final String? paymentUrl;
  final String? error;
}

class CheckoutController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final postalCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  final Rx<PaymentMethod> paymentMethod = PaymentMethod.cod.obs;
  final RxBool isPlacing = false.obs;

  @override
  void onInit() {
    super.onInit();
    final user = Get.find<AuthController>().user.value;
    if (user != null) {
      nameCtrl.text = user.fullName;
      phoneCtrl.text = user.phone;
      cityCtrl.text = user.city;
      addressCtrl.text = user.address;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    cityCtrl.dispose();
    postalCtrl.dispose();
    addressCtrl.dispose();
    super.onClose();
  }

  ShippingAddress get _address => ShippingAddress(
        fullName: nameCtrl.text.trim(),
        address: addressCtrl.text.trim(),
        city: cityCtrl.text.trim(),
        postalCode: postalCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
      );

  Future<PlaceOrderResult> placeOrder() async {
    isPlacing.value = true;
    final online = paymentMethod.value == PaymentMethod.online;

    final res = await ApiClient.post(AppUrls.order, body: {
      'payment_method': paymentMethod.value.apiValue,
      'shipping_address': _address.toJson(),
      if (online) 'redirect_url': AppUrls.paymentRedirect,
    });
    isPlacing.value = false;

    if (!res.isSuccess) {
      return PlaceOrderResult(success: false, error: res.errorMessage);
    }

    return PlaceOrderResult(
      success: true,
      orderId: Json.findString(res.data, ['order_id', 'orderId', '_id', 'id']),
      paymentUrl: online
          ? Json.findPaymentUrl(res.data, exclude: AppUrls.paymentRedirect)
          : null,
    );
  }

  /// Refresh cart (server empties it) and order history after an order.
  Future<void> refreshAfterOrder() async {
    await Future.wait([
      Get.find<CartController>().load(silent: true),
      Get.find<OrderController>().load(),
    ]);
  }
}