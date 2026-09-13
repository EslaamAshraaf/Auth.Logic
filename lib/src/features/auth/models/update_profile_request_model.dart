import 'package:dio/dio.dart';

class UpdateProfileRequestModel {
  final String? fullName;
  final String? userName;
  final String? email;
  final String? phone;
  final String? locale;
  final String? gender;
  final String? dateOfBirth;
  final String? profileImagePath;

  UpdateProfileRequestModel({
    this.fullName,
    this.userName,
    this.email,
    this.phone,
    this.locale,
    this.gender,
    this.dateOfBirth,
    this.profileImagePath,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['full_name'] = fullName;
    if (userName != null) data['user_name'] = userName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (locale != null) data['locale'] = locale;
    if (gender != null) data['gender'] = gender;
    if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;

    if (profileImagePath != null) {
      data['profile_image'] = await MultipartFile.fromFile(profileImagePath!);
    }

    return FormData.fromMap(data);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (userName != null) data['user_name'] = userName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (locale != null) data['locale'] = locale;
    if (gender != null) data['gender'] = gender;
    if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
    return data;
  }
}
