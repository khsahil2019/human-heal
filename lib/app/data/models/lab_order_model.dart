class OrderListResponse {
  final String status;
  final String message;
  final List<Order> data;

  OrderListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    return OrderListResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((orderJson) => Order.fromJson(orderJson))
          .toList(),
    );
  }
}

class Order {
  final int id;
  final String savedOrderId;
  final UserDetail userDetail;
  final LabTestDetail labTestDetail;
  final String status;
  final String createdAt;

  Order({
    required this.id,
    required this.savedOrderId,
    required this.userDetail,
    required this.labTestDetail,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: _parseInt(json['id']),
      savedOrderId: json['order_id'] ?? '',
      userDetail: UserDetail.fromJson(json['user_detail']),
      labTestDetail: LabTestDetail.fromJson(json['lab_test_detail']),
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
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
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobile: json['mobile'] ?? '',
      token: json['token'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      height: _parseInt(json['height']),
      weight: _parseInt(json['weight']),
      bloodGroup: json['blood_group'] ?? '',
      address: json['address'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }
}

class LabTestDetail {
  final int id;
  final String name;
  final String image;
  final String price;
  final String description;

  LabTestDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
  });

  factory LabTestDetail.fromJson(Map<String, dynamic> json) {
    return LabTestDetail(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

// Helper method to parse int safely from dynamic (string or int)
int _parseInt(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is String) {
    return int.tryParse(value) ?? 0;
  } else {
    return 0;
  }
}
