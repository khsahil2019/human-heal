// class Doctor {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String gender;
//   final String specialization;
//   final String qualification;
//   final int experience;
//   final String image;
//   final String fees;

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.gender,
//     required this.specialization,
//     required this.qualification,
//     required this.experience,
//     required this.image,
//     required this.fees,
//   });

//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       gender: json['gender'],
//       specialization: json['specialization'],
//       qualification: json['qualification'],
//       experience: json['experience'],
//       image: json['image'] ?? '',
//       fees: json['fees'] ?? '',
//     );
//   }
// }

// class Doctor {
//   final int id;
//   final String name;
//   final String email;
//   final String phone;
//   final String gender;
//   final String specialization;
//   final String qualification;
//   final int experience;
//   final String image;
//   final String fees;

//   Doctor({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.gender,
//     required this.specialization,
//     required this.qualification,
//     required this.experience,
//     required this.image,
//     required this.fees,
//   });

//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       id: json['id'] ?? 0, // ✅ default int
//       name: json['name'] ?? '', // ✅ default string
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       gender: json['gender'] ?? '',
//       specialization: json['specialization'] ?? '',
//       qualification: json['qualification'] ?? '',
//       experience: json['experience'] ?? 0, // ✅ default int
//       image: json['image'] ?? '',
//       fees:
//           json['fees']?.toString() ?? '0', // ✅ handle null + convert to String
//     );
//   }
// }
class Doctor {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String specialization;
  final String qualification;
  final int experience;
  final String image;
  final String fees;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.image,
    required this.fees,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      gender: _parseString(json['gender']),
      specialization: _parseString(json['specialization']),
      qualification: _parseString(json['qualification']),
      experience: _parseInt(json['experience']),
      image: _parseString(json['image']),
      fees: _parseString(json['fees'], defaultValue: '0'),
    );
  }

  /// Utility method to safely parse String values
  static String _parseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString().trim();
  }

  /// Utility method to safely parse int values
  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }
}
