import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerController extends ChangeNotifier {
  final GalleryPickerOption option;
  GalleryPickerController({required this.option});
  XFile? _pickedFile;

  XFile? get pickedFile => _pickedFile;
}

class GalleryPickerOption {
  final int? maxPickMedia;
  final RequestType? type;
  final ThumbnailOption thumbnailOption;

  GalleryPickerOption(
      {this.maxPickMedia,
      this.type,
      this.thumbnailOption = const ThumbnailOption(size: ThumbnailSize.square(200))});
}
