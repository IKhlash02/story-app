import 'package:flutter/material.dart';
import 'package:story_app_1/data/api/api_service.dart';
import 'package:story_app_1/db/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiService apiService;

  bool isLoggedIn = false;

  AuthProvider(this.authRepository, this.apiService) {
    setIsLoggedIn();
  }

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;

  void setIsLoggedIn() async {
    isLoggedIn = await authRepository.isLoggedIn();
  }

  String message = "";

  Future<bool> login(String email, String password) async {
    try {
      isLoadingLogin = true;
      notifyListeners();

      final userState = await apiService.userLogin(email, password);

      await authRepository.login();
      await authRepository.saveToken(userState);

      isLoggedIn = await authRepository.isLoggedIn();

      isLoadingLogin = false;
      notifyListeners();

      return isLoggedIn;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteUser();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      isLoadingRegister = true;
      notifyListeners();

      final userState = await apiService.userRegister(name, email, password);

      isLoadingRegister = false;
      notifyListeners();
      return userState;
    } catch (e) {
      isLoadingRegister = false;
      return false;
    }
  }
}
