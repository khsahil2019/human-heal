class UserModel {
  int? id;
  String? name;
  String? email;
  String? mobile;
  String? token;
  String? profilePicture;
  String? gender;
  String? dob;
  int? height;
  int? weight;
  String? bloodGroup;
  String? address;
  String? state;
  String? city;
  String? pincode;
  String? usercode; // ✅ Added usercode field

  UserModel({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.token,
    this.profilePicture,
    this.gender,
    this.dob,
    this.height,
    this.weight,
    this.bloodGroup,
    this.address,
    this.state,
    this.city,
    this.pincode,
    this.usercode, // ✅ Add in constructor
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      token: json['token']?.toString(),
      profilePicture: json['profile_picture']?.toString(),
      gender: json['gender']?.toString(),
      dob: json['dob']?.toString(),
      height: json['height'] is int
          ? json['height']
          : int.tryParse(json['height']?.toString() ?? ''),
      weight: json['weight'] is int
          ? json['weight']
          : int.tryParse(json['weight']?.toString() ?? ''),
      bloodGroup: json['blood_group']?.toString(),
      address: json['address']?.toString(),
      state: json['state']?.toString(),
      city: json['city']?.toString(),
      pincode: json['pincode']?.toString(),
      usercode: json['usercode']?.toString(), // ✅ Added parsing
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'token': token,
      'profile_picture': profilePicture,
      'gender': gender,
      'dob': dob,
      'height': height,
      'weight': weight,
      'blood_group': bloodGroup,
      'address': address,
      'state': state,
      'city': city,
      'pincode': pincode,
      'usercode': usercode, // ✅ Added to serialization
    };
  }

  /// ✅ Added copyWith() for safe partial updates
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? mobile,
    String? token,
    String? profilePicture,
    String? gender,
    String? dob,
    int? height,
    int? weight,
    String? bloodGroup,
    String? address,
    String? state,
    String? city,
    String? pincode,
    String? usercode, // ✅ Add to copyWith
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      token: token ?? this.token,
      profilePicture: profilePicture ?? this.profilePicture,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      state: state ?? this.state,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      usercode: usercode ?? this.usercode, // ✅ Preserve if not updated
    );
  }
}
