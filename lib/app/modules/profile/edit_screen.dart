import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:intl/intl.dart';
import 'package:human_heal/app/controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodGroupController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedGender = "Male";
  String _profileImageUrl = "";
  File? _profileImageFile;

  late final ProfileController profileController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    profileController = Get.find<ProfileController>();

    final user = profileController.user.value;
    if (user != null) {
      _nameController.text = user.name ?? "";
      _emailController.text = user.email ?? "";
      _phoneController.text = user.mobile ?? "";
      _dobController.text = (user.dob != null && user.dob!.isNotEmpty)
          ? DateFormat('dd/MM/yyyy').format(DateTime.parse(user.dob!))
          : "";
      _heightController.text = user.height?.toString() ?? "";
      _weightController.text = user.weight?.toString() ?? "";
      _bloodGroupController.text = user.bloodGroup ?? "";
      _addressController.text = user.address ?? "";
      _profileImageUrl = user.profilePicture ?? "";
      _selectedGender = (user.gender == "M") ? "Male" : "Female";
    }
  }

  // Future<void> _selectDOB() async {
  //   DateTime initialDate = DateTime.now();
  //   if (_dobController.text.isNotEmpty) {
  //     try {
  //       initialDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
  //     } catch (_) {}
  //   }

  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: initialDate,
  //     firstDate: DateTime(1950),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     setState(() {
  //       _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
  //     });
  //   }
  // }
  Future<void> _selectDOB() async {
    DateTime initialDate = DateTime.now();
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.green, // ✅ selected date + header background
              onPrimary: Colors.white, // ✅ text color on the selected date
              onSurface: Colors.black, // normal text
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _onEditProfileImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
        _profileImageUrl = ""; // Clear URL because using local file now
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() != true) return;

    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: appColor.loaderColor),
      ),
      barrierDismissible: false,
    );

    String? uploadedImageUrl;
    if (_profileImageFile != null) {
      final success = await profileController.updateProfileImage(
        _profileImageFile!,
      );
      if (!success) {
        Get.back();
        Get.snackbar(
          "Error",
          profileController.errorMessage.value.isNotEmpty
              ? profileController.errorMessage.value
              : "Failed to upload profile image",
          snackPosition: SnackPosition.BOTTOM,
          // backgroundColor: Colors.red.shade600,
          // colorText: Colors.white,
        );
        return;
      }
      uploadedImageUrl = profileController.user.value?.profilePicture;
    }

    String dobApiFormat = "";
    if (_dobController.text.isNotEmpty) {
      final dobDate = DateFormat('dd/MM/yyyy').parse(_dobController.text);
      dobApiFormat = DateFormat('yyyy-MM-dd').format(dobDate);
    }

    final heightValue = int.tryParse(_heightController.text.trim());
    final weightValue = int.tryParse(_weightController.text.trim());

    final updateData = {
      "user_id": profileController.user.value?.id.toString() ?? "",
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "mobile": _phoneController.text.trim(),
      "gender": _selectedGender == "Male" ? "M" : "F",
      "dob": dobApiFormat,
      "height": heightValue, // Now int or null
      "weight": weightValue, // Now int or null
      "blood_group": _bloodGroupController.text.trim(),
      "address": _addressController.text.trim(),
      if (uploadedImageUrl != null) "profile_picture": uploadedImageUrl,
    };

    final success = await profileController.updateProfile(updateData);

    Get.back();

    if (success) {
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: Colors.green.shade600,
        // colorText: Colors.white,
      );
      Navigator.pop(context);
    } else {
      Get.snackbar(
        "Error",
        profileController.errorMessage.value.isNotEmpty
            ? profileController.errorMessage.value
            : "Failed to update profile",
        snackPosition: SnackPosition.BOTTOM,
        // backgroundColor: Colors.red.shade600,
        // colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: _profileImageFile != null
                          ? Image.file(
                              _profileImageFile!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : (_profileImageUrl.isNotEmpty
                                ? Image.network(
                                    _profileImageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'assets/imgs/human_heal_logo.jpg',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  )
                                : Image.asset(
                                    'assets/imgs/human_heal_logo.jpg',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )),
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: _onEditProfileImage,
                      tooltip: "Edit Profile Image",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildTextField(label: "Full Name", controller: _nameController),
              _buildTextField(
                label: "Email Address",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                readOnly: true,
              ),
              _buildTextField(
                label: "Mobile Number",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                readOnly: true,
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Gender", style: _labelStyle),
              ),
              const SizedBox(height: 8),
              Row(
                children: ["Male", "Female"].map((gender) {
                  final isSelected = _selectedGender == gender;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedGender = gender),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? appColor.primaryBlue
                              : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          gender,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: "Date of Birth",
                controller: _dobController,
                //   readOnly: true,
                onTap: _selectDOB,
                validator: (value) => null,
              ),
              _buildTextField(
                label: "Height (in cm)",
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              _buildTextField(
                label: "Weight (in kg)",
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: _validateNumber,
              ),
              _buildTextField(
                label: "Blood Group",
                controller: _bloodGroupController,
              ),
              _buildTextField(
                label: "Address",
                controller: _addressController,
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: profileController.isLoading.value
                        ? null
                        : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: appColor.buttonColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: profileController.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
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

  // Widget _buildTextField({
  //   required String label,
  //   required TextEditingController controller,
  //   TextInputType keyboardType = TextInputType.text,
  //   int maxLines = 1,
  //   bool readOnly = false,
  //   VoidCallback? onTap,
  //   String? Function(String?)? validator,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 16),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(label, style: _labelStyle),
  //         const SizedBox(height: 8),
  //         TextFormField(
  //           controller: controller,
  //           keyboardType: keyboardType,
  //           maxLines: maxLines,
  //           readOnly: readOnly,
  //           onTap: onTap,
  //           validator:
  //               validator ??
  //               (value) => (value == null || value.isEmpty)
  //                   ? "Please enter $label"
  //                   : null,
  //           decoration: InputDecoration(
  //             contentPadding: const EdgeInsets.symmetric(
  //               horizontal: 12,
  //               vertical: 14,
  //             ),
  //             filled: true,
  //             fillColor: Colors.white,
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //             enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(24),
  //               borderSide: const BorderSide(color: Colors.grey),
  //             ),
  //             focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(24),
  //               borderSide: const BorderSide(
  //                 color: appColor.primaryColor, // Green color when focused
  //                 width: 2,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle),
          const SizedBox(height: 8),
          TextFormField(
            cursorColor: Colors.green,
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            validator:
                validator ??
                (value) => (value == null || value.isEmpty)
                    ? "Please enter $label"
                    : null,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              filled: true,
              fillColor: readOnly
                  ? Colors.grey.shade200
                  : Colors.white, // 👈 here
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: const BorderSide(
                  color: appColor.primaryColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Please enter Email Address";
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return "Enter a valid email address";
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return "Please enter Mobile Number";
    if (value.length < 10) return "Mobile number must be at least 10 digits";
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) return "This field cannot be empty";
    if (double.tryParse(value) == null) return "Enter a valid number";
    return null;
  }
}
