import 'package:cross_gallery_file_picker/gallery_picker/controller/fetch_media_controller.dart';
import 'package:cross_gallery_file_picker/gallery_picker/controller/gallery_picker_controller.dart';
import 'package:cross_gallery_file_picker/gallery_picker/widget/image_item_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  /// Customize your own filter options.
  late FetchMediaController _fetchMediaController;
  late GalleryPickerController _galleryPickerController;

  @override
  void initState() {
    _fetchMediaController = FetchMediaController();
    _galleryPickerController = GalleryPickerController(option: GalleryPickerOption());
    super.initState();
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<AssetEntity>?>(
      future: _fetchMediaController.requestAssets(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<AssetEntity> entities = snapshot.data!;
          return ListenableBuilder(
            listenable: _fetchMediaController,
            builder: (context, child) {
              return GridView.custom(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == _fetchMediaController.entities!.length - 8 &&
                        !_fetchMediaController.isLoadingMore &&
                        _fetchMediaController.hasMoreToLoad) {
                      _fetchMediaController.loadMoreAsset();
                    }
                    final AssetEntity entity = entities[index];
                    return ImageItemWidget(
                      key: ValueKey<int>(index),
                      entity: entity,
                      option: _galleryPickerController.option.thumbnailOption,
                    );
                  },
                  childCount: entities.length,
                  findChildIndexCallback: (Key key) {
                    // Re-use elements.
                    if (key is ValueKey<int>) {
                      return key.value;
                    }
                    return null;
                  },
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }
}
