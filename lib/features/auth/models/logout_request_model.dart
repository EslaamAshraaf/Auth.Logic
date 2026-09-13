import 'package:equatable/equatable.dart';

class LogoutRequestModel extends Equatable {
  final String fcmToken;
  final String deviceId;

  const LogoutRequestModel({required this.fcmToken, required this.deviceId});

  Map<String, dynamic> toJson() {
    return {'fcm_token': fcmToken, 'device_id': deviceId};
  }

  @override
  List<Object?> get props => [fcmToken, deviceId];
}
