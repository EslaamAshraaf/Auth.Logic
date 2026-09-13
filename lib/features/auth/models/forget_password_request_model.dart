import 'package:equatable/equatable.dart';

class ForgetPasswordRequestModel extends Equatable {
  final String login;

  const ForgetPasswordRequestModel({required this.login});

  Map<String, dynamic> toJson() {
    return {'login': login};
  }

  @override
  List<Object?> get props => [login];
}
