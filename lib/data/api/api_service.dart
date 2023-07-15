import 'dart:convert';

import 'dart:typed_data';

import 'package:story_app_1/data/model/story_element.dart';

import '../model/upload_response.dart';
import '../model/user_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const _baseUrl = "https://story-api.dicoding.dev/v1";
  static const _login = "/login";
  static const _register = "/register";
  static const _story = "/stories";
  // static const _addNewsStoryGuestAccount = "/stories/guest";

  Future<User> userLogin(String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl + _login),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json["error"] == false) {
        final result = User.fromJson(json["loginResult"]);

        return result;
      } else {
        throw Exception("Login failed");
      }
    } else {
      throw Exception("Login failed");
    }
  }

  Future<bool> userRegister(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl + _register),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );
    final json = jsonDecode(response.body);

    if (response.statusCode == 201 && json["error"] == false) {
      return true;
    } else {
      throw Exception(json["message"]);
    }
  }

  Future<UploadResponse> addNewStory(
    List<int> bytes,
    String fileName,
    String description,
    String token,
  ) async {
    final headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token'
    };
    var request = http.MultipartRequest('POST', Uri.parse(_baseUrl + _story));

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );
    final Map<String, String> fields = {
      "description": description,
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        responseData,
      );
      return uploadResponse;
    } else {
      throw Exception("Add story error");
    }
  }

  Future<List<StoryElement>> getAllStory(String token) async {
    final response = await http.get(
      Uri.parse(_baseUrl + _story),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json["error"] == false) {
      final List<dynamic> jsonResult = json["listStory"];

      final result = jsonResult.map((e) => StoryElement.fromJson(e)).toList();
      return result;
    } else {
      throw Exception(json["message"]);
    }
  }

  Future<StoryElement> getDetailStory(String idStory, String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl$_story/$idStory"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    final json = jsonDecode(response.body);

    if (response.statusCode == 200 && json["error"] == false) {
      final jsonResult = json["story"];

      final result = StoryElement.fromJson(jsonResult);
      return result;
    } else {
      throw Exception(json["message"]);
    }
  }
}
