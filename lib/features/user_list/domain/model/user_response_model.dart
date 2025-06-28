import 'package:user_list/features/user_list/domain/model/user_model.dart';

class UserResponseModel {
  final List<UserModel> users;
  final int totalPages;

  UserResponseModel({required this.users, required this.totalPages});

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      users:
          (json['data'] as List)
              .map((user) => UserModel.fromJson(user))
              .toList(),
      totalPages: json['total_pages'],
    );
  }
}
