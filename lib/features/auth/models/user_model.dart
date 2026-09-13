import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String? userName;
  final String email;
  final String? phone;
  final String token;
  final String? profileImage;
  final String? locale;
  final String? gender;
  final String? dateOfBirth;

  const UserModel({
    required this.id,
    required this.name,
    this.userName,
    required this.email,
    this.phone,
    required this.token,
    this.profileImage,
    this.locale,
    this.gender,
    this.dateOfBirth,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['app_user'] as Map<String, dynamic>? ?? json;

    return UserModel(
      id: userJson['id'] as int? ?? 0,
      name: (userJson['full_name'] ?? userJson['name']) as String? ?? '',
      userName: userJson['user_name'] as String?,
      email: userJson['email'] as String? ?? '',
      phone: userJson['phone'] as String?,
      token: (json['token'] ?? userJson['token']) as String? ?? '',
      profileImage:
          (userJson['avatar'] ?? userJson['profile_image'] ?? userJson['image'])
              as String?,
      locale: userJson['locale'] as String?,
      gender: userJson['gender'] as String?,
      dateOfBirth: userJson['date_of_birth'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'profile_image': profileImage,
      'locale': locale,
      'gender': gender,
      'date_of_birth': dateOfBirth,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    userName,
    email,
    phone,
    token,
    profileImage,
    locale,
    gender,
    dateOfBirth,
  ];
}
