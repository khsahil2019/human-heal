import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/hospital_controller.dart';
import 'package:human_heal/app/controllers/lab_test_controller.dart';
import 'package:human_heal/app/controllers/main_controller.dart';
import 'package:human_heal/app/controllers/profile_controller.dart';
import 'package:human_heal/app/controllers/wallet_controller.dart';
import 'package:human_heal/app/data/models/lab_test_model.dart';
import 'package:human_heal/app/modules/home/hospital/doctor_list_screen.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool showHospitals = true;
  final HospitalController hospitalController = Get.put(HospitalController());
  final LabTestController labTestController = Get.put(LabTestController());
  final ProfileController profileController = Get.put(ProfileController());
  final WalletController walletController = Get.put(WalletController());

  final TextEditingController searchController = TextEditingController();
  var searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    hospitalController.fetchHospitals();
    walletController.fetchWalletData();
    searchController.addListener(() {
      searchQuery.value = searchController.text.trim();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildToggleTabs(),
          const SizedBox(height: 12),
          _buildSearchBar(),
          const SizedBox(height: 12),
          Expanded(
            child: showHospitals ? _buildHospitalList() : _buildLabTestList(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: appColor.primaryBlue,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back,',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                Obx(() {
                  final user = profileController.user.value;
                  return Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
              ],
            ),
            Obx(() {
              final user = profileController.user.value;
              final imageUrl = user?.profilePicture ?? '';
              return GestureDetector(
                onTap: () {
                  Get.find<MainController>().changeTab(4);
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : const AssetImage('assets/imgs/human_heal_logo.jpg')
                            as ImageProvider,
                  backgroundColor: Colors.grey[300],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _buildToggleButton("Hospitals", showHospitals, () {
              setState(() => showHospitals = true);
              hospitalController.fetchHospitals();
            }),
            _buildToggleButton("Lab Tests", !showHospitals, () {
              setState(() => showHospitals = false);
              labTestController.fetchLabTests();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? appColor.primaryBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Search Bar ----------------
  // Inside _HomeTabState
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: searchController,
        cursorColor: Colors.green,
        decoration: InputDecoration(
          hintText: showHospitals
              ? "Search Hospitals..."
              : "Search Lab Tests...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (showHospitals) {
            hospitalController.fetchHospitals(keyword: value);
          } else {
            labTestController.fetchLabTests(keyword: value);
          }
        },
      ),
    );
  }

  // ---------------- Hospital List ----------------
  Widget _buildHospitalList() {
    return Obx(() {
      final filteredHospitals = hospitalController.hospitals.where((hospital) {
        final query = searchQuery.value.toLowerCase();
        final name = hospital.name?.toLowerCase() ?? '';
        final desc = hospital.description?.toLowerCase() ?? '';
        return name.contains(query) || desc.contains(query);
      }).toList();

      if (hospitalController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: appColor.loaderColor),
        );
      }
      if (hospitalController.errorMessage.isNotEmpty) {
        return Center(child: Text(hospitalController.errorMessage.value));
      }
      if (filteredHospitals.isEmpty) {
        return const Center(child: Text("No hospitals found"));
      }
      return ListView.builder(
        itemCount: filteredHospitals.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final hospital = filteredHospitals[index];
          return _buildCard(
            imageUrl:
                (hospital.image != null &&
                    hospital.image!.isNotEmpty &&
                    hospital.image!.startsWith('http'))
                ? hospital.image!
                : "assets/imgs/human_heal_logo.jpg",
            title: hospital.name ?? "Unknown Hospital",
            subtitle: hospital.description ?? "",
            isLabTest: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DoctorListScreen(
                    hospitalName: hospital.name ?? "",
                    hospitalId: hospital.id,
                  ),
                ),
              );
            },
          );
        },
      );
    });
  }

  // ---------------- Lab Test List ----------------
  Widget _buildLabTestList() {
    return Obx(() {
      final filteredTests = labTestController.labTests.where((test) {
        final query = searchQuery.value.toLowerCase();
        final name = test.name?.toLowerCase() ?? '';
        final desc = test.description?.toLowerCase() ?? '';
        return name.contains(query) || desc.contains(query);
      }).toList();

      if (labTestController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: appColor.loaderColor),
        );
      }
      if (labTestController.errorMessage.isNotEmpty) {
        return Center(child: Text(labTestController.errorMessage.value));
      }
      if (filteredTests.isEmpty) {
        return const Center(child: Text("No lab tests found"));
      }
      return ListView.builder(
        itemCount: filteredTests.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final test = filteredTests[index];
          return _buildCard(
            imageUrl:
                (test.image != null &&
                    test.image!.isNotEmpty &&
                    test.image!.startsWith('http'))
                ? test.image!
                : "assets/imgs/human_heal_logo.jpg",
            title: test.name ?? "Unknown Test",
            subtitle: test.description ?? "",
            isLabTest: true,
            price: test.price != null && test.price!.isNotEmpty
                ? "₹${test.price}"
                : null,
            labTest: test,
          );
        },
      );
    });
  }

  Widget _buildCard({
    required String imageUrl,
    required String title,
    required String subtitle,
    required bool isLabTest,
    String? price,
    LabTest? labTest,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              child: imageUrl.startsWith('http')
                  ? Image.network(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/imgs/human_heal_logo.jpg",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      imageUrl,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                    if (isLabTest && price != null && labTest != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Price: $price",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: appColor.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () async {
                            final walletBal = walletController.balance.value;

                            final priceStr =
                                labTest?.price
                                    ?.replaceAll(RegExp(r'[₹,]'), '')
                                    .trim() ??
                                '0';
                            final price = double.tryParse(priceStr) ?? 0.0;

                            if (walletBal < price) {
                              Get.snackbar(
                                'Insufficient Balance',
                                'Your wallet balance is ₹$walletBal, which is less than the required ₹$price.',
                                snackPosition: SnackPosition.BOTTOM,
                                margin: const EdgeInsets.all(16),
                                duration: const Duration(seconds: 3),
                              );
                              return;
                            }

                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Booking'),
                                content: Text(
                                  'Do you want to book the test "$title"?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Confirm'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              final orderId = await labTestController
                                  .placeOrder(labTest!.id.toString());
                              if (orderId != null) {
                                final amount =
                                    labTest.price?.replaceAll('₹', '').trim() ??
                                    '0';
                                final confirmed = await labTestController
                                    .confirmOrder(
                                      orderId: orderId,
                                      amount: amount,
                                    );
                                if (confirmed) {
                                  await walletController.fetchWalletData();
                                  Get.snackbar(
                                    'Success',
                                    'Your order placed and confirmed successfully.',
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(16),
                                    duration: const Duration(seconds: 3),
                                  );
                                } else {
                                  Get.snackbar(
                                    'Error',
                                    labTestController.errorMessage.value,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(16),
                                    duration: const Duration(seconds: 3),
                                  );
                                }
                              } else {
                                Get.snackbar(
                                  'Error',
                                  labTestController.errorMessage.value,
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin: const EdgeInsets.all(16),
                                  duration: const Duration(seconds: 3),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: appColor.primaryBlue,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Book Now",
                            style: TextStyle(color: Colors.white),
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
  }
}
