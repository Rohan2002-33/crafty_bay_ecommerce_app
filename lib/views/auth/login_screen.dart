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
import 'signup_screen.dart';

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
    final password = _password.text;
    final result = await _auth.login(email, password);
    if (!mounted) return;

    switch (result) {
      case LoginResult.success:
        Get.offAllNamed('/main');
      case LoginResult.needsVerification:
        final otpSent = await _auth.resendOtp(email);
        if (!mounted) return;
        if (otpSent) {
          AppSnack.success('Verification code sent. Check your email.');
        } else {
          AppSnack.error(_auth.lastError);
        }
        Get.to(
          () => OtpScreen(
            email: email,
            password: password,
            initialOtpSendFailed: !otpSent,
          ),
        );
      case LoginResult.failed:
        AppSnack.error(_auth.lastError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SvgPicture.asset(AppAssets.logo, width: 110),
                  const SizedBox(height: 28),
                  const Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Please enter your email and password',
                    style: TextStyle(color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 28),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: Validators.email,
                    decoration: const InputDecoration(
                      hintText: 'Email Address',
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: Validators.password,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => PrimaryButton(
                      label: 'Sign In',
                      isLoading: _auth.isLoading.value,
                      onPressed: _submit,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => const SignUpScreen()),
                        child: const Text('Sign Up'),
                      ),
                    ],
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
