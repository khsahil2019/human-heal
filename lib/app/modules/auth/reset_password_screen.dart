import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/password_controller.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/widgets/app_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String mobile;
  final String userId;

  const ResetPasswordScreen({
    super.key,
    required this.mobile,
    required this.userId,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _confirmObscureText = true;
  final PasswordController passwordController = Get.put(PasswordController());

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Set userId in controller before API call
    passwordController.userId.value = widget.userId;

    await passwordController.setNewPassword(
      newPasswordController.text.trim(),
      confirmPasswordController.text.trim(),
    );

    if (passwordController.errorMessage.isNotEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(passwordController.errorMessage.value),
      //     backgroundColor: Colors.redAccent,
      //   ),
      // );
      Get.snackbar(
        "Error",
        passwordController.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (passwordController.successMessage.isNotEmpty) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(passwordController.successMessage.value),
      //     backgroundColor: appColor.primaryColor,
      //   ),
      // );
      Get.snackbar(
        "Success",
        passwordController.successMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      // Navigate back after success
      //   Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColor.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: appColor.textColor),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: appColor.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Please enter your new password below',
                style: TextStyle(color: appColor.textSecondary, fontSize: 15),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 30),
              const Text(
                'New Password',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),

              // AppTextField(
              //   controller: newPasswordController,
              //   prefixIcon: Icons.lock,
              //   obscureText: true,
              //   hintText: 'Enter a new password',
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return 'New password is required';
              //     }
              //     if (value.trim().length < 6) {
              //       return 'Password must be at least 6 characters';
              //     }
              //     return null;
              //   },
              // ),
              AppTextField(
                controller: newPasswordController,
                prefixIcon: Icons.lock,
                obscureText: _obscureText,
                hintText: 'Enter a new password',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'New password is required';
                  }
                  if (value.trim().length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              // AppTextField(
              //   controller: confirmPasswordController,
              //   prefixIcon: Icons.lock,
              //   obscureText: true,
              //   hintText: 'Re-enter your new password',
              //   validator: (value) {
              //     if (value == null || value.trim().isEmpty) {
              //       return 'Please confirm your password';
              //     }
              //     if (value.trim() != newPasswordController.text.trim()) {
              //       return 'Passwords do not match';
              //     }
              //     return null;
              //   },
              // ),
              AppTextField(
                controller: confirmPasswordController,
                prefixIcon: Icons.lock,
                obscureText: _confirmObscureText,
                hintText: 'Re-enter your new password',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value.trim() != newPasswordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmObscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmObscureText = !_confirmObscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: passwordController.isLoading.value
                        ? null
                        : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: passwordController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appColor.buttonTextColor,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
