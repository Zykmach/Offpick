import 'user_model.dart';

class LoginResponseModel {
  final UserModel user;
  final bool isNewUser;

  const LoginResponseModel({required this.user, required this.isNewUser});
}
