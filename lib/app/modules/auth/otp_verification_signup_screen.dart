import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/auth_controller.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class OtpVerificationSignupScreen extends StatefulWidget {
  const OtpVerificationSignupScreen({super.key});

  @override
  State<OtpVerificationSignupScreen> createState() =>
      _OtpVerificationSignupScreenState();
}

class _OtpVerificationSignupScreenState
    extends State<OtpVerificationSignupScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final AuthController authController = Get.find();

  late String email;
  late String phoneNumber;

  late String userId;
  late bool isLogin;
  late String actionText;

  int _secondsRemaining = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();

    // Get arguments passed from navigation
    final arguments = Get.arguments as Map<String, dynamic>? ?? {};
    email = arguments['email'] ?? '';
    phoneNumber = arguments['mobile'] ?? '';
    userId = arguments['userId'] ?? '';
    isLogin = arguments['isLogin'] ?? false;

    // Set action text based on context
    actionText = isLogin ? 'Login' : 'Sign Up';

    // Set user ID in controller
    authController.userId.value = userId;

    _focusNodes[0].requestFocus();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _canResend = true);
        _timer?.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length > 1) {
      // Handle paste scenario
      final chars = value.characters.take(4).toList();
      for (int i = 0; i < chars.length; i++) {
        _controllers[i].text = chars[i];
      }
      FocusScope.of(context).unfocus();
    } else if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _submitOtp() async {
    final otp = _controllers.map((c) => c.text.trim()).join();
    if (otp.length != 4 || otp.contains(RegExp(r'\D'))) {
      Get.snackbar(
        "Error",
        "Please enter a valid 4-digit OTP",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    await authController.verifyOtp(otp, isLogin);
  }

  Future<void> _resendOtp() async {
    await authController.resendOtp();
    _startCountdown();
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        cursorColor: appColor.primaryColor,
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: appColor.primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        onChanged: (value) => _onOtpChanged(value, index),
      ),
    );
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
          'OTP Verification',
          style: TextStyle(
            color: appColor.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            phoneNumber.trim().isNotEmpty
                ? Text(
                    'We’ve sent a 4-digit code to\n $phoneNumber',
                    style: const TextStyle(
                      fontSize: 16,
                      color: appColor.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'We’ve sent a 4-digit code to\n your registered mobile number',
                    style: const TextStyle(
                      fontSize: 16,
                      color: appColor.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, _buildOtpBox),
            ),
            const SizedBox(height: 32),
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authController.isLoading.value ? null : _submitOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColor.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: authController.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Verify & $actionText',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: appColor.buttonTextColor,
                          ),
                        ),
                ),
              );
            }),
            const SizedBox(height: 20),
            _canResend
                ? TextButton(
                    onPressed: _resendOtp,
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        color: appColor.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Text(
                    'Resend available in $_secondsRemaining sec',
                    style: const TextStyle(
                      color: appColor.textSecondary,
                      fontSize: 14,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
