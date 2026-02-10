import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/data/models/wallet_model.dart';
import 'package:human_heal/app/services/api_service.dart';
import 'package:human_heal/app/services/user_storage.dart';

class WalletController extends GetxController {
  var isLoading = false.obs;
  var balance = 0.0.obs;
  var transactions = <TransactionModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    log("🔹 WalletController onInit called");
    fetchWalletData();
  }

  Future<void> fetchWalletData() async {
    try {
      log("🔹 Fetching wallet data...");
      isLoading.value = true;
      errorMessage.value = '';

      final user = await UserStorage.getUser();
      log("🔹 User fetched: $user");

      if (user == null || user.id == null) {
        errorMessage.value = 'User not logged in';
        log("❌ User not logged in");
        return;
      }

      final userId = user.id.toString();
      log("🔹 userId: $userId");

      await Future.wait([
        fetchWalletBalance(userId),
        fetchTransactions(userId),
      ]);

      log("✅ Wallet data fetched successfully");
    } catch (e, st) {
      errorMessage.value = e.toString();
      log("❌ Error in fetchWalletData: $e");
      log("$st");
    } finally {
      isLoading.value = false;
      log("🔹 isLoading set to false");
    }
  }

  Future<void> fetchWalletBalance(String userId) async {
    try {
      log("🔹 Fetching wallet balance for $userId...");
      final response = await ApiService.postRequest('get-user-wallet-balance', {
        'user_id': userId,
      });

      log("🔸 fetchWalletBalance response: $response");

      if (response['status'] == '1') {
        final walletBalance = WalletBalanceModel.fromJson(response['data']);
        balance.value = walletBalance.balance;
        log("✅ Wallet balance updated: ${balance.value}");
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load balance';
        log("❌ Failed to load balance: ${response['message']}");
      }
    } catch (e, st) {
      errorMessage.value = 'Failed to load balance: $e';
      log("❌ Error in fetchWalletBalance: $e");
      log("$st");
    }
  }

  Future<void> fetchTransactions(String userId) async {
    try {
      log("🔹 Fetching transactions for $userId...");
      final response = await ApiService.postRequest('wallet-list', {
        'user_id': userId,
      });

      log("🔸 fetchTransactions response: $response");

      if (response['status'] == '1') {
        final data = response['data'] as List;
        transactions.value = data
            .map((e) => TransactionModel.fromJson(e))
            .toList();
        log("✅ Transactions updated. Count: ${transactions.length}");
      } else {
        errorMessage.value =
            response['message'] ?? 'Failed to load transactions';
        log("❌ Failed to load transactions: ${response['message']}");
      }
    } catch (e, st) {
      errorMessage.value = 'Failed to load transactions: $e';
      log("❌ Error in fetchTransactions: $e");
      log("$st");
    }
  }

  // Future<bool> addMoneyToWallet({
  //   required String transactionId,
  //   required double amount,
  //   required String paymentMethod,
  //   String paymentStatus = 'success',
  //   String responsePayload = '',
  // }) async {
  //   try {
  //     log("🔹 Adding money to wallet: $amount via $paymentMethod");
  //     final user = await UserStorage.getUser();
  //     if (user == null || user.id == null) {
  //       errorMessage.value = 'User not logged in';
  //       log("❌ User not logged in");
  //       return false;
  //     }

  //     final body = {
  //       "user_id": user.id.toString(),
  //       "amount": amount.toString(),
  //       "transaction_id": transactionId,
  //       "payment_method": paymentMethod,
  //       "payment_status": paymentStatus,
  //       "response_payload": responsePayload,
  //     };

  //     log("🔹 addMoneyToWallet request body: $body");

  //     final response = await ApiService.postRequest('add-wallet', body);

  //     log("🔸 addMoneyToWallet response: $response");

  //     if (response['status'] == '1') {
  //       await fetchWalletBalance(user.id.toString());
  //       log("✅ Money added successfully to wallet");
  //       return true;
  //     } else {
  //       errorMessage.value = response['message'] ?? 'Failed to add money';
  //       log("❌ Failed to add money: ${response['message']}");
  //       return false;
  //     }
  //   } catch (e, st) {
  //     errorMessage.value = 'Failed to add money: $e';
  //     log("❌ Error in addMoneyToWallet: $e");
  //     log("$st");
  //     return false;
  //   }
  // }
}
