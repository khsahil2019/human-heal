import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/data/constants.dart';
import 'package:human_heal/app/services/token_storage.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/widgets/custom_snackbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:human_heal/app/controllers/wallet_controller.dart';
import 'package:human_heal/app/services/user_storage.dart';

class AddAmountScreen extends StatefulWidget {
  const AddAmountScreen({super.key});

  @override
  State<AddAmountScreen> createState() => _AddAmountScreenState();
}

class _AddAmountScreenState extends State<AddAmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  late Razorpay _razorpay;
  final WalletController _walletController = Get.put(WalletController());

  String? razorpayKeyId;
  String? _currentOrderId;
  String? _currency = 'INR';
  final List<int> _presetAmounts = [50, 100, 200, 500, 1000];

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _fetchPaymentKeys();
  }

  Future<void> _fetchPaymentKeys() async {
    try {
      final token = await TokenStorage.getToken() ?? '';

      log("🟡 [Step 1] Fetching Razorpay Keys...");

      final response = await http.get(
        Uri.parse("${AppConstants.baseUrl}/get-payment-keys"),
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      log("🟡 Payment Key Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status']?.toString() == "1" && data['key_id'] != null) {
          setState(() {
            razorpayKeyId = data['key_id'];
          });
          log("✅ Razorpay Key Loaded: $razorpayKeyId");
        } else {
          CustomSnackbar.show(
            title: "⚠️ Razorpay Key Error",
            message: data['message'] ?? "Key missing in response",
            isError: true,
          );
        }
      } else {
        CustomSnackbar.show(
          title: "⚠️ Server Error",
          message: "Status Code: ${response.statusCode}",
          isError: true,
        );
      }
    } catch (e) {
      log("❌ Error fetching payment keys: $e");
      CustomSnackbar.show(
        title: "⚠️ Fetch Key Exception",
        message: e.toString(),
        isError: true,
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  void _setPresetAmount(int amount) {
    setState(() => _amountController.text = amount.toString());
  }

  Future<void> _proceedToPayment() async {
    final amountText = _amountController.text.trim();
    final double? amount = double.tryParse(amountText);

    log("🟡 [Step 2] Proceeding to payment with amount: $amount");

    if (razorpayKeyId == null) {
      CustomSnackbar.show(
        title: "⚠️ Payment Key Missing",
        message: "Please fetch Razorpay key again.",
        isError: true,
      );
      return;
    }

    if (amount == null || amount <= 0) {
      CustomSnackbar.show(
        title: "⚠️ Invalid Amount",
        message: "Enter a valid amount greater than 0.",
        isError: true,
      );
      return;
    }

    try {
      final user = await UserStorage.getUser();
      final userId = user?.id?.toString() ?? '';
      final token = await TokenStorage.getToken() ?? '';

      log("🟡 [Step 3] Creating Razorpay Order on backend...");
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}/create-order"),
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {"user_id": userId, "amount": amount.toString()},
      );

      log("🟡 Backend Order Response: ${response.body}");
      final orderData = json.decode(response.body);

      if (orderData['status']?.toString() == "1" && orderData['order_id'] != null) {
        _currentOrderId = orderData['order_id'];
        _currency = orderData['currency'] ?? 'INR';
        final keyId = orderData['key_id'] ?? razorpayKeyId;

        log("✅ Order Created. ID: $_currentOrderId, Currency: $_currency");
        // Fetch actual user details
        final userEmail = user?.email ?? 'noemail@example.com';
        final userPhone = user?.mobile ?? '9999999999';

        log(
          "📱 Using User Contact Details -> Email: $userEmail | Phone: $userPhone",
        );
        final options = {
          'key': keyId,
          'amount': (amount * 100).toInt(),
          'name': 'Human Heal',
          'description': 'Wallet Top-up ₹$amount',
          'order_id': _currentOrderId,
          'currency': _currency,
          'timeout': 120,
          'prefill': {'contact': userPhone, 'email': userEmail},
        };

        log("🟡 [Step 4] Opening Razorpay Checkout with options: $options");
        _razorpay.open(options);
      } else {
        CustomSnackbar.show(
          title: "⚠️ Order Creation Failed",
          message: orderData['message'] ?? "Invalid order_id response.",
          isError: true,
        );
      }
    } catch (e) {
      log("❌ Payment initiation error: $e");
      CustomSnackbar.show(
        title: "⚠️ Payment Start Exception",
        message: e.toString(),
        isError: true,
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("✅ [Step 5] Payment Success Response received from Razorpay");
    log(
      "orderId: ${response.orderId}, paymentId: ${response.paymentId}, signature: ${response.signature}",
    );

    if (response.orderId == null ||
        response.paymentId == null ||
        response.signature == null) {
      CustomSnackbar.show(
        title: "⚠️ Razorpay Response Error",
        message:
            "Missing one or more required fields (orderId/paymentId/signature).",
        isError: true,
      );
      return;
    }

    try {
      final user = await UserStorage.getUser();
      final token = await TokenStorage.getToken() ?? '';
      final amount = _amountController.text.trim();

      final body = {
        "user_id": user?.id?.toString() ?? "",
        "amount": amount,
        "order_id": response.orderId!,
        "payment_id": response.paymentId!,
        "signature": response.signature!,
      };

      log("🟡 [Step 6] Sending payment verification to backend: $body");

      final res = await http.post(
        Uri.parse("${AppConstants.baseUrl}/add-wallet"),
        headers: {
          if (token.isNotEmpty) "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: body,
      );

      log("🟢 [Step 7] Backend add-wallet response: ${res.body}");
      final data = json.decode(res.body);

      if (data['status']?.toString() == "1") {
        CustomSnackbar.show(
          title: "✅ Wallet Updated",
          message: data['message'] ?? "₹$amount added successfully!",
          isError: false,
        );
        await _walletController.fetchWalletData();
        Navigator.pop(context);
      } else {
        CustomSnackbar.show(
          title: "⚠️ Wallet Update Failed",
          message: data['message'] ?? "Backend rejected payment update.",
          isError: true,
        );
      }
    } catch (e) {
      log("❌ Error sending payment to backend: $e");
      CustomSnackbar.show(
        title: "⚠️ Add Wallet Exception",
        message: e.toString(),
        isError: true,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log(
      "❌ [Step 5B] Payment Failure: Code ${response.code}, Message: ${response.message}",
    );
    CustomSnackbar.show(
      title: "❌ Payment Failed",
      message: "Code: ${response.code}\n${response.message}",
      isError: true,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("ℹ️ [Step 5C] External Wallet selected: ${response.walletName}");
    CustomSnackbar.show(
      title: "External Wallet Selected",
      message: "Wallet: ${response.walletName}",
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Add Money to Wallet"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter or select the amount to add",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.green,
              decoration: InputDecoration(
                hintText: "💰 Enter custom amount (₹)",
                prefixIcon: const Icon(Icons.currency_rupee),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _presetAmounts.map((amount) {
                final isSelected = _amountController.text == amount.toString();
                return GestureDetector(
                  onTap: () => _setPresetAmount(amount),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? appColor.primaryBlue.withOpacity(0.2)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? appColor.primaryBlue
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      "₹$amount",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? appColor.primaryBlue
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: _proceedToPayment,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: appColor.buttonColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 22,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                "Proceed to Pay",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
