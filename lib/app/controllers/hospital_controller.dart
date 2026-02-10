import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/user_storage.dart';
import '../data/models/hospital_model.dart';
import '../data/models/user_model.dart';

class HospitalController extends GetxController {
  var hospitals = <Hospital>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  /// Fetch hospitals with optional search keyword
  Future<void> fetchHospitals({String keyword = ''}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      UserModel? user = await UserStorage.getUser();

      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      final response = await ApiService.postRequest('hospital-list', {
        "user_id": user.id.toString(),
        "keyword": keyword, // send keyword to API
      });

      if (response['status'] == "1") {
        final hospitalList = HospitalListResponse.fromJson(response);
        hospitals.assignAll(hospitalList.data);
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
