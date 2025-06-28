part of 'user_list_cubit.dart';

abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {
  final bool isRefresh;
  UserListLoading({this.isRefresh = false});
}

class UserListLoaded extends UserListState {
  final List<UserModel> users;
  UserListLoaded(this.users);
}

class UserListEmpty extends UserListState {}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
}
