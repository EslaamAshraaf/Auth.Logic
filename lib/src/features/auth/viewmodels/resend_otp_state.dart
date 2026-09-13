import 'package:equatable/equatable.dart';

enum ResendOtpStatus { initial, loading, success, failure }

class ResendOtpState extends Equatable {
  final ResendOtpStatus status;
  final String? errorMessage;

  const ResendOtpState({this.status = ResendOtpStatus.initial, this.errorMessage});

  ResendOtpState copyWith({ResendOtpStatus? status, String? errorMessage}) {
    return ResendOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
