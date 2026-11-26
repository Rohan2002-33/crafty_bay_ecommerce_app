import 'package:get/get.dart';

class NavController extends GetxController {
  final RxInt index = 0.obs;

  void change(int value) => index.value = value;
}