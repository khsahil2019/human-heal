class AppointmentListResponse {
  final String status;
  final String message;
  final List<Appointment> data;

  AppointmentListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AppointmentListResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentListResponse(
      status: json['status'].toString(),
      message: json['message'].toString(),
      data: (json['data'] as List)
          .map((item) => Appointment.fromJson(item))
          .toList(),
    );
  }
}

class Appointment {
  final int id;
  final UserDetail userDetail;
  final DoctorDetail doctorDetail;
  final Hospital hospitalId;
  final String name;
  final String email;
  final String mobile;
  final String date;
  final String comment;
  final String status;

  Appointment({
    required this.id,
    required this.userDetail,
    required this.doctorDetail,
    required this.hospitalId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.date,
    required this.comment,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: parseInt(json['id']),
      userDetail: UserDetail.fromJson(json['user_detail']),
      doctorDetail: DoctorDetail.fromJson(json['doctor_detail']),
      hospitalId: Hospital.fromJson(json['hospital_id']),
      name: json['name'].toString(),
      email: json['email'].toString(),
      mobile: json['mobile'].toString(),
      date: json['date'].toString(),
      comment: json['comment'].toString(),
      status: json['status'].toString(),
    );
  }
}

class UserDetail {
  final int id;
  final String name;
  final String email;
  final String mobile;
  final String token;
  final String profilePicture;
  final String gender;
  final String dob;
  final int height;
  final int weight;
  final String bloodGroup;
  final String address;
  final String state;
  final String city;
  final String pincode;

  UserDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.token,
    required this.profilePicture,
    required this.gender,
    required this.dob,
    required this.height,
    required this.weight,
    required this.bloodGroup,
    required this.address,
    required this.state,
    required this.city,
    required this.pincode,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: parseInt(json['id']),
      name: json['name'].toString(),
      email: json['email'].toString(),
      mobile: json['mobile'].toString(),
      token: json['token'].toString(),
      profilePicture: json['profile_picture'].toString(),
      gender: json['gender'].toString(),
      dob: json['dob'].toString(),
      height: parseInt(json['height']),
      weight: parseInt(json['weight']),
      bloodGroup: json['blood_group'].toString(),
      address: json['address'].toString(),
      state: json['state'].toString(),
      city: json['city'].toString(),
      pincode: json['pincode'].toString(),
    );
  }
}

class DoctorDetail {
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String specialization;
  final String qualification;
  final int experience;
  final String image;
  final String fees; // ✅ added

  DoctorDetail({
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.image,
    required this.fees, // ✅ added
  });

  factory DoctorDetail.fromJson(Map<String, dynamic> json) {
    return DoctorDetail(
      name: json['name'].toString(),
      email: json['email'].toString(),
      phone: json['phone'].toString(),
      gender: json['gender'].toString(),
      specialization: json['specialization'].toString(),
      qualification: json['qualification'].toString(),
      experience: parseInt(json['experience']),
      image: json['image'].toString(),
      fees: json['fees']?.toString() ?? '0', // ✅ added
    );
  }
}

class Hospital {
  final String name;
  final String description;
  final String image;

  Hospital({
    required this.name,
    required this.description,
    required this.image,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      name: json['name'].toString(),
      description: json['description'].toString(),
      image: json['image'].toString(),
    );
  }
}

/// Helper to safely parse int values from dynamic JSON fields
int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}
