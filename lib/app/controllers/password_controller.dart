import 'package:get/get.dart';
import 'package:human_heal/app/data/models/user_model.dart';
import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/services/user_storage.dart';
import 'package:human_heal/app/routes/app_routes.dart';

class PasswordController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  var userId = ''.obs;
  var otpCode = ''.obs;

  /// Holds user after OTP verify
  var user = Rxn<UserModel>();

  /// ✅ To prevent multiple snackbar pops
  var isSnackbarActive = false.obs;

  /// ✅ Centralized snackbar handler (single pop)
  void showSnackbar(String title, String message, {bool isError = false}) {
    if (!isSnackbarActive.value) {
      isSnackbarActive.value = true;
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ? null : null,
      ).future.then((_) {
        isSnackbarActive.value = false;
      });
    }
  }

  /// ✅ Forgot Password
  Future<void> forgotPassword(String email) async {
    if (email.trim().isEmpty) {
      showSnackbar("Error", "Email is required", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await ApiService.postRequest('forgot-password', {
        'email': email,
      });

      if (response['status']?.toString() == "1") {
        userId.value = response['user_id'].toString();
        otpCode.value = response['otp'].toString();
        successMessage.value = response['message'] ?? 'OTP sent successfully';
        showSnackbar("Success", successMessage.value);
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error';
        showSnackbar("Error", errorMessage.value, isError: true);
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      showSnackbar("Error", errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Verify OTP
  Future<void> verifyOtp(String otp) async {
    if (otp.trim().isEmpty) {
      showSnackbar("Error", "OTP is required", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await ApiService.postRequest('verify-otp', {
        'user_id': userId.value,
        'otp': otp,
      });

      if (response['status']?.toString() == "1") {
        final userModel = UserModel.fromJson(response['data']);
        user.value = userModel;
        userId.value = userModel.id.toString();
        await UserStorage.saveUser(userModel);

        successMessage.value =
            response['message'] ?? 'OTP verified successfully';
        showSnackbar("Success", successMessage.value);
      } else {
        errorMessage.value = response['message'] ?? 'Invalid OTP';
        showSnackbar("Error", errorMessage.value, isError: true);
      }
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP: $e';
      showSnackbar("Error", errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Resend OTP
  Future<void> resendOtp() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await ApiService.postRequest('resend-otp', {
        'user_id': userId.value,
      });

      if (response['status']?.toString() == "1") {
        otpCode.value = response['otp'].toString();
        successMessage.value = response['message'] ?? 'OTP resent successfully';
        showSnackbar("Success", successMessage.value);
      } else {
        errorMessage.value = response['message'] ?? 'Failed to resend OTP';
        showSnackbar("Error", errorMessage.value, isError: true);
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      showSnackbar("Error", errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Set New Password
  Future<void> setNewPassword(String newPass, String confirmPass) async {
    if (newPass.trim().isEmpty || confirmPass.trim().isEmpty) {
      showSnackbar("Error", "Please fill all fields", isError: true);
      return;
    }

    if (newPass.trim() != confirmPass.trim()) {
      showSnackbar("Error", "Passwords do not match", isError: true);
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      successMessage.value = '';

      final response = await ApiService.postRequest('set-new-password', {
        'user_id': userId.value,
        'new': newPass,
        'confirm': confirmPass,
      });

      if (response['status']?.toString() == "1") {
        successMessage.value =
            response['message'] ?? 'Password reset successful';
        showSnackbar("Success", successMessage.value);

        /// Navigate to login screen
        Get.offAllNamed(AppRoutes.LOGIN);
      } else {
        errorMessage.value = response['message'] ?? 'Password reset failed';
        showSnackbar("Error", errorMessage.value, isError: true);
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      showSnackbar("Error", errorMessage.value, isError: true);
    } finally {
      isLoading.value = false;
    }
  }
}
