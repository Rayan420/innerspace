import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innerspace/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class CoverPicture extends StatefulWidget {
  const CoverPicture({
    Key? key,
    this.selectedImageBytes,
    required this.onImageSelected,
    required this.isDarkMode,
    required this.imageUrl,
  }) : super(key: key);

  final Uint8List? selectedImageBytes;
  final Function(Uint8List?) onImageSelected;
  final bool isDarkMode;
  final String imageUrl;

  @override
  _CoverPictureState createState() => _CoverPictureState();
}

class _CoverPictureState extends State<CoverPicture> {
  Uint8List? _selectedImageBytes;

  @override
  void initState() {
    super.initState();
    _selectedImageBytes = widget.selectedImageBytes;
  }

  @override
  void didUpdateWidget(covariant CoverPicture oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedImageBytes != oldWidget.selectedImageBytes) {
      setState(() {
        _selectedImageBytes = widget.selectedImageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImagePicker(context);
      },
      child: Container(
        width: double.infinity,
        height: 200, // Adjust height as needed
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: _selectedImageBytes != null
                ? MemoryImage(_selectedImageBytes!)
                : NetworkImage(widget.imageUrl) as ImageProvider,
          ),
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                height: 40,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 3,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  color: Colors.black.withOpacity(0.5),
                ),
                child:
                    const Icon(Icons.camera_alt_outlined, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                widget.isDarkMode ? Colors.white : Colors.black,
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.pop(context);
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  final picker = ImagePicker();

  _imgFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  _imgFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: tPrimaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        )
      ],
    );
    if (croppedFile != null) {
      final Uint8List bytes = await croppedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
      widget.onImageSelected(_selectedImageBytes);
    }
  }
}
