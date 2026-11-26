import 'package:flutter/material.dart';

import 'app.dart';
import 'core/storage/session_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionStore.init();
  runApp(const CraftyBayApp());
}