import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/review_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/app_snack.dart';
import '../../core/utils/validators.dart';
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
  int _rating = 5;

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
      rating: _rating,
    );
    if (!mounted) return;

    if (ok) {
      Get.back();
      AppSnack.success('Thanks! Your review was posted.');
    } else {
      AppSnack.error(widget.controller.lastError);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Review')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _first,
                  readOnly: true,
                  decoration: const InputDecoration(hintText: 'First Name'),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _last,
                  readOnly: true,
                  decoration: const InputDecoration(hintText: 'Last Name'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your rating',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Row(
                  children: List.generate(5, (i) {
                    return IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => setState(() => _rating = i + 1),
                      icon: Icon(
                        i < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 36,
                        color: AppColors.star,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _comment,
                  maxLines: 8,
                  maxLength: 500,
                  validator: (v) {
                    final base = Validators.required(v, 'Review');
                    if (base != null) return base;
                    return v!.trim().length < 5 ? 'Write a little more' : null;
                  },
                  decoration: const InputDecoration(hintText: 'Write Review'),
                ),
                const SizedBox(height: 12),
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
    );
  }
}