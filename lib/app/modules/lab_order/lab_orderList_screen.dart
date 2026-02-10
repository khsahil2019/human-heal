import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/lab_order_controller.dart';
import 'package:human_heal/app/controllers/lab_test_controller.dart';
import 'package:human_heal/app/modules/lab_order/lab_orderDetail_screen.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  final OrderListController orderListController = Get.put(
    OrderListController(),
    permanent: true,
  );

  String selectedStatus = '';

  final List<String> statuses = [
    '', // means All
    'Confirmed',
    'Pending',
    // 'Cancelled',
  ];

  @override
  void initState() {
    super.initState();
    // orderListController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Tests"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (orderListController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: appColor.loaderColor),
          );
        }
        if (orderListController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              orderListController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (orderListController.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/imgs/appointment.png', // ✅ yaha apni image ka path do
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No Lab Tests yet.",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          );
        }

        final filteredOrders = selectedStatus.isEmpty
            ? orderListController.orders
            : orderListController.orders
                  .where(
                    (order) =>
                        order.status.toLowerCase() ==
                        selectedStatus.toLowerCase(),
                  )
                  .toList();

        return Column(
          children: [
            // Horizontal Chips filter
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: statuses.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final status = statuses[index];
                  final isSelected = selectedStatus == status;
                  return ChoiceChip(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    label: Text(
                      status.isEmpty ? 'All' : status,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: Colors.green,
                    backgroundColor: Colors.grey[300],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedStatus = selected ? status : '';
                      });
                    },
                  );
                },
              ),
            ),

            // Orders List
            Expanded(
              child: filteredOrders.isEmpty
                  ? const Center(
                      child: Text("No Lab Tests for selected status."),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        final user = order.userDetail;
                        final labTest = order.labTestDetail;

                        return GestureDetector(
                          onTap: () {
                            Get.to(() => OrderDetailScreen(order: order));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                  child: user.profilePicture.isNotEmpty
                                      ? Image.network(
                                          user.profilePicture,
                                          width: 90,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Image.asset(
                                                'assets/imgs/human_heal_logo.jpg',
                                                width: 90,
                                                height: 110,
                                                fit: BoxFit.cover,
                                              ),
                                        )
                                      : Image.asset(
                                          'assets/imgs/human_heal_logo.jpg',
                                          width: 90,
                                          height: 110,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Lab Test Name
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.biotech,
                                              size: 18,
                                              color: appColor.primaryBlue,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                labTest.name,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),

                                        // Patient Name
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(child: Text(user.name)),
                                          ],
                                        ),

                                        // Email
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.email,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                user.email,
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        // Status
                                        // Status
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.info,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),

                                            if (order.status.toLowerCase() ==
                                                    "pending" ||
                                                order.status.toLowerCase() ==
                                                    "payment pending")
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  // retry payment using order_id
                                                  final success =
                                                      await Get.find<
                                                            LabTestController
                                                          >()
                                                          .confirmOrder(
                                                            orderId: order.id
                                                                .toString(),
                                                            amount:
                                                                (double.tryParse(
                                                                          order
                                                                              .labTestDetail
                                                                              .price,
                                                                        ) ??
                                                                        0)
                                                                    .toString(), // ✅ safe conversion
                                                          );

                                                  if (success) {
                                                    Get.snackbar(
                                                      "Payment",
                                                      "Payment confirmed successfully",
                                                      backgroundColor:
                                                          Colors.green,
                                                      colorText: Colors.white,
                                                    );
                                                    orderListController
                                                        .fetchOrders(); // refresh list
                                                  } else {
                                                    Get.snackbar(
                                                      "Payment",
                                                      "Retry failed. Please try again",
                                                      backgroundColor:
                                                          Colors.red,
                                                      colorText: Colors.white,
                                                    );
                                                  }
                                                },
                                                child: const Text(
                                                  "Retry Payment",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            else
                                              Text(
                                                order.status,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      order.status
                                                              .toLowerCase() ==
                                                          "confirmed"
                                                      ? appColor.primaryColor
                                                      : Colors.orange,
                                                ),
                                              ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        // Date
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: appColor.primaryBlue,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(order.createdAt),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
