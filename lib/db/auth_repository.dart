import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_1/data/api/api_service.dart';

import '../data/model/user_model.dart';

class AuthRepository {
  final String stateKey = "state";
  final ApiService apiService = ApiService();

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  final String userKey = "user";

  Future<bool> saveToken(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, jsonEncode(user.toJson()));
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey) ?? "";
    User? user;
    try {
      final response = jsonDecode(json);
      user = User.fromJson(response);
    } catch (e) {
      user = null;
    }
    return user;
  }
}
