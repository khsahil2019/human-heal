import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class AppointmentSuccessScreen extends StatelessWidget {
  const AppointmentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🎉 Celebration animation
              Lottie.asset(
                'assets/animations/success_celebration.json',
                width: 200,
                height: 200,
                repeat: true,
              ),

              const SizedBox(height: 20),

              // ✅ Success message
              const Text(
                "Appointment Booked!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Your appointment has been successfully booked. We look forward to seeing you!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 32),

              // 🔙 Back/Home button
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appColor.primaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Back to Home",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
