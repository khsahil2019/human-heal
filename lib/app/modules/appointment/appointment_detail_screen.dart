import 'package:flutter/material.dart';
import 'package:human_heal/app/data/models/appointment_model.dart';
import 'package:human_heal/app/theme/color/appcolor.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailScreen({Key? key, required this.appointment})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appt = appointment;

    Widget sectionTitle(String title) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: appColor.primaryBlue,
          letterSpacing: 0.3,
        ),
      ),
    );

    Widget infoText(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );

    Color statusColor = appt.status.toLowerCase() == 'confirmed'
        ? appColor.primaryColor
        : (appt.status.toLowerCase() == 'pending'
              ? Colors.orange
              : Colors.grey);

    // Helper to check if string is not null and not empty after trimming
    bool isValid(String? val) => val != null && val.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Details'),
        backgroundColor: appColor.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(34)),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (isValid(appt.doctorDetail.image))
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  appt.doctorDetail.image,
                  width: 160,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'assets/imgs/human_heal_logo.jpg',
                    width: 160,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          else
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/imgs/human_heal_logo.jpg',
                  width: 160,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

          if ([
            isValid(appt.doctorDetail.name),
            isValid(appt.doctorDetail.email),
            isValid(appt.doctorDetail.phone),
            isValid(appt.doctorDetail.specialization),
            isValid(appt.doctorDetail.qualification),
            appt.doctorDetail.experience != null,
            isValid(appt.doctorDetail.gender),
          ].any((e) => e == true))
            sectionTitle('Doctor Information'),

          if (isValid(appt.doctorDetail.name))
            infoText('Name', appt.doctorDetail.name),
          if (isValid(appt.doctorDetail.email))
            infoText('Email', appt.doctorDetail.email),
          if (isValid(appt.doctorDetail.phone))
            infoText('Phone', appt.doctorDetail.phone),
          if (isValid(appt.doctorDetail.specialization) ||
              isValid(appt.doctorDetail.qualification))
            infoText(
              'Specialization',
              '${appt.doctorDetail.specialization ?? ''}'
                  '${isValid(appt.doctorDetail.specialization) && isValid(appt.doctorDetail.qualification) ? ', ' : ''}'
                  '${appt.doctorDetail.qualification ?? ''}',
            ),
          if (appt.doctorDetail.experience != null)
            infoText('Experience', '${appt.doctorDetail.experience} years'),
          if (isValid(appt.doctorDetail.gender))
            infoText('Gender', appt.doctorDetail.gender),

          if (isValid(appt.hospitalId.name) ||
              isValid(appt.hospitalId.description))
            sectionTitle('Hospital Information'),
          if (isValid(appt.hospitalId.name))
            infoText('Name', appt.hospitalId.name),
          if (isValid(appt.hospitalId.description))
            infoText('Description', appt.hospitalId.description),

          if ([
            isValid(appt.name),
            isValid(appt.email),
            isValid(appt.mobile),
            isValid(appt.userDetail.name),
            isValid(appt.userDetail.email),
            isValid(appt.userDetail.mobile),
            isValid(appt.userDetail.dob),
            isValid(appt.userDetail.gender),
            appt.userDetail.height != null,
            appt.userDetail.weight != null,
            isValid(appt.userDetail.bloodGroup),
            isValid(appt.userDetail.address),
            isValid(appt.userDetail.state),
            isValid(appt.userDetail.city),
            isValid(appt.userDetail.pincode),
          ].any((e) => e == true))
            sectionTitle('Patient Information'),
          if (isValid(appt.name)) infoText('Name', appt.name),
          if (isValid(appt.email)) infoText('Email', appt.email),
          if (isValid(appt.mobile)) infoText('Phone', appt.mobile),
          if (isValid(appt.userDetail.name))
            infoText('User Name', appt.userDetail.name),
          if (isValid(appt.userDetail.email))
            infoText('User Email', appt.userDetail.email),
          if (isValid(appt.userDetail.mobile))
            infoText('User Mobile', appt.userDetail.mobile),
          if (isValid(appt.userDetail.dob))
            infoText('DOB', appt.userDetail.dob),
          if (isValid(appt.userDetail.gender))
            infoText('Gender', appt.userDetail.gender),
          if (appt.userDetail.height != null)
            infoText('Height', '${appt.userDetail.height} cm'),
          if (appt.userDetail.weight != null)
            infoText('Weight', '${appt.userDetail.weight} kg'),
          if (isValid(appt.userDetail.bloodGroup))
            infoText('Blood Group', appt.userDetail.bloodGroup),
          if (isValid(appt.userDetail.address))
            infoText('Address', appt.userDetail.address),
          if (isValid(appt.userDetail.state))
            infoText('State', appt.userDetail.state),
          if (isValid(appt.userDetail.city))
            infoText('City', appt.userDetail.city),
          if (isValid(appt.userDetail.pincode))
            infoText('Pincode', appt.userDetail.pincode),

          sectionTitle('Appointment Information'),
          if (isValid(appt.date)) infoText('Date', appt.date),
          if (isValid(appt.comment)) infoText('Comments', appt.comment),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  appt.status,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
