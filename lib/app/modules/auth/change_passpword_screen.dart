import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/auth_controller.dart'; // Adjust path
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final AuthController _authController = Get.find<AuthController>();

  bool _isObscureCurrent = true;
  bool _isObscureNew = true;
  bool _isObscureConfirm = true;

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      _authController.changePassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _authController.currentPasswordController,
                hintText: "Current Password",
                obscureText: _isObscureCurrent,
                prefixIcon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    color: appColor.iconColor,
                    _isObscureCurrent ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureCurrent = !_isObscureCurrent;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter current password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _authController.newPasswordController,
                hintText: "New Password",
                obscureText: _isObscureNew,
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureNew ? Icons.visibility_off : Icons.visibility,
                    color: appColor.iconColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureNew = !_isObscureNew;
                    });
                  },
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter new password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _authController.confirmPasswordChangeController,
                hintText: "Confirm Password",
                obscureText: _isObscureConfirm,
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  icon: Icon(
                    color: appColor.iconColor,
                    _isObscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureConfirm = !_isObscureConfirm;
                    });
                  },
                ),
                validator: (value) {
                  if (value != _authController.newPasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 36),
              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _authController.isChangePasswordLoading.value
                        ? null
                        : _handleChangePassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      backgroundColor: appColor.primaryBlue,
                    ),
                    child: _authController.isChangePasswordLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: appColor.loaderColor,
                            ),
                          )
                        : const Text(
                            "Update Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
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
