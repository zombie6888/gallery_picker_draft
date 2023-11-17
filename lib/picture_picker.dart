import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'picture_preview_grid.dart';

class PicturePicker extends StatefulWidget {
  final void Function(List<String> assets) onSubmit;
  const PicturePicker({super.key, required this.onSubmit});

  @override
  State<PicturePicker> createState() => _PicturePickerState();
}

class _PicturePickerState extends State<PicturePicker> {
  List<Picture> _pictures = [];
  int _page = 1;
  int _totalCount = 0;
  final int _itemsPerPage = 30;
  final int _previewSize = 100;

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
      List<Picture> loadedPictures = [];
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
          type: RequestType.image, onlyAll: true);
      if (_totalCount == 0) {
        _totalCount = await PhotoManager.getAssetCount(type: RequestType.image);
      }
      for (var path in paths) {
        final List<AssetEntity> entities =
            await path.getAssetListPaged(page: page - 1, size: _itemsPerPage);
        for (var entity in entities) {
          final AssetEntityImage image = AssetEntityImage(
            entity,
            isOriginal: false, // Defaults to `true`.
            thumbnailSize:
                ThumbnailSize.square(_previewSize), // Preferred value.
            thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
          );
          final file = await entity.loadFile();
          final path = file?.path ?? '';
          loadedPictures.add(Picture(path: path, preview: image));
        }
      }
      setState(() {
        _pictures = [..._pictures, ...loadedPictures];
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
    final canLoadMore = _page * _itemsPerPage < _totalCount;
    return PicturePreviewGrid(
        previewSize: Size(_previewSize.toDouble(), _previewSize.toDouble()),
        onSubmit: widget.onSubmit,
        onLoadMoreImages: loadMoreImages,
        canLoadMore: canLoadMore,
        pictures: _pictures,
        itemsCount: min(_page * _itemsPerPage, _totalCount));
  }
}
