import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/services/token_storage.dart';
import 'package:human_heal/app/services/user_storage.dart';
import 'package:human_heal/app/data/models/user_model.dart';
import 'package:human_heal/app/data/constants.dart';
import 'package:human_heal/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  var user = Rxn<UserModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final storedUser = await UserStorage.getUser();

      if (storedUser == null || storedUser.id == null) {
        errorMessage.value = 'User not logged in';
        return;
      }

      final response = await ApiService.postRequest("edit-profile", {
        "user_id": storedUser.id.toString(),
      });

      if (response['status']?.toString() == "1") {
        user.value = UserModel.fromJson(response['data']);
        await UserStorage.saveUser(user.value!);
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load profile';
      }
    } catch (e) {
      errorMessage.value = 'Error loading user data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile(Map<String, dynamic> updatedData) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final currentUser = user.value ?? await UserStorage.getUser();
      if (currentUser == null || currentUser.id == null) {
        errorMessage.value = 'User not logged in';
        return false;
      }

      updatedData['user_id'] = currentUser.id.toString();

      // Convert height and weight to int if they are strings
      if (updatedData['height'] is String) {
        updatedData['height'] = int.tryParse(updatedData['height']) ?? 0;
      }
      if (updatedData['weight'] is String) {
        updatedData['weight'] = int.tryParse(updatedData['weight']) ?? 0;
      }

      final response = await ApiService.postRequest(
        "update-profile",
        updatedData,
      );

      if (response['status']?.toString() == "1") {
        user.value = UserModel.fromJson(response['data']);
        await UserStorage.saveUser(user.value!);
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to update profile';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error updating profile: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Future<bool> updateProfileImage(File imageFile) async {
  //   isLoading.value = true;
  //   errorMessage.value = '';

  //   try {
  //     final currentUser = user.value ?? await UserStorage.getUser();
  //     if (currentUser == null || currentUser.id == null) {
  //       errorMessage.value = 'User not logged in';
  //       return false;
  //     }

  //     final uri = Uri.parse('${AppConstants.baseUrl}/update-profile-picture');
  //     final request = http.MultipartRequest('POST', uri);

  //     final token = await TokenStorage.getToken();
  //     if (token != null && token.isNotEmpty) {
  //       request.headers['Authorization'] = 'Bearer $token';
  //     }
  //     request.headers['Accept'] = 'application/json';

  //     request.fields['user_id'] = currentUser.id.toString();
  //     request.files.add(
  //       await http.MultipartFile.fromPath('image', imageFile.path),
  //     );

  //     final streamedResponse = await request.send();
  //     final response = await http.Response.fromStream(streamedResponse);

  //     final Map<String, dynamic> responseData = jsonDecode(response.body);

  //     if (responseData['status'] == "1") {
  //       user.value = UserModel.fromJson(responseData['data']);
  //       await UserStorage.saveUser(user.value!);
  //       return true;
  //     } else {
  //       errorMessage.value =
  //           responseData['message'] ?? 'Failed to update profile picture';
  //       return false;
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'Error updating profile image: $e';
  //     return false;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  Future<bool> updateProfileImage(File imageFile) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final currentUser = user.value ?? await UserStorage.getUser();
      if (currentUser == null || currentUser.id == null) {
        errorMessage.value = 'User not logged in';
        return false;
      }

      final uri = Uri.parse('${AppConstants.baseUrl}/update-profile-picture');
      final request = http.MultipartRequest('POST', uri);

      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      request.fields['user_id'] = currentUser.id.toString();
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // ✅ Debug logs for better visibility
      print("📡 API Response Code: ${response.statusCode}");
      print("📡 API Raw Response: ${response.body}");

      if (response.statusCode != 200) {
        errorMessage.value = "Server error: ${response.statusCode}";
        return false;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData['status'] == "1") {
        final dynamic data = responseData['data'];

        if (data != null && data is Map<String, dynamic>) {
          // ✅ Properly parse user data if available
          user.value = UserModel.fromJson(data);
          await UserStorage.saveUser(user.value!);
        } else if (responseData.containsKey('profile_picture')) {
          // ✅ Fallback: update only profilePicture safely
          user.value = user.value?.copyWith(
            profilePicture: responseData['profile_picture']?.toString() ?? "",
          );
          if (user.value != null) {
            await UserStorage.saveUser(user.value!);
          }
        } else {
          // ✅ If neither data nor profile_picture is available, don't crash
          print("⚠️ No data/profile_picture found in API response");
        }

        return true;
      } else {
        errorMessage.value =
            responseData['message']?.toString() ??
            'Failed to update profile picture';
        return false;
      }
    } catch (e, stackTrace) {
      print("❌ Exception while updating profile image: $e");
      print(stackTrace);
      errorMessage.value = 'Error updating profile image: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();
    await UserStorage.clearUser();
    Get.offAllNamed(AppRoutes.LOGIN);
  }

  Future<bool> deleteAccount() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final currentUser = user.value ?? await UserStorage.getUser();
      if (currentUser == null || currentUser.id == null) {
        errorMessage.value = 'User not logged in';
        return false;
      }

      final response = await ApiService.postRequest("delete-account", {
        "user_id": currentUser.id.toString(),
      });

      if (response['status']?.toString() == "1") {
        await TokenStorage.clearToken();
        await UserStorage.clearUser();
        Get.offAllNamed(AppRoutes.LOGIN);
        Get.snackbar(
          "Account Deleted",
          response['message']?.toString() ?? "Your account has been deleted.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        errorMessage.value =
            response['message']?.toString() ?? 'Failed to delete account';
        Get.snackbar(
          "Error",
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Error deleting account: $e';
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
