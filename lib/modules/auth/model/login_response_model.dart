import 'user_model.dart';

class LoginResponseModel {
  final String token;
  final UserModel user;
  final bool isNewUser;

  const LoginResponseModel({required this.token, required this.user, required this.isNewUser});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      isNewUser: json['isNewUser'] as bool? ?? false,
    );
  }
}
