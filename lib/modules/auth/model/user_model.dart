class UserModel {
  final String id;
  final String name;
  final String phone;
  final String countryCode;
  final String email;

  const UserModel({
    required this.id,
    required this.name,
    this.phone = '',
    this.countryCode = '+91',
    this.email = '',
  });

  /// "+91 98765 43210" or the email if the user signed in with email.
  String get contact {
    if (phone.isEmpty) return email;
    final spaced = phone.length == 10 ? '${phone.substring(0, 5)} ${phone.substring(5)}' : phone;
    return '$countryCode $spaced';
  }

  UserModel copyWith({String? name}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone,
      countryCode: countryCode,
      email: email,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String? ?? '',
      countryCode: json['countryCode'] as String? ?? '+91',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'countryCode': countryCode,
        'email': email,
      };
}
