import 'package:get/get.dart';
import 'package:human_heal/app/data/models/appointment_model.dart';
import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/services/user_storage.dart';

class AppointmentController extends GetxController {
  // Observable list of appointments
  var appointments = <Appointment>[].obs;

  // Observable loading state
  var isLoading = false.obs;

  // Observable error message string
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Retrieve logged-in user info from storage
      final user = await UserStorage.getUser();

      // Check if user data exists and user id is valid
      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      // Make API request for appointment list with user id
      final response = await ApiService.postRequest('appointment-list', {
        'user_id': user.id.toString(),
      });

      // Check response status and parse data accordingly
      if (response['status']?.toString() == "1") {
        final appointmentList = AppointmentListResponse.fromJson(response);
        appointments.value = appointmentList.data;
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error occurred';
      }
    } catch (e) {
      // Catch and set error message for any exception
      errorMessage.value = 'Failed to load appointments: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
