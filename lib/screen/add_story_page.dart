import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:story_app_1/common.dart';
import 'package:story_app_1/flavor_config.dart';
import 'package:story_app_1/provider/image_provider.dart';
import 'package:story_app_1/provider/upload_provider.dart';

import '../provider/add_map.dart';

class AddStoryPage extends StatefulWidget {
  final Function() addMap;
  final Function() onSend;
  const AddStoryPage({
    Key? key,
    required this.addMap,
    required this.onSend,
  }) : super(key: key);

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    context.watch<AddImageProvider>().imagePath == null
                        ? const Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image,
                              size: 100,
                            ),
                          )
                        : _showImage(),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () => _onCameraView(),
                            child:
                                Text(AppLocalizations.of(context)!.kameraItem)),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _onGalleryView();
                            },
                            child:
                                Text(AppLocalizations.of(context)!.galeriItem)),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: descriptionController,
                      minLines: 6,
                      maxLines:
                          null, // Membuat TextField bisa mengisi lebih dari satu baris teks
                      keyboardType: TextInputType
                          .multiline, // Mengaktifkan keyboard dengan fitur multiline
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            bottom: 40.0, top: 8, right: 8, left: 8),
                        isDense: true,
                        hintText: AppLocalizations.of(context)!.deskripsiItem,

                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12.47)),
                        // Tambahkan properti dekorasi lain yang Anda butuhkan
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    if (FlavorConfig.instance.values.isFree == false)
                      ElevatedButton(
                        onPressed: () {
                          widget.addMap();
                        },
                        child: Text(
                            (context.read<AddMapProvider>().alamatStory == null)
                                ? AppLocalizations.of(context)!.tambahAlamat
                                : context.read<AddMapProvider>().street),
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                    context.watch<UploadProvider>().isUploading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              _onUpload();
                            },
                            child: Text(AppLocalizations.of(context)!.addImage),
                          )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _onGalleryView() async {
    final provider = context.read<AddImageProvider>();
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;
    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<AddImageProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onUpload() async {
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final addImageProvider = context.read<AddImageProvider>();
    final uploadProvider = context.read<UploadProvider>();
    final addMapprovider = context.read<AddMapProvider>();

    final imagePath = addImageProvider.imagePath;
    final imageFile = addImageProvider.imageFile;
    if (imagePath == null || imageFile == null) {
      scaffoldMessengerState.showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.validatoraddImage)),
      );
      return;
    }

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await uploadProvider.compressImage(bytes);

    await uploadProvider.upload(
      newBytes,
      fileName,
      descriptionController.text,
    );

    if (uploadProvider.uploadResponse != null) {
      addImageProvider.setImageFile(null);
      addImageProvider.setImagePath(null);
    }

    addMapprovider.setNull();

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(uploadProvider.message)),
    );

    widget.onSend();
  }

  Widget _showImage() {
    final imagePath = context.read<AddImageProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
