import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/auth_controller.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/widgets/app_text_field.dart';
import 'login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    // ✅ Clear all text fields when screen opens
    authController.clearSignupFields();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Full Name"),
              AppTextField(
                controller: authController.nameController,
                hintText: 'Enter your full name',
                prefixIcon: Icons.person,
                validator: (value) =>
                    value == null || value.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 20),

              _buildLabel("Email Address"),
              AppTextField(
                controller: authController.signupEmailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Invalid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel("Phone Number"),
              AppTextField(
                controller: authController.mobileController,
                hintText: 'Enter your phone number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                    return 'Enter a valid 10-digit number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              _buildLabel("Password"),
              Obx(
                () => AppTextField(
                  controller: authController.signupPasswordController,
                  hintText: 'Enter your password',
                  obscureText: authController.isPasswordHidden.value,
                  prefixIcon: Icons.lock,
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: appColor.iconColor,
                    ),
                    onPressed: authController.togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Minimum 6 characters';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              _buildLabel("Confirm Password"),
              Obx(
                () => AppTextField(
                  controller: authController.confirmPasswordController,
                  hintText: 'Re-enter your password',
                  obscureText: authController.isConfirmPasswordHidden.value,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isConfirmPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: appColor.iconColor,
                    ),
                    onPressed: authController.toggleConfirmPasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value.trim() !=
                        authController.signupPasswordController.text.trim()) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),

              _buildLabel("Referral Code (Optional)"),
              AppTextField(
                controller: authController.referralCodeController,
                hintText: 'Enter Referral Code',
                keyboardType: TextInputType.text,
                prefixIcon: Icons.refresh,
              ),
              const SizedBox(height: 30),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              authController.register();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: appColor.loaderColor,
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appColor.buttonTextColor,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: const [
                  Expanded(
                    child: Divider(thickness: 1, color: appColor.dividerColor),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "or",
                      style: TextStyle(color: appColor.textSecondary),
                    ),
                  ),
                  Expanded(
                    child: Divider(thickness: 1, color: appColor.dividerColor),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: appColor.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => Get.to(() => LoginScreen()),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appColor.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: appColor.textColor,
        ),
      ),
    );
  }
}
