import 'package:dartz/dartz.dart';
import 'package:user_list/features/user_list/domain/model/user_response_model.dart';

abstract class UserRepository {
  Future<Either<String, UserResponseModel>> getUsers(int page);
}
