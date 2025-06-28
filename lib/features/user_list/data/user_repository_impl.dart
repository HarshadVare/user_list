import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:user_list/features/user_list/domain/model/user_response_model.dart';
import 'package:user_list/features/user_list/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<Either<String, UserResponseModel>> getUsers(int page) async {
    try {
      final response = await http.get(
        Uri.parse('https://reqres.in/api/users?per_page=10&page=$page'),
        headers: {'x-api-key': 'reqres-free-v1'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return right(UserResponseModel.fromJson(data));
      } else {
        throw left('Failed to load users');
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
