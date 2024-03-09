import 'package:cross_gallery_file_picker/gallery_picker/controller/gallery_picker_controller.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ImageItemWidget extends StatelessWidget {
  const ImageItemWidget({
    super.key,
    required this.entity,
    required this.controller,
    this.onTap,
  });

  final AssetEntity entity;
  final GalleryPickerController controller;
  final GestureTapCallback? onTap;

  Widget buildContent(BuildContext context) {
    if (entity.type == AssetType.audio) {
      return const Center(
        child: Icon(Icons.audiotrack, size: 30),
      );
    }
    return _buildImageWidget(context, entity, controller.option.thumbnailOption);
  }

  Widget _buildImageWidget(
      BuildContext context,
      AssetEntity entity,
      ThumbnailOption option,
      ) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: AssetEntityImage(
            entity,
            isOriginal: false,
            thumbnailSize: option.size,
            thumbnailFormat: option.format,
            fit: BoxFit.cover,
          ),
        ),
        PositionedDirectional(
          bottom: 4,
          start: 0,
          end: 0,
          child: Row(
            children: [
              if (entity.isFavorite)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 16,
                  ),
                ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (entity.isLivePhoto)
                      Container(
                        margin: const EdgeInsetsDirectional.only(end: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(4),
                          ),
                          color: Theme.of(context).cardColor,
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    Icon(
                          () {
                        switch (entity.type) {
                          case AssetType.other:
                            return Icons.abc;
                          case AssetType.image:
                            return Icons.image;
                          case AssetType.video:
                            return Icons.video_file;
                          case AssetType.audio:
                            return Icons.audiotrack;
                        }
                      }(),
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
         PositionedDirectional(
          top: 0,
          end: 0,
          child:  _pickEntityHandler(isPicked: controller.pickIndex(entity) > 0 , index: controller.pickIndex(entity)),
        ),
      ],
    );
  }
  Widget _pickEntityHandler({required bool isPicked , int index =1}){
    if(!isPicked) {
      return IconButton(
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white , width: 2)
        ),
      ), onPressed: ()=>controller.pickEntity(entity),
    );
    }else {
      return IconButton(
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
        icon: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue
          ),
          child: Center(child: Text(index.toString() , style: const TextStyle(color: Colors.white),)),
        ), onPressed: ()=>controller.pickEntity(entity),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) =>  GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: buildContent(context),
    ),
    );
  }
}