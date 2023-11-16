import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'gallery_view.dart';

class GalleryPicker extends StatefulWidget {
  final void Function(List<String> assets) onSubmit;
  const GalleryPicker({super.key, required this.onSubmit});

  @override
  State<GalleryPicker> createState() => _GalleryPickerState();
}

class _GalleryPickerState extends State<GalleryPicker> {
  List<ImageAsset> _assets = [];
  int _page = 1;
  int _totalCount = 0;
  final _size = 30;

  @override
  initState() {
    super.initState();
    loadAssets(_page);
  }

  loadAssets(int page) {
    checkPermissions(() async {
      setState(() {
        _page = page;
      });
      List<ImageAsset> newAssets = [];
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
          type: RequestType.image, onlyAll: true);
      if (_totalCount == 0) {
        _totalCount = await PhotoManager.getAssetCount(type: RequestType.image);
      }
      for (var path in paths) {
        final List<AssetEntity> entities =
            await path.getAssetListPaged(page: page - 1, size: _size);
        for (var entity in entities) {
          final AssetEntityImage image = AssetEntityImage(
            entity,
            isOriginal: false, // Defaults to `true`.
            thumbnailSize: const ThumbnailSize.square(100), // Preferred value.
            thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
          );
          final file = await entity.loadFile();
          final path = file?.path ?? '';        
          newAssets.add(ImageAsset(path: path, preview: image));
        }
      }
      setState(() {
        _assets = [..._assets, ...newAssets];
      });
    });
  }

  Future<void> checkPermissions(AsyncCallback successCallback) async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      // полный доступ
      successCallback();
    } else if (ps.hasAccess) {
      // ограниченный доступ
      successCallback();
    } else {
      print('PhotoManager: Permisions not granted!');
    }
  }

  loadMoreImages() {
    loadAssets(_page + 1);
  }

  @override
  Widget build(BuildContext context) {
    final canLoadMore = _page * _size < _totalCount;
    return GalleryView(
        onSubmit: widget.onSubmit,
        onLoadMoreImages: loadMoreImages,
        canLoadMore: canLoadMore,
        assets: _assets,
        itemsCount: min(_page * _size, _totalCount));
  }
}
