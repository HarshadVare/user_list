import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_list/features/user_list/domain/model/user_model.dart';

class UserCacheHelper {
  static const _key = 'CACHED_USERS';

  Future<void> cacheUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = users.map((u) => u.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  Future<List<UserModel>> getCachedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString != null) {
      final decoded = jsonDecode(jsonString) as List;
      return decoded.map((json) => UserModel.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
