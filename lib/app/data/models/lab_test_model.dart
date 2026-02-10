class LabTest {
  final int id;
  final String name;
  final String image;
  final String price;
  final String description;
  final double rating; // ✅ Optional rating field

  LabTest({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    this.rating = 4.5, // default if API doesn't send
  });

  factory LabTest.fromJson(Map<String, dynamic> json) {
    return LabTest(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price']?.toString() ?? '',
      description: json['description'] ?? '',
      rating: (json['rating'] != null)
          ? double.tryParse(json['rating'].toString()) ?? 4.5
          : 4.5,
    );
  }
}

class LabTestListResponse {
  final List<LabTest> data;

  LabTestListResponse({required this.data});

  factory LabTestListResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<LabTest> tests = list.map((item) => LabTest.fromJson(item)).toList();
    return LabTestListResponse(data: tests);
  }
}
