import 'package:flutter/material.dart';

/// Product colors come as plain strings ("red", "#FF0000"...).
class ColorParser {
  ColorParser._();

  static const Map<String, Color> _names = {
    'black': Colors.black,
    'white': Colors.white,
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'brown': Colors.brown,
    'grey': Colors.grey,
    'gray': Colors.grey,
    'navy': Color(0xFF1B2A49),
    'teal': Colors.teal,
  };

  static Color? parse(String value) {
    final s = value.trim().toLowerCase();
    if (s.startsWith('#') && s.length == 7) {
      final parsed = int.tryParse('FF${s.substring(1)}', radix: 16);
      return parsed == null ? null : Color(parsed);
    }
    return _names[s];
  }
}