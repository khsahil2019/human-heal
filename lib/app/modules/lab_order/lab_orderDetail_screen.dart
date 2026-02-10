import 'package:flutter/material.dart';
import 'package:human_heal/app/data/models/lab_order_model.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final user = order.userDetail;
    final labTest = order.labTestDetail;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lab Test Details"),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0.5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lab Test Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: appColor.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    labTest.name,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: appColor.primaryBlue,
                      letterSpacing: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: labTest.image.isNotEmpty
                        ? Image.network(
                            labTest.image,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/imgs/human_heal_logo.jpg',
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            'assets/imgs/human_heal_logo.jpg',
                            height: 180,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: appColor.primaryBlue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labTest.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Patient Details Section
            sectionTitle('Patient Details'),
            infoRow('Name', user.name),
            infoRow('Email', user.email),
            infoRow('Mobile', user.mobile),
            infoRow('Gender', user.gender),
            infoRow('DOB', user.dob),
            infoRow('Height', '${user.height} cm'),
            infoRow('Weight', '${user.weight} kg'),
            infoRow('Blood Group', user.bloodGroup),
            infoRow(
              'Address',
              '${user.address}, ${user.city}, ${user.state} - ${user.pincode}',
            ),

            const SizedBox(height: 32),

            // Order Info Section
            sectionTitle('Order Info'),
            // infoRow(
            //   'Order ID',
            //   order.savedOrderId,
            // ), // <-- Show savedOrderId here
            infoRow(
              'Status',
              order.status,
              valueColor: order.status.toLowerCase() == 'confirmed'
                  ? appColor.primaryColor
                  : Colors.orange,
            ),
            infoRow('Created At', order.createdAt),
            infoRow('Price', labTest.price),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: appColor.primaryBlue,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.black87,
                fontWeight: valueColor != null
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
