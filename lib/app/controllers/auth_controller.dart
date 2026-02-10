import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/main_controller.dart';
import 'package:human_heal/app/data/models/user_model.dart';
import 'package:human_heal/app/routes/app_routes.dart';
import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/services/token_storage.dart';
import 'package:human_heal/app/services/user_storage.dart';

class AuthController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // Change password loading observable
  var isChangePasswordLoading = false.obs;

  // Login controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Signup controllers
  final nameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final mobileController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();

  // Change password controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordChangeController = TextEditingController();

  // OTP verification
  var userId = ''.obs;
  var isVerified = ''.obs;

  /// Toggle password visibility (login & signup)
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await TokenStorage.getToken();
    final user = await UserStorage.getUser();

    return token != null && token.isNotEmpty && user != null;
  }

  /// Login method
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter email and password",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.postRequest("login", {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      });

      if (response["status"] == "1") {
        final userData = response["data"] ?? {};
        final token = userData["token"];
        final String verifiedStatus = (response["is_verified"] ?? "2")
            .toString()
            .trim();

        userId.value = userData["id"]?.toString() ?? "";

        if (verifiedStatus == "1") {
          await TokenStorage.saveToken(token?.toString() ?? '');
          final user = UserModel.fromJson(userData);
          await UserStorage.saveUser(user);

          Get.snackbar(
            "Success",
            "Login successful",
            snackPosition: SnackPosition.BOTTOM,
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            Get.offAllNamed(AppRoutes.MAIN);
          });
        } else {
          // Navigate to OTP verification
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.toNamed(
              AppRoutes.OTP_VERIFICATION_SIGNUP,
              arguments: {
                'email': emailController.text.trim(),
                'userId': userId.value,
                'isLogin': true,
              },
            );
          });
        }
      } else {
        Get.snackbar(
          "Login Failed",
          response["message"]?.toString() ?? "Invalid credentials",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Register method
  Future<void> register() async {
    if (nameController.text.trim().isEmpty ||
        signupEmailController.text.trim().isEmpty ||
        mobileController.text.trim().isEmpty ||
        signupPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (signupPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await ApiService.postRequest("register", {
        "name": nameController.text.trim(),
        "email": signupEmailController.text.trim(),
        "mobile": mobileController.text.trim(),
        "referal_code": referralCodeController.text.trim(),
        "password": signupPasswordController.text.trim(),
        "device_type": "Android",
      });

      if (response["status"] == "1") {
        userId.value = response["user_id"]?.toString() ?? "";

        Get.snackbar(
          "Success",
          response["message"]?.toString() ?? "Registration successful",
          snackPosition: SnackPosition.BOTTOM,
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.toNamed(
            AppRoutes.OTP_VERIFICATION_SIGNUP,
            arguments: {
              'email': signupEmailController.text.trim(),
              'mobile': mobileController.text.trim(),
              'userId': userId.value,
              'isLogin': false,
            },
          );
        });
      } else {
        Get.snackbar(
          "Error",
          response["message"]?.toString() ?? "Registration failed",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Verify OTP for signup/login
  Future<void> verifyOtp(String otp, bool isLogin) async {
    try {
      isLoading.value = true;

      final response = await ApiService.postRequest('verify-otp', {
        'user_id': userId.value,
        'otp': otp,
      });

      if (response['status'] == "1") {
        final userData = response['data'] ?? {};
        final token = userData['token'];

        await TokenStorage.saveToken(token?.toString() ?? '');
        final user = UserModel.fromJson(userData);
        await UserStorage.saveUser(user);

        Get.snackbar(
          "Success",
          "Account verified successfully",
          snackPosition: SnackPosition.BOTTOM,
        );

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed(AppRoutes.MAIN);
        });
      } else {
        Get.snackbar(
          "Error",
          response['message']?.toString() ?? 'Invalid OTP',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to verify OTP: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    try {
      isLoading.value = true;

      final response = await ApiService.postRequest('resend-otp', {
        'user_id': userId.value,
      });

      if (response['status'] == "1") {
        Get.snackbar(
          "Success",
          response['message']?.toString() ?? 'OTP resent successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          response['message']?.toString() ?? 'Failed to resend OTP',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Error: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  /// Change Password method
  Future<void> changePassword() async {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordChangeController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all password fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newPasswordController.text != confirmPasswordChangeController.text) {
      Get.snackbar(
        "Error",
        "New password and confirm password do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (currentPasswordController.text == newPasswordController.text) {
      Get.snackbar(
        "Error",
        "The new password must be different from the current password",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final user = await UserStorage.getUser();
    if (user == null) {
      Get.snackbar(
        "Error",
        "User not logged in",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isChangePasswordLoading.value = true;

    try {
      final response = await ApiService.postRequest("change-password", {
        "user_id": user.id.toString(),
        "old": currentPasswordController.text.trim(),
        "new": newPasswordController.text.trim(),
        "confirm": confirmPasswordChangeController.text.trim(),
      });

      if (response["status"] == "1") {
        Get.snackbar(
          "Success",
          response["message"]?.toString() ?? 'Password updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );

        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordChangeController.clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAllNamed(AppRoutes.MAIN);
          final mainController = Get.find<MainController>();
          mainController.changeTab(3); // Profile tab
        });
      } else {
        Get.snackbar(
          "Error",
          response["message"]?.toString() ?? 'Failed to update password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isChangePasswordLoading.value = false;
    }
  }

  void handleUnauthorized() async {
    await TokenStorage.clearToken();
    await UserStorage.clearUser();

    Get.snackbar(
      "Session Expired",
      "Your account was removed or your session expired. Please log in again.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(AppRoutes.LOGIN);
    });
  }

  /// Logout method
  Future<void> logout() async {
    await TokenStorage.clearToken();
    await UserStorage.clearUser();
    clearSignupFields();
    clearLoginFields();

    Get.snackbar(
      "Logged Out",
      "You have been logged out",
      snackPosition: SnackPosition.BOTTOM,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(AppRoutes.LOGIN);
    });
  }

  /// Clear signup fields
  void clearSignupFields() {
    nameController.clear();
    signupEmailController.clear();
    mobileController.clear();
    signupPasswordController.clear();
    confirmPasswordController.clear();
    referralCodeController.clear();
  }

  void clearLoginFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    signupEmailController.dispose();
    mobileController.dispose();
    signupPasswordController.dispose();
    confirmPasswordController.dispose();
    referralCodeController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordChangeController.dispose();
    super.onClose();
  }
}
