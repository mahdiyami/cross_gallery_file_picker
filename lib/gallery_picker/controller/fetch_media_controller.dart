import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

class FetchMediaController extends ChangeNotifier {
  final FilterOptionGroup _filterOptionGroup = FilterOptionGroup(
    imageOption: const FilterOption(
      sizeConstraint: SizeConstraint(ignoreSize: true),
    ),
  );
  final int _sizePerPage = 50;

  List<AssetEntity>? entities;
  int _page = 0;

  int _totalEntitiesCount = 0;
  AssetPathEntity? path;

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMoreToLoad = true;

  Future<List<AssetEntity>?> requestAssets() async {
    isLoading = true;
    notifyListeners();
    // Request permissions.
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    // Further requests can be only proceed with authorized or limited.
    if (!ps.hasAccess) {
      isLoading = false;
      notifyListeners();
      if (kDebugMode) {
        print('Permission is not accessible.');
      }
      return null;
    }
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
      onlyAll: true,
      filterOption: _filterOptionGroup,
    );

    if (paths.isEmpty) {
      isLoading = false;

      notifyListeners();
      if (kDebugMode) {
        print('No paths found.');
      }
      return null;
    }
    path = paths.first;
    notifyListeners();

    _totalEntitiesCount = await path!.assetCountAsync;
    final List<AssetEntity> entities = await path!.getAssetListPaged(
      page: 0,
      size: _sizePerPage,
    );
    this.entities = entities;
    isLoading = false;
    hasMoreToLoad = this.entities!.length < _totalEntitiesCount;

    notifyListeners();
    return entities;
  }

  Future<void> loadMoreAsset() async {
    final List<AssetEntity> entities = await path!.getAssetListPaged(
      page: _page + 1,
      size: _sizePerPage,
    );

    this.entities?.addAll(entities);
    _page++;
    hasMoreToLoad = this.entities!.length < _totalEntitiesCount;
    isLoadingMore = false;
    notifyListeners();
  }
}
