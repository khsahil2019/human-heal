import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/appointment_controller.dart';
import 'package:human_heal/app/controllers/doctor_controller.dart';
import 'package:human_heal/app/modules/appointment/appointment_detail_screen.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class AppointmentTab extends StatefulWidget {
  const AppointmentTab({super.key});

  @override
  State<AppointmentTab> createState() => _AppointmentTabState();
}

class _AppointmentTabState extends State<AppointmentTab> {
  final DoctorController doctorController = Get.put(
    DoctorController(),
    permanent: true,
  );
  final AppointmentController appointmentController = Get.put(
    AppointmentController(),
    permanent: true,
  );

  String selectedStatus = '';

  final List<String> statuses = [
    '', // All
    'Confirmed',
    'Pending',
  ];

  @override
  void initState() {
    super.initState();
    appointmentController.fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        if (appointmentController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: appColor.loaderColor),
          );
        }
        if (appointmentController.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              appointmentController.errorMessage.value,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        // if (appointmentController.appointments.isEmpty) {
        //   return const Center(child: Text("No appointments yet."));
        // }
        if (appointmentController.appointments.isEmpty) {
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
                  "No appointments yet.",
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

        final filteredAppointments = selectedStatus.isEmpty
            ? appointmentController.appointments
            : appointmentController.appointments
                  .where(
                    (appt) =>
                        appt.status.toLowerCase() ==
                        selectedStatus.toLowerCase(),
                  )
                  .toList();

        return Column(
          children: [
            // 🔹 Filter Chips
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: statuses.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
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

            // 🔹 Appointment List
            Expanded(
              child: filteredAppointments.isEmpty
                  ? const Center(
                      child: Text("No appointments for selected status."),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredAppointments.length,
                      itemBuilder: (context, index) {
                        final appt = filteredAppointments[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => AppointmentDetailScreen(appointment: appt),
                            );
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
                                // Doctor Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    left: Radius.circular(16),
                                  ),
                                  child: appt.doctorDetail.image.isNotEmpty
                                      ? Image.network(
                                          appt.doctorDetail.image,
                                          width: 90,
                                          height: 110,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Image.asset(
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

                                // Appointment Info
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Doctor Name
                                        _rowWithIcon(
                                          Icons.person_4,
                                          appt.doctorDetail.name,
                                          color: Colors.blueGrey,
                                          bold: true,
                                        ),

                                        const SizedBox(height: 4),

                                        // Specialization + Qualification
                                        _rowWithIcon(
                                          Icons.medical_services,
                                          "${appt.doctorDetail.specialization}, ${appt.doctorDetail.qualification}",
                                          color: Colors.teal,
                                        ),

                                        const SizedBox(height: 4),

                                        // Hospital + Experience
                                        _rowWithIcon(
                                          Icons.local_hospital,
                                          "${appt.hospitalId.name} • ${appt.doctorDetail.experience} years",
                                          color: Colors.redAccent,
                                        ),

                                        const SizedBox(height: 10),
                                        Text(
                                          "Patient Details",
                                          style: TextStyle(
                                            color: appColor.infoColor,
                                          ),
                                        ),

                                        _rowWithIcon(
                                          Icons.person,
                                          appt.name,
                                          color: Colors.blueGrey,
                                        ),

                                        _rowWithIcon(
                                          Icons.email_outlined,
                                          appt.email,
                                          color: Colors.blueGrey,
                                        ),

                                        _rowWithIcon(
                                          Icons.phone,
                                          appt.mobile,
                                          color: Colors.blueGrey,
                                        ),

                                        _rowWithIcon(
                                          Icons.calendar_today,
                                          appt.date,
                                          color: appColor.primaryBlue,
                                        ),

                                        _rowWithIcon(
                                          Icons.info,
                                          appt.status,
                                          color:
                                              appt.status.toLowerCase() ==
                                                  "confirmed"
                                              ? appColor.primaryColor
                                              : Colors.orange,
                                          bold: true,
                                        ),

                                        // ✅ Retry Payment Button (if Pending)
                                        if (appt.status.toLowerCase() ==
                                            "pending") ...[
                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    appColor.primaryBlue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed: () async {
                                                /// FIX: Removed `fees` (since not in model)
                                                final confirmResponse =
                                                    await doctorController
                                                        .confirmAppointment(
                                                          appointmentId:
                                                              appt.id,
                                                          amount:
                                                              double.tryParse(
                                                                appt
                                                                    .doctorDetail
                                                                    .fees,
                                                              ) ??
                                                              0, // TODO: replace with real fee
                                                        );

                                                if (confirmResponse['status']
                                                        ?.toString() ==
                                                    '1') {
                                                  Get.snackbar(
                                                    "Success",
                                                    "Payment confirmed successfully!",
                                                  );
                                                  appointmentController
                                                      .fetchAppointments();
                                                } else {
                                                  Get.snackbar(
                                                    "Payment Failed",
                                                    confirmResponse['message'] ??
                                                        "Error",
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                "Retry Payment",
                                                style: TextStyle(
                                                  color:
                                                      appColor.backgroundLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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

  /// 🔹 Reusable Row with Icon + Text
  Widget _rowWithIcon(
    IconData icon,
    String text, {
    Color color = Colors.black54,
    bool bold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
              color: color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
