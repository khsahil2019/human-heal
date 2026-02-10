import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/wallet_controller.dart';
import 'package:human_heal/app/modules/wallet/add_amount_screen.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class WalletTab extends StatelessWidget {
  WalletTab({Key? key}) : super(key: key);

  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Wallet"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: appColor.loaderColor),
          );
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Wallet Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appColor.primaryBlue,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Wallet Balance",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "₹${controller.balance.value.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddAmountScreen(),
                          ),
                        ).then((_) {
                          controller.fetchWalletData();
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Add Amount"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: appColor.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Transactions Header
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (controller.transactions.isEmpty)
                const Text('No transactions found'),

              ...controller.transactions.map((tx) {
                final isCredit = tx.type == "Credit";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: isCredit
                          ? Colors.green[100]
                          : Colors.red[100],
                      child: Icon(
                        isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isCredit ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      tx.transactionHistory.isNotEmpty
                          ? tx.transactionHistory
                          : "No description",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date & Time
                        Text(
                          "${tx.createdAt.toLocal().toString().split(' ')[0]} • ${tx.createdAt.toLocal().toString().split(' ')[1].substring(0, 5)}",
                        ),
                        const SizedBox(height: 4),
                        // Txn ID
                        Text(
                          "Txn ID: ${tx.transactionId}",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Small Status Container
                        // Small Status Container (light color with border)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isCredit
                                ? Colors.green[50]
                                : Colors.red[50], // light fill
                            border: Border.all(
                              color: isCredit
                                  ? Colors.green
                                  : Colors.red, // border color
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            isCredit ? "Credited" : "Debited",
                            style: TextStyle(
                              color: isCredit ? Colors.green : Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Text(
                      "${isCredit ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: isCredit ? appColor.primaryColor : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}
