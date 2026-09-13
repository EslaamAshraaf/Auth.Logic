import 'package:equatable/equatable.dart';

class ResendOtpRequestModel extends Equatable {
  final String login;

  const ResendOtpRequestModel({required this.login});

  Map<String, dynamic> toJson() {
    return {'login': login};
  }

  @override
  List<Object?> get props => [login];
}
