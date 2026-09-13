import 'package:equatable/equatable.dart';

class VerifyOtpRequestModel extends Equatable {
  final String login;
  final String otp;

  const VerifyOtpRequestModel({required this.login, required this.otp});

  Map<String, dynamic> toJson() {
    return {'login': login, 'otp': otp};
  }

  @override
  List<Object?> get props => [login, otp];
}
