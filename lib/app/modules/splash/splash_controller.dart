import 'package:get/get.dart';
import 'package:human_heal/app/controllers/auth_controller.dart';
import 'package:human_heal/app/routes/app_routes.dart';

class SplashController extends GetxController {
  late final AuthController authController;

  @override
  void onInit() {
    super.onInit();
    authController = Get.put(AuthController(), permanent: true);
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3)); // splash delay

    // Check if token exists & user data is valid
    final loggedIn = await authController.isLoggedIn();

    if (loggedIn) {
      // Go to Main screen if already logged in
      Get.offAllNamed(AppRoutes.MAIN);
    } else {
      // Otherwise go to Login screen
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
