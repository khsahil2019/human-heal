import 'package:get/get.dart';
import 'package:human_heal/app/modules/auth/forget_screen.dart';
import 'package:human_heal/app/modules/auth/signup_screen.dart';
import 'package:human_heal/app/modules/auth/otp_screen.dart';
import 'package:human_heal/app/modules/home/home_screen.dart';
import 'package:human_heal/app/modules/main/main_screen.dart';
import 'package:human_heal/app/modules/profile/delete_account_screen.dart';
import 'package:human_heal/app/modules/profile/profile_screen.dart';
import 'package:human_heal/app/modules/auth/otp_verification_signup_screen.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/auth/login_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.LOGIN, page: () => LoginScreen()),
    GetPage(name: AppRoutes.MAIN, page: () => MainScreen()),
    GetPage(name: AppRoutes.SIGNUP, page: () => const SignUpScreen()),
    GetPage(
      name: AppRoutes.OTP,
      page: () => const OtpVerificationScreen(mobile: ''),
    ),
    GetPage(
      name: AppRoutes.OTP_VERIFICATION_SIGNUP,
      page: () => const OtpVerificationSignupScreen(),
    ),
    GetPage(name: AppRoutes.HOME, page: () => const HomeTab()),
    GetPage(
      name: AppRoutes.FORGOT,
      page: () => ForgetPasswordScreen(),
    ),
    GetPage(name: AppRoutes.PROFILE, page: () => const ProfileTab()),
    GetPage(
      name: AppRoutes.DELETE_ACCOUNT,
      page: () => const DeleteAccountScreen(),
    ),
  ];
}
