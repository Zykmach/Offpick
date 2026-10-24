enum LoginMethod { google }

/// What we send to the server to log in.
class LoginRequestModel {
  final LoginMethod method;

  const LoginRequestModel({required this.method});

  Map<String, dynamic> toJson() => {'method': method.name};
}
