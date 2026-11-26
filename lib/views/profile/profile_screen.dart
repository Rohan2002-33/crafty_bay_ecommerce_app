import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../core/constants/app_colors.dart';
import '../orders/orders_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profile')),
      body: Obx(() {
        final user = auth.user.value;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.initials ?? 'U',
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.fullName.isNotEmpty == true ? user!.fullName : 'Crafty Bay User',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: AppColors.textGrey),
                  ),
                  if (user != null && user.phone.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      user.phone,
                      style: const TextStyle(color: AppColors.textGrey),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
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