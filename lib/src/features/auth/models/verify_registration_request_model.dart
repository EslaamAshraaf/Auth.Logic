import 'package:equatable/equatable.dart';

class VerifyRegistrationRequestModel extends Equatable {
  final String login;
  final String otp;
  final String deviceId;
  final String deviceType;

  const VerifyRegistrationRequestModel({
    required this.login,
    required this.otp,
    required this.deviceId,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'otp': otp,
      'device_id': deviceId,
      'device_type': deviceType,
    };
  }

  @override
  List<Object?> get props => [login, otp, deviceId, deviceType];
}
