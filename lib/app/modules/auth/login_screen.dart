import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/modules/auth/forget_screen.dart';
import 'package:human_heal/app/modules/auth/referral_screen.dart';
import 'package:human_heal/app/modules/auth/signup_screen.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/widgets/app_text_field.dart';
import 'package:human_heal/app/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/imgs/human_heal_logo.jpg',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: appColor.textColor,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Log in to continue to Human Heal',
                  style: TextStyle(fontSize: 15, color: appColor.textSecondary),
                ),

                const SizedBox(height: 36),

                // Email Field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: authController.emailController,
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Field
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                AppTextField(
                  controller: authController.passwordController,
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
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 5),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.to(() => ForgetPasswordScreen());
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: appColor.primaryColor),
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authController.isLoading.value
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              authController.login();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.buttonColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 3,
                    ),
                    child: authController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: appColor.loaderColor,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: appColor.buttonTextColor,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: const [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: appColor.dividerColor,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "or",
                        style: TextStyle(color: appColor.textSecondary),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: appColor.dividerColor,
                      ),
                    ),
                  ],
                ),

                //   const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: appColor.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const SignUpScreen());
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appColor.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                TextButton(
                  onPressed: () {
                    Get.to(() => ReferralScreen());
                  },
                  child: const Text(
                    "Have a Doctor Referral?",
                    style: TextStyle(
                      color: appColor.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
}
