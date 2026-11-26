import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/primary_button.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final AuthController _auth = Get.find();
  bool _usePassword = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();

    if (_usePassword) {
      final res = await _auth.login(email, _password.text);
      if (!mounted) return;
      if (res == LoginResult.success) {
        Get.offAllNamed('/main');
        return;
      } else if (res == LoginResult.failed) {
        AppSnack.error(_auth.lastError);
        return;
      }
    }

    // Default flow matching Reference UI: Email -> OTP -> Main / Complete Profile
    final otpSent = await _auth.resendOtp(email);
    if (!mounted) return;

    if (otpSent) {
      AppSnack.success('Verification code sent. Default OTP is 1234');
    }

    Get.to(
      () => OtpScreen(
        email: email,
        password: _password.text.isNotEmpty ? _password.text : 'CraftyBay@123',
        initialOtpSendFailed: !otpSent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppAssets.logo,
                    width: 125,
                    placeholderBuilder: (_) => Image.asset(AppAssets.logo, width: 125),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please Enter Your Email Address',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: _usePassword ? TextInputAction.next : TextInputAction.done,
                    validator: Validators.email,
                    onFieldSubmitted: (_) => !_usePassword ? _submit() : null,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                  if (_usePassword) ...[
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscure,
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            size: 20,
                            color: AppColors.textGrey,
                          ),
                          onPressed: () => setState(() => _obscure = !_obscure),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Obx(
                    () => PrimaryButton(
                      label: 'Next',
                      isLoading: _auth.isLoading.value,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _usePassword = !_usePassword),
                        child: Text(
                          _usePassword ? 'Use OTP Login instead' : 'Sign in with password',
                          style: const TextStyle(fontSize: 13, color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => Get.offAllNamed('/main'),
                    child: const Text(
                      'Skip for now (Browse as Guest)',
                      style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
