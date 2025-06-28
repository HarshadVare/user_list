import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_list/core/user_cache_helper.dart';
import 'package:user_list/features/user_list/data/user_repository_impl.dart';
import 'package:user_list/features/user_list/domain/model/user_model.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  int page = 1;
  int totalPages = 1;
  bool isFetching = false;
  List<UserModel> allUsers = [];

  UserListCubit() : super(UserListInitial());

  final _cacheHelper = UserCacheHelper();
  final _userRepositoryImpl = UserRepositoryImpl();

  void fetchUsers({bool isRefresh = false}) async {
    if (isFetching || page > totalPages) return;
    isFetching = true;

    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      isFetching = false;

      if (allUsers.isEmpty) {
        final cached = await _cacheHelper.getCachedUsers();
        if (cached.isNotEmpty) {
          allUsers = cached;
          emit(UserListLoaded(List.from(allUsers)));
        } else {
          emit(UserListError("No internet connection and no cached data."));
        }
      } else {
        emit(UserListError("No internet connection."));
      }
      return;
    }

    if (isRefresh) {
      page = 1;
      totalPages = 1;
      allUsers.clear();
      emit(UserListLoading(isRefresh: true));
    } else {
      emit(UserListLoading());
    }

    final result = await _userRepositoryImpl.getUsers(page);
    result.fold(
      (error) async {
        if (allUsers.isEmpty) {
          final cached = await _cacheHelper.getCachedUsers();
          if (cached.isNotEmpty) {
            allUsers = cached;
            emit(UserListLoaded(List.from(allUsers)));
          } else {
            emit(UserListError("Failed to fetch data and no cache available."));
          }
        } else {
          emit(UserListError(error));
        }
      },
      (response) {
        final users = response.users;
        totalPages = response.totalPages;

        if (users.isEmpty && page == 1) {
          emit(UserListEmpty());
        } else {
          page++;
          allUsers.addAll(users);
          _cacheHelper.cacheUsers(allUsers); // Cache it
          emit(UserListLoaded(List.from(allUsers)));
        }
      },
    );

    isFetching = false;
  }

  void loadCachedUsers() async {
    final cachedUsers = await _cacheHelper.getCachedUsers();
    if (cachedUsers.isNotEmpty) {
      allUsers = cachedUsers;
      emit(UserListLoaded(List.from(allUsers)));
    }
  }

  void search(String query) {
    final filtered =
        allUsers
            .where(
              (user) =>
                  user.name.toLowerCase().contains(query.toLowerCase().trim()),
            )
            .toList();

    emit(UserListLoaded(filtered));
  }
}
