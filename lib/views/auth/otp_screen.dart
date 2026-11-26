import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack.dart';
import '../../core/widgets/primary_button.dart';
import 'signup_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.email,
    required this.password,
    this.redirectToCheckout = false,
  });

  final String email;
  final String password;
  final bool redirectToCheckout;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  static const int _expirySeconds = 120;

  final _pin = PinInputController();
  final AuthController _auth = Get.find();
  Timer? _timer;
  int _remaining = _expirySeconds;

  @override
  void initState() {
    super.initState();
    _startTimer(reset: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pin.dispose();
    super.dispose();
  }

  void _startTimer({bool reset = true}) {
    _timer?.cancel();
    if (reset) {
      setState(() => _remaining = _expirySeconds);
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _remaining = (_remaining - 1).clamp(0, 999));
    });
  }

  Future<void> _verify() async {
    if (_pin.text.length != 4) {
      AppSnack.error('Enter the 4 digit OTP code');
      return;
    }
    FocusScope.of(context).unfocus();

    final result = await _auth.verifyOtpCode(
      email: widget.email,
      otp: _pin.text,
      password: widget.password,
    );
    if (!mounted) return;

    if (result == OtpResult.verifiedExistingUser) {
      AppSnack.success('Logged in successfully!');
      if (widget.redirectToCheckout) {
        Get.back(result: true);
      } else {
        Get.offAllNamed('/main');
      }
    } else if (result == OtpResult.needsProfileCompletion) {
      // Proceed directly to Screen 12: Complete Profile!
      Get.off(
        () => SignUpScreen(
          initialEmail: widget.email,
          redirectToCheckout: widget.redirectToCheckout,
        ),
      );
    } else {
      _pin.clear();
      AppSnack.error('Invalid OTP code. Please use default code 1234');
    }
  }

  Future<void> _resend() async {
    await _auth.initiateEmailVerification(widget.email);
    if (!mounted) return;
    _startTimer();
    AppSnack.success('A new OTP code has been sent (Default: 1234)');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const SizedBox(height: 10),
              SvgPicture.asset(
                AppAssets.logo,
                width: 100,
                placeholderBuilder: (_) => Image.asset(AppAssets.logo, width: 100),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter OTP Code',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'A 4 Digit OTP Code has been Sent',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
              const SizedBox(height: 28),
              MaterialPinField(
                length: 4,
                pinController: _pin,
                keyboardType: TextInputType.number,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(52, 52),
                  borderRadius: BorderRadius.circular(10),
                  borderColor: AppColors.border,
                  focusedBorderColor: AppColors.primary,
                  filledBorderColor: AppColors.primary,
                  entryAnimation: MaterialPinAnimation.fade,
                ),
                onCompleted: (_) => _verify(),
              ),
              const SizedBox(height: 20),
              Obx(
                () => PrimaryButton(
                  label: 'Next',
                  isLoading: _auth.isLoading.value,
                  onPressed: _verify,
                ),
              ),
              const SizedBox(height: 24),
              if (_remaining > 0)
                Text.rich(
                  TextSpan(
                    text: 'This code will expire in ',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                    children: [
                      TextSpan(
                        text: '${_remaining}s',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Text(
                  'The code has expired',
                  style: TextStyle(color: AppColors.danger, fontSize: 13),
                ),
              Obx(
                () => TextButton(
                  onPressed: _remaining == 0 && !_auth.isLoading.value ? _resend : null,
                  child: _auth.isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Resend Code',
                          style: TextStyle(fontSize: 13, color: AppColors.primary),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
