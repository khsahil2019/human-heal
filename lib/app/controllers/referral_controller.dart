import 'package:get/get.dart';
import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/utils/snackbar_helper.dart';

class ReferralController extends GetxController {
  var doctorList = <Map<String, dynamic>>[].obs;
  var isLoadingDoctors = false.obs;
  var isSubmitting = false.obs;

  // Fetch doctors from API
  Future<void> fetchDoctors() async {
    try {
      isLoadingDoctors.value = true;
      final response = await ApiService.getRequest('get-doctor-list');

      if (response['status']?.toString() == "1") {
        final List data = response['data'] ?? [];
        doctorList.assignAll(
          data.map<Map<String, dynamic>>(
            (e) => {'id': e['id'].toString(), 'name': e['name'].toString()},
          ),
        );
      } else {
        safeSnackbar(
          'Error',
          response['message'] ?? 'Failed to load doctors',
        );
      }
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to load doctors',
      );
    } finally {
      isLoadingDoctors.value = false;
    }
  }

  // Submit referral using API
  Future<bool> submitReferral({
    required String patientName,
    required String referalFrom,
    required String referalTo,
    String? comment,
  }) async {
    try {
      isSubmitting.value = true;

      final body = {
        "patient_name": patientName,
        "referal_from": referalFrom,
        "referal_to": referalTo,
        "comment": comment ?? '',
      };

      final response = await ApiService.postRequest(
        'have-a-doctor-referal',
        body,
      );

      if (response['status']?.toString() == "1") {
        safeSnackbar(
          'Success',
          response['message'] ?? 'We will contact you soon.',
        );
        Get.offAllNamed('/login');
        return true;
      } else {
        safeSnackbar(
          'Error',
          response['message'] ?? 'Submission failed',
        );
        return false;
      }
    } catch (e) {
      safeSnackbar(
        'Error',
        'Failed to submit referral',
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
