import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/storage/session_store.dart';
import '../../core/widgets/primary_button.dart';
import '../auth/login_screen.dart';
import '../orders/orders_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final user = auth.user.value;
        final hasToken = SessionStore.hasToken;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      hasToken ? (user?.initials ?? 'U') : 'G',
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hasToken
                        ? (user?.fullName.isNotEmpty == true ? user!.fullName : 'Crafty Bay User')
                        : 'Guest User',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hasToken ? (user?.email ?? '') : 'You are currently browsing as a guest',
                    style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                  ),
                  if (hasToken && user != null && user.phone.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.phone,
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                    ),
                  ],
                  if (!hasToken) ...[
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Complete Profile / Sign In',
                      onPressed: () => Get.to(() => const LoginScreen()),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (hasToken) ...[
              _menuTile(
                Icons.receipt_long_outlined,
                'My Orders',
                () => Get.to(() => const OrdersScreen()),
              ),
              _menuTile(
                Icons.person_outline_rounded,
                'Edit Profile',
                () => Get.to(() => const EditProfileScreen()),
              ),
              _menuTile(
                Icons.logout_rounded,
                'Log Out',
                () => _confirmLogout(auth),
                color: AppColors.danger,
              ),
            ] else ...[
              _menuTile(
                Icons.app_registration_rounded,
                'Complete Profile',
                () => Get.to(() => const LoginScreen()),
              ),
            ],
          ],
        );
      }),
    );
  }

  Widget _menuTile(IconData icon, String title, VoidCallback onTap,
      {Color color = AppColors.textDark}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }

  Future<void> _confirmLogout(AuthController auth) async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirm == true) await auth.logout();
  }
}
