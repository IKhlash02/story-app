// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import 'package:story_app_1/data/api/api_service.dart';
import 'package:story_app_1/provider/list_story_provider.dart';

import '../data/model/upload_response.dart';
import '../data/model/user_model.dart';
import '../db/auth_repository.dart';

class UploadProvider extends ChangeNotifier {
  final ApiService apiService;
  final AuthRepository authRepository;
  final ListStoryProvider listStoryProvider;
  UploadProvider({
    required this.apiService,
    required this.authRepository,
    required this.listStoryProvider,
  });

  bool isUploading = false;
  String message = "";
  UploadResponse? uploadResponse;

  Future<void> upload(
    List<int> bytes,
    String fileName,
    String description,
  ) async {
    try {
      message = "";
      uploadResponse = null;
      isUploading = true;
      notifyListeners();

      User? user = await authRepository.getUser();
      uploadResponse = await apiService.addNewStory(
          bytes, fileName, description, user!.token);

      message = uploadResponse?.message ?? "success";
      await listStoryProvider.fechtListstory();
      isUploading = false;
      notifyListeners();
    } catch (e) {
      isUploading = false;
      message = e.toString();
      notifyListeners();
    }
  }

  Future<List<int>> compressImage(List<int> bytes) async {
    int imageLength = bytes.length;
    if (imageLength < 1000000) return bytes;
    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];
    do {
      ///
      compressQuality -= 10;
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );
      length = newByte.length;
    } while (length > 1000000);
    return newByte;
  }
}
