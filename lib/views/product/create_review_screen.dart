import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/review_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_bottom_nav_bar.dart';
import '../../core/widgets/primary_button.dart';

class CreateReviewScreen extends StatefulWidget {
  const CreateReviewScreen({super.key, required this.controller});

  final ReviewController controller;

  @override
  State<CreateReviewScreen> createState() => _CreateReviewScreenState();
}

class _CreateReviewScreenState extends State<CreateReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Get.find<AuthController>().user.value;
    _first.text = user?.firstName ?? '';
    _last.text = user?.lastName ?? '';
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final ok = await widget.controller.submit(
      comment: _comment.text.trim(),
      rating: 5,
    );
    if (!mounted) return;

    if (ok) {
      Get.back();
      AppSnack.success('Review posted successfully!');
    } else {
      AppSnack.error(widget.controller.lastError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _first,
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                    hintStyle: TextStyle(color: AppColors.textGrey),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _last,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                    hintStyle: TextStyle(color: AppColors.textGrey),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _comment,
                  maxLines: 7,
                  validator: (v) => Validators.required(v, 'Review'),
                  decoration: const InputDecoration(
                    hintText: 'Write Review',
                    hintStyle: TextStyle(color: AppColors.textGrey),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),
                Obx(() => PrimaryButton(
                      label: 'Submit',
                      isLoading: widget.controller.isSubmitting.value,
                      onPressed: _submit,
                    )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0, isChildScreen: true),
    );
  }
}
