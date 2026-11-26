import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/constants/app_colors.dart';

enum PaymentResult { success, failed, cancelled }

class PaymentWebViewScreen extends StatefulWidget {
  const PaymentWebViewScreen({
    super.key,
    required this.paymentUrl,
    required this.redirectUrl,
  });

  final String paymentUrl;
  final String redirectUrl;

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController _web;
  int _progress = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _web = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) setState(() => _progress = p);
          },
          onNavigationRequest: (request) {
            final result = _resolve(request.url);
            if (result != null) {
              _finish(result);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  /// Decide the transaction outcome from the URL the gateway sends us to.
  PaymentResult? _resolve(String url) {
    final lower = url.toLowerCase();
    final isRedirect = lower.startsWith(widget.redirectUrl.toLowerCase());
    final looksCancelled = lower.contains('cancel');
    final looksFailed = lower.contains('fail');

    if (looksCancelled) return PaymentResult.cancelled;
    if (looksFailed) return PaymentResult.failed;
    if (isRedirect || lower.contains('success') || lower.contains('val_id')) return PaymentResult.success;
    return null;
  }

  void _finish(PaymentResult result) {
    if (_finished) return;
    _finished = true;
    Get.back(result: result);
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel payment?'),
        content: const Text('Your order will stay in My Orders as unpaid.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue paying'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Cancel payment'),
          ),
        ],
      ),
    );
    if (leave == true) _finish(PaymentResult.cancelled);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Secure Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _confirmExit,
          ),
          bottom: _progress < 100
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(3),
                  child: LinearProgressIndicator(
                    value: _progress / 100,
                    minHeight: 3,
                  ),
                )
              : null,
        ),
        body: WebViewWidget(controller: _web),
      ),
    );
  }
}