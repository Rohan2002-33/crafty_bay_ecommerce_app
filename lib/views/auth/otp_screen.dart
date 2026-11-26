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

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.email, required this.password});

  final String email;
  final String password;

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
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pin.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remaining = _expirySeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 1) {
        t.cancel();
      }
      if (mounted) setState(() => _remaining = (_remaining - 1).clamp(0, 999));
    });
  }

  Future<void> _verify() async {
    if (_pin.text.length != 4) {
      AppSnack.error('Enter the 4 digit code');
      return;
    }
    FocusScope.of(context).unfocus();
    final ok = await _auth.verifyOtp(
      email: widget.email,
      otp: _pin.text,
      password: widget.password,
    );
    if (!mounted) return;

    if (ok) {
      Get.offAllNamed('/main');
    } else {
      _pin.clear();
      AppSnack.error(_auth.lastError);
    }
  }

  Future<void> _resend() async {
    final ok = await _auth.resendOtp(widget.email);
    if (!mounted) return;
    if (ok) {
      _startTimer();
      AppSnack.success('A new code has been sent');
    } else {
      AppSnack.error(_auth.lastError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SvgPicture.asset(AppAssets.logo, width: 90),
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
              Text(
                'A 4 digit OTP code has been sent to\n${widget.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textGrey, height: 1.4),
              ),
              const SizedBox(height: 28),
              MaterialPinField(
                length: 4,
                pinController: _pin,
                keyboardType: TextInputType.number,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  cellSize: const Size(54, 54),
                  borderRadius: BorderRadius.circular(10),
                  borderColor: AppColors.border,
                  focusedBorderColor: AppColors.primary,
                  filledBorderColor: AppColors.primary,
                  entryAnimation: MaterialPinAnimation.fade,
                ),
                onCompleted: (_) => _verify(),
              ),
              const SizedBox(height: 16),
              Obx(
                () => PrimaryButton(
                  label: 'Next',
                  isLoading: _auth.isLoading.value,
                  onPressed: _verify,
                ),
              ),
              const SizedBox(height: 28),
              if (_remaining > 0)
                Text.rich(
                  TextSpan(
                    text: 'This code will expire in ',
                    style: const TextStyle(color: AppColors.textGrey),
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
                  style: TextStyle(color: AppColors.danger),
                ),
              TextButton(
                onPressed: _remaining == 0 ? _resend : null,
                child: const Text('Resend Code'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
