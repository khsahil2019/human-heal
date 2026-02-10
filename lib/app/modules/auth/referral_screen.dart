import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/referral_controller.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/widgets/app_text_field.dart'; // Import your custom text field

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _patientNameController = TextEditingController();
  final _referalFromController = TextEditingController();
  final _commentController = TextEditingController();

  String? _selectedDoctorId;
  final _formKey = GlobalKey<FormState>();

  final ReferralController _controller = Get.put(ReferralController());

  @override
  void initState() {
    super.initState();
    _controller.fetchDoctors();
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _referalFromController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDoctorId == null) {
      Get.snackbar('Error', 'Please select a doctor');
      return;
    }

    final success = await _controller.submitReferral(
      patientName: _patientNameController.text.trim(),
      referalFrom: _referalFromController.text.trim(),
      referalTo: _selectedDoctorId!,
      comment: _commentController.text.trim(),
    );

    if (success) {
      _formKey.currentState!.reset();
      setState(() {
        _selectedDoctorId = null;
      });
      _patientNameController.clear();
      _referalFromController.clear();
      _commentController.clear();

      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Referral"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      backgroundColor: appColor.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          if (_controller.isLoadingDoctors.value) {
            return const Center(
              child: CircularProgressIndicator(color: appColor.loaderColor),
            );
          }

          return Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Patient Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                AppTextField(
                  controller: _patientNameController,
                  hintText: 'Enter patient name',
                  //   labelText: 'Patient Name',
                  prefixIcon: Icons.person,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter patient name'
                      : null,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Referal From',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _referalFromController,
                  hintText: 'Enter referral from',
                  //  labelText: 'Referral From',
                  prefixIcon: Icons.local_hospital,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter referral from'
                      : null,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Refer to Doctor',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedDoctorId,
                  decoration: InputDecoration(
                    labelText: 'Referral To (Doctor)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _controller.doctorList
                      .map(
                        (doctor) => DropdownMenuItem<String>(
                          value: doctor['id'],
                          child: Text(doctor['name']),
                        ),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedDoctorId = val;
                    });
                  },
                  validator: (val) =>
                      val == null ? 'Please select a doctor' : null,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Comment (Optional)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor.textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _commentController,
                  hintText: 'Enter comment',
                  //  labelText: 'Comment',
                  //  maxLines: 3,
                  prefixIcon: Icons.comment,
                ),
                const SizedBox(height: 24),
                Obx(() {
                  return ElevatedButton(
                    onPressed: _controller.isSubmitting.value ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appColor.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: _controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Submit Referral',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
