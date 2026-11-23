import 'package:get/get.dart';
import 'package:human_heal/app/data/models/lab_order_model.dart';
import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/services/user_storage.dart';

class OrderListController extends GetxController {
  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final user = await UserStorage.getUser();
      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      // Sending user_id in the body via your ApiService
      final response = await ApiService.postRequest('order-list', {
        'user_id': user.id.toString(),
      });

      if (response['status']?.toString() == "1") {
        final orderListResponse = OrderListResponse.fromJson(response);
        orders.value = orderListResponse.data;
      } else {
        errorMessage.value = response['message'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load Lab Test: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
