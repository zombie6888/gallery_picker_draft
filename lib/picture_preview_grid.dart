import 'dart:io';

import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:file_picker_draft/picture_preview_tile.dart';
import 'package:flutter/material.dart';

class Picture {
  final String path;
  final Image preview;
  Picture({required this.preview, required this.path});
}

class PicturePreviewGrid extends StatefulWidget {
  final List<Picture> assets;
  final int itemsCount;
  final VoidCallback onLoadMoreImages;
  final bool canLoadMore;
  final void Function(List<String> assets) onSubmit;
  const PicturePreviewGrid(
      {super.key,
      required this.assets,
      required this.onLoadMoreImages,
      required this.onSubmit,
      this.canLoadMore = true,
      required this.itemsCount});

  @override
  State<PicturePreviewGrid> createState() => _PicturePreviewGridState();
}

class _PicturePreviewGridState extends State<PicturePreviewGrid> {
  final List<String> _selectedIds = [];

  onToggleSelector(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.removeWhere((e) => e == id);
      } else {
        if (_selectedIds.length < 10) {
          _selectedIds.add(id);
        }
      }
    });
  }

  showViewer(String path) {
    // https://github.com/bluefireteam/photo_view/issues/128
    FileImage(File(path))
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((_, __) {
      showPictureViewer(context: context, imagePaths: [path]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // final itemCount =
    //     widget.canLoadMore ? widget.page * widget.size : widget.assets.length;
    return Stack(
      children: [
        GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: 3,
            ),
            itemCount: widget.itemsCount,
            itemBuilder: (context, i) {
              final lastItemVisible = i == widget.itemsCount - 1;
              if (lastItemVisible && widget.canLoadMore) {
                widget.onLoadMoreImages();
              }
              final isLoaded = widget.assets.length > i;
              final asset = isLoaded ? widget.assets[i] : null;
              final id = asset?.path ?? '';
              return PicturePreviewTile(
                  id: id,
                  previewImage: asset?.preview,
                  onToggleSelector: onToggleSelector,
                  onPressTile: showViewer,
                  isLoaded: isLoaded,
                  isActive: _selectedIds.contains(id),
                  index: _selectedIds.indexOf(id));
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DoctisButton.primary(
              label: 'Готово (${_selectedIds.length})',
              size: DoctisButtonSize.l,
              isExpanded: true,
              onPressed: () => widget.onSubmit(_selectedIds),
            ),
          ),
        ),
      ],
    );
  }
}
