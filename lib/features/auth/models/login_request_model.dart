import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  final String login;
  final String password;
  final String locale;
  final String fcmToken;
  final String deviceId;
  final String deviceType;

  const LoginRequestModel({
    required this.login,
    required this.password,
    required this.locale,
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'password': password,
      'locale': locale,
      'fcm_token': fcmToken,
      'device_id': deviceId,
      'device_type': deviceType,
    };
  }

  @override
  List<Object?> get props => [
    login,
    password,
    locale,
    fcmToken,
    deviceId,
    deviceType,
  ];
}
