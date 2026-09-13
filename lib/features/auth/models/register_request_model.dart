import 'package:equatable/equatable.dart';

class RegisterRequestModel extends Equatable {
  final String fullName;
  final String userName;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String locale;
  final String fcmToken;
  final String deviceId;
  final String deviceType;

  const RegisterRequestModel({
    required this.fullName,
    required this.userName,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.locale,
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'user_name': userName,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'locale': locale,
      'fcm_token': fcmToken,
      'device_id': deviceId,
      'device_type': deviceType,
    };
  }

  @override
  List<Object?> get props => [
    fullName,
    userName,
    email,
    phone,
    password,
    passwordConfirmation,
    locale,
    fcmToken,
    deviceId,
    deviceType,
  ];
}
