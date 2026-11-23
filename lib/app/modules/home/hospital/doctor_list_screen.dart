import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/modules/home/hospital/book_appointment.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

import '../../../controllers/doctor_controller.dart';
import '../../../controllers/wallet_controller.dart';
import '../../../data/models/doctor_model.dart';

class DoctorListScreen extends StatefulWidget {
  final String hospitalName;
  final int hospitalId;

  const DoctorListScreen({
    super.key,
    required this.hospitalName,
    required this.hospitalId,
  });

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final DoctorController doctorController = Get.put(DoctorController());
  late final WalletController walletController;

  @override
  void initState() {
    super.initState();
    walletController = Get.isRegistered<WalletController>()
        ? Get.find<WalletController>()
        : Get.put(WalletController());
    doctorController.fetchDoctors(hospitalId: widget.hospitalId);
  }

  // Mask mobile to show only last 4 digits
  String maskMobile(String mobile) {
    if (mobile.length <= 4) return mobile;
    return "****" + mobile.substring(mobile.length - 4);
  }

  // Mask email: show first 2 letters, then ***, then domain
  String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 2) {
      return email.replaceRange(1, atIndex, '***');
    }
    String start = email.substring(0, 2);
    String domain = email.substring(atIndex);
    return "$start***$domain";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hospitalName),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.white,
      // backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (doctorController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: appColor.loaderColor),
          );
        }
        if (doctorController.errorMessage.isNotEmpty) {
          return Center(child: Text(doctorController.errorMessage.value));
        }
        // if (doctorController.doctors.isEmpty) {
        //   return const Center(child: Text("No doctors found"));
        // }
        if (doctorController.doctors.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Yaha apni PNG image lagao
                Image.asset(
                  'assets/imgs/found1.jpg', // apni PNG ka path yaha lagayein
                  // width: 150,
                  // height: 150,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No doctors found",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: doctorController.doctors.length,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            Doctor doc = doctorController.doctors[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
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
                  // Left Side: Doctor Image Only
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: doc.image.isNotEmpty
                        ? Image.network(
                            doc.image,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                                  "assets/imgs/human_heal_logo.jpg",
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                          )
                        : Image.asset(
                            "assets/imgs/human_heal_logo.jpg",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 14),

                  // Right Side: Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Doctor Name
                        Text(
                          doc.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Specialization below name
                        Text(
                          doc.specialization,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Qualification with Icon
                        if (doc.qualification.isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.school,
                                size: 16,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  doc.qualification,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                        const SizedBox(height: 8),

                        // Experience
                        Row(
                          children: [
                            const Icon(
                              Icons.work_outline,
                              size: 16,
                              color: Colors.black54,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${doc.experience} years",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Fees with Icon
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_rupee,
                              size: 18,
                              color: Colors.green,
                            ),
                            Text(
                              doc.fees,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Book Appointment Button (Full Width)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final feeStr = doc.fees
                                  .replaceAll(RegExp(r'[₹,Rs.\s]'), '')
                                  .trim();
                              final fee = double.tryParse(feeStr) ?? 0.0;
                              final walletBal = walletController.balance.value;

                              if (walletBal < fee) {
                                Get.snackbar(
                                  'Insufficient Balance',
                                  'Your wallet balance is ₹${walletBal.toStringAsFixed(2)}, but booking requires ₹${fee.toStringAsFixed(2)}.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                  duration: const Duration(seconds: 3),
                                );
                                return;
                              }

                              Get.to(
                                () => BookAppointmentScreen(
                                  doctorName: doc.name,
                                  doctorImage: doc.image.isNotEmpty
                                      ? doc.image
                                      : "assets/imgs/human_heal_logo.jpg",
                                  hospitalId: widget.hospitalId,
                                  doctorId: doc.id,
                                  doctorFees: doc.fees,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Book Appointment",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: appColor.primaryBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
