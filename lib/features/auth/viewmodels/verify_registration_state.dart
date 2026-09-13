import 'package:equatable/equatable.dart';
import '../models/user_model.dart';

enum VerifyRegistrationStatus { initial, loading, success, failure }

class VerifyRegistrationState extends Equatable {
  final VerifyRegistrationStatus status;
  final UserModel? user;
  final String? errorMessage;

  const VerifyRegistrationState({
    this.status = VerifyRegistrationStatus.initial,
    this.user,
    this.errorMessage,
  });

  VerifyRegistrationState copyWith({
    VerifyRegistrationStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return VerifyRegistrationState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
