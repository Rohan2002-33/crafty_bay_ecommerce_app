import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/utils/app_snack.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _auth = Get.find();
  late final _first = TextEditingController(text: _auth.user.value?.firstName);
  late final _last = TextEditingController(text: _auth.user.value?.lastName);
  late final _phone = TextEditingController(text: _auth.user.value?.phone);
  late final _city = TextEditingController(text: _auth.user.value?.city);
  late final _address = TextEditingController(text: _auth.user.value?.address);

  @override
  void dispose() {
    for (final c in [_first, _last, _phone, _city, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final ok = await _auth.updateProfile({
      'first_name': _first.text.trim(),
      'last_name': _last.text.trim(),
      'phone': _phone.text.trim(),
      'city': _city.text.trim(),
      'address': _address.text.trim(),
    });
    if (!mounted) return;

    if (ok) {
      Get.back();
      AppSnack.success('Profile updated');
    } else {
      AppSnack.error(_auth.lastError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _field(_first, 'First Name',
                    validator: (v) => Validators.required(v, 'First name')),
                _field(_last, 'Last Name',
                    validator: (v) => Validators.required(v, 'Last name')),
                _field(_phone, 'Mobile',
                    type: TextInputType.phone, validator: Validators.phone),
                _field(_city, 'City'),
                _field(_address, 'Shipping Address', lines: 3),
                const SizedBox(height: 8),
                Obx(() => PrimaryButton(
                      label: 'Save Changes',
                      isLoading: _auth.isLoading.value,
                      onPressed: _save,
                    )),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: lines,
        validator: validator,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}