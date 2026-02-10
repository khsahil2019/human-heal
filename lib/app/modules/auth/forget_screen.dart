import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/modules/auth/otp_screen.dart';
import 'package:human_heal/app/widgets/app_text_field.dart';
import 'package:human_heal/app/controllers/password_controller.dart';
import 'package:flutter/services.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final mobileController = TextEditingController();
  final PasswordController passwordController = Get.put(PasswordController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColor.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: appColor.textColor),
        centerTitle: true,
        title: const Text(
          'Forgot Password',
          style: TextStyle(
            color: appColor.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.05),

            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/imgs/human_heal_logo.jpg',
                height: size.height * 0.18,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 32),

            // Content box (kept minimal as before)
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: appColor.textColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Enter the mobile number associated with your account.',
                    style: TextStyle(
                      fontSize: 14,
                      color: appColor.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Using your custom AppTextField, but restricting to digits
                  AppTextField(
                    controller: mobileController,
                    prefixIcon: Icons.phone_android_outlined,
                    hintText: 'Enter your mobile number',
                    keyboardType: TextInputType.phone,
                    // optional: you can pass a validator when using inside a Form
                  ),

                  const SizedBox(height: 28),

                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: passwordController.isLoading.value
                            ? null
                            : () async {
                                final mobile = mobileController.text.trim();

                                // Basic validation: not empty and 10 digits
                                if (mobile.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Mobile number cannot be empty",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                // Only digits allowed, length 10 (adjust if you support country code)
                                final digitsOnly = RegExp(r'^\d{10}$');
                                if (!digitsOnly.hasMatch(mobile)) {
                                  Get.snackbar(
                                    "Error",
                                    "Please enter a valid 10-digit mobile number",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                // Call your controller method - ensure it supports mobile numbers
                                await passwordController.forgotPassword(mobile);

                                // Show error / navigate on success
                                if (passwordController
                                    .errorMessage
                                    .value
                                    .isNotEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    passwordController.errorMessage.value,
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                } else if (passwordController
                                    .successMessage
                                    .value
                                    .isNotEmpty) {
                                  // Navigate to OTP screen and pass mobile
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtpVerificationScreen(
                                        mobile: mobile,
                                        // if your OTP screen expects other args (like userId/otp),
                                        // pass them here (e.g. userId: passwordController.userId.value)
                                      ),
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColor.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 5,
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
                                'Send OTP',
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
          ],
        ),
      ),
    );
  }
}
