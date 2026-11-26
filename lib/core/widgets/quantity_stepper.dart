import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _button(Icons.remove, value > min ? () => onChanged(value - 1) : null),
        SizedBox(
          width: 32,
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ),
        ),
        _button(Icons.add, value < max ? () => onChanged(value + 1) : null),
      ],
    );
  }

  Widget _button(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 15, color: Colors.white),
      ),
    );
  }
}
