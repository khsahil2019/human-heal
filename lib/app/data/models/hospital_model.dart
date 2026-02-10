class Hospital {
  final int id;
  final String name;
  final String image;
  final String description;

  Hospital({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class HospitalListResponse {
  final String status;
  final String message;
  final List<Hospital> data;

  HospitalListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HospitalListResponse.fromJson(Map<String, dynamic> json) {
    return HospitalListResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => Hospital.fromJson(item))
          .toList(),
    );
  }
}
