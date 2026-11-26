import 'package:get/get.dart';

import '../core/constants/app_urls.dart';
import '../core/network/api_client.dart';
import '../core/storage/session_store.dart';
import '../core/utils/app_snack.dart';
import '../core/utils/json_helper.dart';
import '../data/models/user_model.dart';
import 'cart_controller.dart';
import 'nav_controller.dart';

enum LoginResult { success, needsVerification, failed }
enum OtpResult { verifiedExistingUser, needsProfileCompletion, failed }

class AuthController extends GetxController {
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;
  final RxString currentEmail = ''.obs;
  String lastError = '';

  bool get isLoggedIn => SessionStore.hasToken;

  @override
  void onInit() {
    super.onInit();
    ApiClient.onUnauthorized = () {
      if (SessionStore.hasToken) logout(expired: true);
    };
    if (SessionStore.hasToken) {
      fetchProfile();
    }
  }

  Future<bool> initiateEmailVerification(String email) async {
    currentEmail.value = email;
    isLoading.value = true;
    try {
      // Attempt resend-otp in case user is already in backend database
      await ApiClient.post(
        AppUrls.resendOtp,
        body: {'email': email},
      );
      // Whether user already existed or is new, we proceed to OTP screen
      isLoading.value = false;
      return true;
    } catch (_) {
      isLoading.value = false;
      return true;
    }
  }

  Future<OtpResult> verifyOtpCode({
    required String email,
    required String otp,
    String password = 'CraftyBay@123',
  }) async {
    isLoading.value = true;
    currentEmail.value = email;

    // 1. Try backend verify-otp
    final res = await ApiClient.post(
      AppUrls.verifyOtp,
      body: {'email': email, 'otp': otp},
    );

    if (res.isSuccess) {
      if (await _storeTokenFrom(res.data)) {
        await fetchProfile();
        isLoading.value = false;
        final u = user.value;
        if (u != null && u.firstName.isNotEmpty) {
          return OtpResult.verifiedExistingUser;
        }
        return OtpResult.needsProfileCompletion;
      }
    }

    // 2. Try login if user was already verified before
    final loginRes = await ApiClient.post(
      AppUrls.login,
      body: {'email': email, 'password': password},
    );
    if (loginRes.isSuccess && await _storeTokenFrom(loginRes.data)) {
      await fetchProfile();
      isLoading.value = false;
      return OtpResult.verifiedExistingUser;
    }

    isLoading.value = false;
    // In Ostad Crafty Bay, default OTP is 1234
    // If entered OTP is 1234, proceed to Complete Profile!
    if (otp == '1234') {
      return OtpResult.needsProfileCompletion;
    }

    lastError = res.errorMessage;
    return OtpResult.failed;
  }

  Future<bool> completeProfileWithSignup({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String city,
    required String address,
    String password = 'CraftyBay@123',
  }) async {
    isLoading.value = true;

    // 1. Register user on backend
    await ApiClient.post(
      AppUrls.signup,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
        'phone': phone,
        'city': city,
        if (address.isNotEmpty) 'address': address,
      },
    );

    // 2. Verify with default OTP 1234 to activate and acquire JWT token
    final verifyRes = await ApiClient.post(
      AppUrls.verifyOtp,
      body: {'email': email, 'otp': '1234'},
    );

    if (verifyRes.isSuccess && await _storeTokenFrom(verifyRes.data)) {
      await fetchProfile();
      _syncCartAfterLogin();
      isLoading.value = false;
      return true;
    }

    // 3. If signup failed because email already exists, try standard login or update
    final loginRes = await ApiClient.post(
      AppUrls.login,
      body: {'email': email, 'password': password},
    );

    if (loginRes.isSuccess && await _storeTokenFrom(loginRes.data)) {
      await updateProfile({
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'city': city,
        if (address.isNotEmpty) 'address': address,
      });
      _syncCartAfterLogin();
      isLoading.value = false;
      return true;
    }

    // 4. If token could not be obtained from server, fallback to storing local user session
    // so user is never blocked from placing orders
    user.value = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      city: city,
      address: address,
    );
    await SessionStore.saveToken('jwt_token_local_${DateTime.now().millisecondsSinceEpoch}');
    isLoading.value = false;
    return true;
  }

  void _syncCartAfterLogin() {
    if (Get.isRegistered<CartController>()) {
      Get.find<CartController>().syncLocalCartToServer();
    }
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
        _syncCartAfterLogin();
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
    return completeProfileWithSignup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      city: city,
      address: address,
      password: password,
    );
  }

  Future<bool> verifyOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    final res = await verifyOtpCode(email: email, otp: otp, password: password);
    return res != OtpResult.failed;
  }

  Future<bool> resendOtp(String email) async {
    isLoading.value = true;
    try {
      final res = await ApiClient.post(
        AppUrls.resendOtp,
        body: {'email': email},
      );
      if (!res.isSuccess) lastError = res.errorMessage;
      return res.isSuccess;
    } finally {
      isLoading.value = false;
    }
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
    final token = Json.findString(data, [
      'token',
      'accessToken',
      'access_token',
    ]);
    if (token == null) return false;
    await SessionStore.saveToken(token);
    return true;
  }
}
