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

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final AuthController _auth = Get.find();
  bool _obscure = true;

  @override
  void dispose() {
    for (final c in [
      _firstName,
      _lastName,
      _email,
      _password,
      _phone,
      _city,
      _address,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _email.text.trim();
    final ok = await _auth.signup(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: email,
      password: _password.text,
      phone: _phone.text.trim(),
      city: _city.text.trim(),
      address: _address.text.trim(),
    );
    if (!mounted) return;

    if (!ok) {
      AppSnack.error(_auth.lastError);
      return;
    }

    final otpSent = await _auth.resendOtp(email);
    if (!mounted) return;

    if (otpSent) {
      AppSnack.success('Verification code sent. Check your email.');
    } else {
      AppSnack.error(
        'Account created, but the verification code could not be sent: '
        '${_auth.lastError}',
      );
    }
    Get.off(
      () => OtpScreen(
        email: email,
        password: _password.text,
        initialOtpSendFailed: !otpSent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(AppAssets.logo, width: 90),
                const SizedBox(height: 16),
                const Text(
                  'Complete Profile',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Get started with us with your details',
                  style: TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(height: 24),
                _field(
                  _firstName,
                  'First Name',
                  validator: (v) => Validators.required(v, 'First name'),
                ),
                _field(
                  _lastName,
                  'Last Name',
                  validator: (v) => Validators.required(v, 'Last name'),
                ),
                _field(
                  _email,
                  'Email Address',
                  type: TextInputType.emailAddress,
                  validator: Validators.email,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  validator: Validators.password,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Password',
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
                const SizedBox(height: 14),
                _field(
                  _phone,
                  'Mobile',
                  type: TextInputType.phone,
                  validator: Validators.phone,
                ),
                _field(
                  _city,
                  'City',
                  validator: (v) => Validators.required(v, 'City'),
                ),
                _field(
                  _address,
                  'Shipping Address',
                  lines: 3,
                  action: TextInputAction.done,
                ),
                const SizedBox(height: 10),
                Obx(
                  () => PrimaryButton(
                    label: 'Complete',
                    isLoading: _auth.isLoading.value,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    TextInputType type = TextInputType.text,
    String? Function(String?)? validator,
    int lines = 1,
    TextInputAction action = TextInputAction.next,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        textInputAction: action,
        validator: validator,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}
