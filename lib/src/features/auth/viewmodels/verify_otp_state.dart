import 'package:equatable/equatable.dart';

enum VerifyOtpStatus { initial, loading, success, failure }

class VerifyOtpState extends Equatable {
  final VerifyOtpStatus status;
  final String? errorMessage;

  const VerifyOtpState({this.status = VerifyOtpStatus.initial, this.errorMessage});

  VerifyOtpState copyWith({VerifyOtpStatus? status, String? errorMessage}) {
    return VerifyOtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
