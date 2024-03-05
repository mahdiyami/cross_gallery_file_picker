import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerController extends ChangeNotifier {
  final GalleryPickerOption? option;
  GalleryPickerController({this.option});
  XFile? _pickedFile;

  XFile? get pickedFile => _pickedFile;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      _pickedFile = result.files.single;
      notifyListeners();
    }
  }
}

class GalleryPickerOption {
  final int? maxPickMedia;
  final RequestType? type;
  final ThumbnailOption? thumbnailOption;

  GalleryPickerOption({this.maxPickMedia, this.type, this.thumbnailOption});
}