import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/modules/home/hospital/appointmentSuccess.dart';
import 'package:intl/intl.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

import '../../../controllers/doctor_controller.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String doctorImage;
  final int hospitalId;
  final int doctorId;
  final String doctorFees; // Add fees for confirmation

  const BookAppointmentScreen({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.hospitalId,
    required this.doctorId,
    required this.doctorFees,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final DoctorController doctorController = Get.find();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _commentController = TextEditingController();
  final _dateController = TextEditingController();

  bool _isLoading = false;

  // Future<void> _selectDate() async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(const Duration(days: 365)),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
  //     });
  //   }
  // }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.green, // ✅ Header & selected date color
              onPrimary: Colors.white, // ✅ Text on header
              onSurface: Colors.black, // ✅ Default text color
            ),
            dialogBackgroundColor: Colors.white, // ✅ Calendar background
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submitAppointment() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Call book appointment API
      final bookResponse = await doctorController.bookAppointment(
        hospitalId: widget.hospitalId,
        doctorId: widget.doctorId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _phoneController.text.trim(),
        date: _dateController.text.trim(),
        comment: _commentController.text.trim(),
      );

      if (bookResponse['status'] == '1') {
        // Appointment booked successfully, now confirm
        final appointmentId =
            int.tryParse(bookResponse['appointment_id'].toString()) ?? 0;

        // Parse fees amount (remove Rs and commas)
        final feeStr = widget.doctorFees.replaceAll(RegExp(r'[₹Rs., ]'), '');
        final fee = double.tryParse(feeStr) ?? 0.0;

        final confirmResponse = await doctorController.confirmAppointment(
          appointmentId: appointmentId,
          amount: fee,
        );

        if (confirmResponse['status'] == '1') {
          // Success - navigate to success screen
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const AppointmentSuccessScreen(),
              ),
            );
          }
        } else {
          // Confirmation failed (maybe already confirmed)
          Get.snackbar(
            "Confirmation Error",
            confirmResponse['message'] ?? 'Failed to confirm appointment',
            snackPosition: SnackPosition.BOTTOM,
            // backgroundColor: Colors.red.withOpacity(0.8),
            // colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          "Booking Failed",
          bookResponse['message'] ?? 'Failed to book appointment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Appointment"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Doctor Info Header
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: widget.doctorImage.startsWith('http')
                          ? Image.network(
                              widget.doctorImage,
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
                              widget.doctorImage,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildTextField(label: "Full Name", controller: _nameController),
              _buildTextField(
                label: "Email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                label: "Phone Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                label: "Comment",
                controller: _commentController,
                maxLines: 3,
              ),
              _buildTextField(
                label: "Select Date",
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: appColor.buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Book Appointment",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle get _labelStyle =>
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            validator: (value) =>
                (value == null || value.isEmpty) ? "Please enter $label" : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: Colors.green, width: 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
