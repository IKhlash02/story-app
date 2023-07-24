import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:story_app_1/data/model/story_element.dart';

import '../data/api/api_service.dart';
import '../data/model/user_model.dart';
import '../db/auth_repository.dart';
import '../result_state.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;

  ListStoryProvider({
    required this.apiService,
    required this.authRepository,
  }) {
    _fechtListstory();
  }

  int? pageItems = 1;
  int sizeItems = 5;

  void setPageItems() {
    pageItems = 1;
  }

  Future addListstory() async {
    _addListstory();
  }

  Future fechtListstory() async {
    _fechtListstory();
  }

  String _message = "";
  List<StoryElement> _liststory = [];
  late ResultState _state;

  String get message => _message;

  List<StoryElement> get result => _liststory;

  ResultState get state => _state;

  Future<dynamic> _fechtListstory() async {
    try {
      if (pageItems == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      User? user = await authRepository.getUser();

      if (user == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }

      final token = user.token;

      final story = await apiService.getAllStory(token, pageItems!, sizeItems);

      _state = ResultState.hasData;
      _liststory.addAll(story);
      if (story.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }

      notifyListeners();

      if (_liststory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }

      return _liststory;
    } catch (e) {
      String errorMessage = "An error occurred";

      // Menyesuaikan pesan error berdasarkan jenis kesalahan yang terjadi
      if (e is SocketException) {
        errorMessage = "No internet connection";
      } else if (e is TimeoutException) {
        errorMessage = "Request timed out";
      } else if (e is FormatException) {
        errorMessage = "Invalid data format";
      }

      _state = ResultState.error;
      notifyListeners();
      return _message = errorMessage;
    }
  }

  Future<dynamic> _addListstory() async {
    try {
      pageItems = 1;
      _state = ResultState.loading;
      notifyListeners();

      User? user = await authRepository.getUser();

      if (user == null) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }

      final token = user.token;

      final story = await apiService.getAllStory(token, pageItems!, sizeItems);

      _state = ResultState.hasData;
      _liststory = story;

      notifyListeners();

      if (_liststory.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
      }

      return _liststory;
    } catch (e) {
      String errorMessage = "An error occurred";

      // Menyesuaikan pesan error berdasarkan jenis kesalahan yang terjadi
      if (e is SocketException) {
        errorMessage = "No internet connection";
      } else if (e is TimeoutException) {
        errorMessage = "Request timed out";
      } else if (e is FormatException) {
        errorMessage = "Invalid data format";
      }

      _state = ResultState.error;
      notifyListeners();
      return _message = errorMessage;
    }
  }
}
