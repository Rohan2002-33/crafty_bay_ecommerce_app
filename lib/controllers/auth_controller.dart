import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_store.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
import '../data/models/user_model.dart';
import 'nav_controller.dart';

enum LoginResult { success, needsVerification, failed }

class AuthController extends GetxController {
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  String lastError = '';

  @override
  void onInit() {
    super.onInit();
    ApiClient.onUnauthorized = () {
      if (SessionStore.hasToken) logout(expired: true);
    };
  }

  Future<LoginResult> login(String email, String password) async {
    isLoading.value = true;
    final res = await ApiClient.post(
      AppUrls.login,
      body: {'email': email, 'password': password},
    );
    isLoading.value = false;

    if (res.isSuccess) {
      if (await _storeTokenFrom(res.data)) {
        await fetchProfile();
        return LoginResult.success;
      }
      lastError = 'Login worked but the server sent no token.';
      return LoginResult.failed;
    }

    lastError = res.errorMessage;
    if (lastError.toLowerCase().contains('verif')) {
      return LoginResult.needsVerification;
    }
    return LoginResult.failed;
  }

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required String city,
    String address = '',
  }) async {
    isLoading.value = true;
    final res = await ApiClient.post(AppUrls.signup, body: {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'phone': phone,
      'city': city,
      if (address.isNotEmpty) 'address': address,
    });
    isLoading.value = false;
    if (!res.isSuccess) lastError = res.errorMessage;
    return res.isSuccess;
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    isLoading.value = true;
    final res = await ApiClient.post(
      AppUrls.verifyOtp,
      body: {'email': email, 'otp': otp},
    );

    if (!res.isSuccess) {
      isLoading.value = false;
      lastError = res.errorMessage;
      return false;
    }

    if (await _storeTokenFrom(res.data)) {
      await fetchProfile();
      isLoading.value = false;
      return true;
    }

    // Server did not return a token: sign in with the password instead.
    final result = await login(email, password);
    isLoading.value = false;
    return result == LoginResult.success;
  }

  Future<bool> resendOtp(String email) async {
    final res = await ApiClient.post(AppUrls.resendOtp, body: {'email': email});
    if (!res.isSuccess) lastError = res.errorMessage;
    return res.isSuccess;
  }

  Future<void> fetchProfile() async {
    final res = await ApiClient.get(AppUrls.profile);
    if (res.isSuccess) {
      user.value = UserModel.fromJson(
        Json.extractMap(res.data, keys: const ['data', 'user']),
      );
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> changes) async {
    isLoading.value = true;
    final res = await ApiClient.patch(AppUrls.profile, body: changes);
    if (res.isSuccess) {
      await fetchProfile();
    } else {
      lastError = res.errorMessage;
    }
    isLoading.value = false;
    return res.isSuccess;
  }

  Future<void> logout({bool expired = false}) async {
    await SessionStore.clear();
    user.value = null;
    Get.find<NavController>().change(0);
    Get.offAllNamed('/login');
    if (expired) AppSnack.error('Session expired. Please sign in again.');
  }

  Future<bool> _storeTokenFrom(dynamic data) async {
    final token = Json.findString(data, ['token', 'accessToken', 'access_token']);
    if (token == null) return false;
    await SessionStore.saveToken(token);
    return true;
  }
}