class ResetPasswordRequestModel {
  final String login;
  final String otp;
  final String password;
  final String passwordConfirmation;

  ResetPasswordRequestModel({
    required this.login,
    required this.otp,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'otp': otp,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
  }
}
