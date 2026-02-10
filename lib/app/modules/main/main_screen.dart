import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:human_heal/app/controllers/main_controller.dart';
import 'package:human_heal/app/modules/lab_order/lab_orderList_screen.dart';

import 'package:human_heal/app/theme/color/appcolor.dart';
import 'package:human_heal/app/modules/appointment/appointment_screen.dart';
import 'package:human_heal/app/modules/home/home_screen.dart';
import 'package:human_heal/app/modules/profile/profile_screen.dart';
import 'package:human_heal/app/modules/wallet/wallet_screen.dart';

// import the controller

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainController controller = Get.put(MainController());

  final List<Widget> _tabs = [
    const HomeTab(),
    const AppointmentTab(),
    const OrderListScreen(),
    WalletTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor.backgroundColor,
      body: Obx(() => _tabs[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -1),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              currentIndex: controller.currentIndex.value,
              selectedItemColor: appColor.primaryBlue,
              unselectedItemColor: appColor.textSecondary,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              onTap: (index) => controller.changeTab(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.event_note_outlined,
                  ), // better for appointments
                  activeIcon: Icon(Icons.event_note),
                  label: 'Appointments',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined), // better for orders
                  activeIcon: Icon(Icons.receipt_long),
                  label: 'Lab Tests',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_outlined),
                  activeIcon: Icon(Icons.account_balance_wallet),
                  label: 'Wallet',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
