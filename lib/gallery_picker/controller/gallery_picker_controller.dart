import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPickerController extends ChangeNotifier {
  final GalleryPickerOption option;
  GalleryPickerController({required this.option});

  late List<AssetEntity> picked = [];

  final pickedNotifier = ValueNotifier<List<AssetEntity>>([]);

  final onPickMax = ChangeNotifier();

  ValueNotifier<int> get maxSelection => ValueNotifier<int>(option.maxPickMedia ?? 5);

  int get max => maxSelection.value;


  bool get singleMode => maxSelection.value == 1;

  void pickEntity(AssetEntity entity) {
    if (singleMode) {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        picked.clear();
        picked.add(entity);
      }
    } else {
      if (picked.contains(entity)) {
        picked.remove(entity);
      } else {
        if (picked.length == maxSelection.value) {
          onPickMax.notifyListeners();
          return;
        }
        picked.add(entity);
      }
    }
    pickedNotifier.value = picked;
    pickedNotifier.notifyListeners();
    notifyListeners();
  }

  int pickIndex(AssetEntity entity) {
    return picked.indexOf(entity) +1;
  }

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
