import 'package:get/get.dart';
import 'package:human_heal/app/controllers/hospital_controller.dart';
import 'package:human_heal/app/controllers/lab_test_controller.dart';
import 'package:human_heal/app/controllers/profile_controller.dart';
import 'package:human_heal/app/controllers/wallet_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalController>(() => HospitalController());
    Get.lazyPut<LabTestController>(() => LabTestController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<WalletController>(() => WalletController());
  }
}
