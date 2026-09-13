import 'package:equatable/equatable.dart';

class AppleLoginRequestModel extends Equatable {
  final String idToken;
  final String locale;
  final String? phone;
  final String fcmToken;
  final String deviceId;
  final String deviceType;

  const AppleLoginRequestModel({
    required this.idToken,
    required this.locale,
    this.phone,
    required this.fcmToken,
    required this.deviceId,
    required this.deviceType,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id_token': idToken,
      'locale': locale,
      'fcm_token': fcmToken,
      'device_id': deviceId,
      'device_type': deviceType,
    };
    if (phone != null) {
      map['phone'] = phone;
    }
    return map;
  }

  @override
  List<Object?> get props => [
    idToken,
    locale,
    phone,
    fcmToken,
    deviceId,
    deviceType,
  ];
}
