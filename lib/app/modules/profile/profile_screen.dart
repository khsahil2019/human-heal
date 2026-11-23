import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/main_controller.dart';
import 'package:human_heal/app/controllers/profile_controller.dart';
import 'package:human_heal/app/modules/auth/change_passpword_screen.dart';
import 'package:human_heal/app/modules/lab_order/lab_orderList_screen.dart';

import 'package:human_heal/app/modules/profile/delete_account_screen.dart';
import 'package:human_heal/app/modules/profile/edit_screen.dart';

import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final mainController =
        Get.find<MainController>(); // find the main controller

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final user = controller.user.value;

        return user == null
            ? const Center(
                child: CircularProgressIndicator(color: appColor.loaderColor),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Profile Info
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                appColor.primaryBlue.withOpacity(0.2),
                                appColor.primaryBlue.withOpacity(0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: appColor.primaryBlue.withOpacity(0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(4), // Border thickness
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(
                              2,
                            ), // Optional extra inner padding
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                (user.profilePicture != null &&
                                        user.profilePicture!.isNotEmpty)
                                    ? user.profilePicture!
                                    : 'https://via.placeholder.com/150',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name ?? 'User Name',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          user.email ?? 'User Email',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Option tiles
                    ProfileOptionTile(
                      icon: Icons.event_note_outlined,
                      label: "My Appointments",
                      onTap: () {
                        mainController.changeTab(1);
                        //   Get.to(() => const AddAmountScreen());
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileOptionTile(
                      icon: Icons.receipt_long,
                      label: "Lab Test History",
                      onTap: () {
                        // TODO: Replace with screen
                        // Get.to(() => const OrderListScreen());
                        mainController.changeTab(2);
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileOptionTile(
                      icon: Icons.person_outline,
                      label: "Edit Profile",
                      onTap: () {
                        Get.to(() => const EditProfileScreen());
                      },
                    ),
                    const SizedBox(height: 12),
                    ProfileOptionTile(
                      icon: Icons.lock_outline,
                      label: "Change Password",
                      onTap: () {
                        Get.to(() => const ChangePasswordScreen());
                      },
                    ),
                    const SizedBox(height: 12),

                    ProfileOptionTile(
                      icon: Icons.delete_outline,
                      label: "Delete Account",
                      iconColor: Colors.red,
                      textColor: Colors.red,
                      onTap: () {
                        Get.to(() => const DeleteAccountScreen());
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard, color: Colors.grey),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Your Referral Code",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Text(
                                //   user.usercode ?? "N/A",
                                //   style: const TextStyle(
                                //     fontSize: 18,
                                //     fontWeight: FontWeight.bold,
                                //     color: Colors.black,
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          // ✅ Copy Button
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.grey),
                            onPressed: () {
                              if (user.usercode != null &&
                                  user.usercode!.isNotEmpty) {
                                Clipboard.setData(
                                  ClipboardData(text: user.usercode!),
                                );
                                Get.snackbar(
                                  "Copied",
                                  "Referral code ${user.usercode} copied to clipboard",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(8),
                                );
                              }
                            },
                          ),

                          // ✅ Share Button
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.green),
                            onPressed: () {
                              if (user.usercode != null &&
                                  user.usercode!.isNotEmpty) {
                                final shareMessage =
                                    "Hey! Use my referral code ${user.usercode} while signing up on Human Heal App!\n\n"
                                    "📲 Download the app here:\n"
                                    "https://play.google.com/store/apps/details?id=com.human.health&hl=en_IN";
                                Share.share(shareMessage);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ProfileOptionTile(
                      icon: Icons.logout,
                      label: "Logout",
                      iconColor: appColor.primaryBlue,
                      textColor: appColor.primaryBlue,
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: const Text(
                              "Logout",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              "Are you sure you want to logout?",
                            ),
                            actionsPadding: const EdgeInsets.only(
                              bottom: 12,
                              right: 12,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  Get.back();
                                  controller.logout();
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
      }),
    );
  }
}

class ProfileOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color textColor;
  final Color iconColor;

  const ProfileOptionTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.textColor = Colors.black,
    this.iconColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
