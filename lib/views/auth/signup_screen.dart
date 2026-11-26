import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/primary_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
    this.initialEmail = '',
    this.redirectToCheckout = false,
  });

  final String initialEmail;
  final bool redirectToCheckout;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _city = TextEditingController();
  final _address = TextEditingController();
  final AuthController _auth = Get.find();

  @override
  void dispose() {
    for (final c in [
      _firstName,
      _lastName,
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

    final email = widget.initialEmail.isNotEmpty
        ? widget.initialEmail
        : (_auth.currentEmail.value.isNotEmpty
            ? _auth.currentEmail.value
            : 'user_${DateTime.now().millisecondsSinceEpoch}@gmail.com');

    final ok = await _auth.completeProfileWithSignup(
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: email,
      phone: _phone.text.trim(),
      city: _city.text.trim(),
      address: _address.text.trim(),
      password: 'CraftyBay@123',
    );
    if (!mounted) return;

    if (ok) {
      AppSnack.success('Profile completed successfully! You are now logged in.');
      if (widget.redirectToCheckout) {
        Get.back(result: true);
      } else {
        Get.offAllNamed('/main');
      }
    } else {
      AppSnack.error(_auth.lastError.isNotEmpty ? _auth.lastError : 'Could not complete profile.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Complete Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SvgPicture.asset(
                  AppAssets.logo,
                  width: 95,
                  placeholderBuilder: (_) => Image.asset(AppAssets.logo, width: 95),
                ),
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
                  style: TextStyle(color: AppColors.textGrey, fontSize: 13.5),
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
                const SizedBox(height: 12),
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
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
