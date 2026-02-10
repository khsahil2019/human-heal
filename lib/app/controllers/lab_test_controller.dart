import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/user_storage.dart';
import '../data/models/user_model.dart';
import '../data/models/lab_test_model.dart';

class LabTestController extends GetxController {
  var labTests = <LabTest>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Map to store order_id for each labTest by its id
  var labTestOrders = <String, String>{}.obs;

  /// Fetch lab tests with optional search keyword
  Future<void> fetchLabTests({String keyword = ''}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      UserModel? user = await UserStorage.getUser();

      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      final response = await ApiService.postRequest('lab-test-list', {
        "user_id": user.id.toString(),
        "keyword": keyword, // send keyword to API
      });

      if (response['status'] == "1") {
        final labTestList = LabTestListResponse.fromJson(response);
        labTests.assignAll(labTestList.data);
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> placeOrder(String labTestId) async {
    try {
      UserModel? user = await UserStorage.getUser();
      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return null;
      }

      final response = await ApiService.postRequest('place-an-order', {
        "user_id": user.id.toString(),
        "lab_test_id": labTestId,
      });

      if (response['status'] == "1") {
        String orderId = response['order_id'];
        labTestOrders[labTestId] = orderId;
        return orderId;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to place order';
        return null;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return null;
    }
  }

  Future<bool> confirmOrder({
    required String orderId,
    required String amount,
  }) async {
    try {
      UserModel? user = await UserStorage.getUser();
      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return false;
      }

      final response = await ApiService.postRequest('confirm-order', {
        "order_id": orderId,
        "amount": amount,
        "user_id": user.id.toString(),
      });

      if (response['status'] == "1") {
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Order confirmation failed';
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    }
  }
}
