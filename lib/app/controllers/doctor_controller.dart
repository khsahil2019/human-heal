import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/user_storage.dart';
import '../data/models/doctor_model.dart';

class DoctorController extends GetxController {
  var doctors = <Doctor>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> fetchDoctors({required int hospitalId}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await UserStorage.getUser();
      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      final response = await ApiService.postRequest('doctor-list', {
        'user_id': user.id.toString(),
        'hospital_id': hospitalId.toString(),
      });

      if (response['status'] == '1') {
        final data = response['data'] as List;
        doctors.value = data.map((e) => Doctor.fromJson(e)).toList();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch doctors';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Book appointment method
  Future<Map<String, dynamic>> bookAppointment({
    required int hospitalId,
    required int doctorId,
    required String name,
    required String email,
    required String mobile,
    required String date,
    String comment = '',
  }) async {
    final user = await UserStorage.getUser();
    if (user == null || user.id == null) {
      return {'status': '0', 'message': 'User not logged in'};
    }

    final body = {
      'user_id': user.id.toString(),
      'hospital_id': hospitalId.toString(),
      'doctor_id': doctorId.toString(),
      'name': name,
      'email': email,
      'mobile': mobile,
      'date': date,
      'comment': comment,
    };

    final response = await ApiService.postRequest('book-an-appointment', body);
    return response;
  }

  // Confirm appointment method
  Future<Map<String, dynamic>> confirmAppointment({
    required int appointmentId,
    required double amount,
  }) async {
    final user = await UserStorage.getUser();
    if (user == null || user.id == null) {
      return {'status': '0', 'message': 'User not logged in'};
    }

    final body = {
      'appointment_id': appointmentId.toString(),
      'user_id': user.id.toString(),
      'amount': amount.toString(),
    };

    final response = await ApiService.postRequest('confirm-appointment', body);
    return response;
  }
}
