import 'dart:io';

import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:flutter/material.dart';

class ImageAsset {
  final String path;
  final Image preview;
  ImageAsset({required this.preview, required this.path});
}

class GalleryView extends StatefulWidget {
  final List<ImageAsset> assets;
  final int itemsCount;
  final VoidCallback onLoadMoreImages;
  final bool canLoadMore;
  final void Function(List<String> assets) onSubmit;
  const GalleryView(
      {super.key,
      required this.assets,
      required this.onLoadMoreImages,
      required this.onSubmit,
      this.canLoadMore = true,
      required this.itemsCount});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
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
              final previewImage = asset?.preview.image;
              return Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                      width: 100,
                      height: 100,
                      color: DoctisBackgroundColors.monochrome5,
                      child: isLoaded && previewImage != null
                          ? AnimatedPadding(
                              padding: _selectedIds.contains(id)
                                  ? const EdgeInsets.all(12)
                                  : EdgeInsets.zero,
                              duration: const Duration(milliseconds: 100),
                              child: GestureDetector(
                                onTap: () => showViewer(id),
                                child: Hero(
                                  tag: id,
                                  child: Image(
                                    image: previewImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: DoctisIcon(
                                DoctisIcons.image_placeholder,
                                doctisIconSize: DoctisIconSize.l,
                                doctisIconColor: DoctisIconColors.monochrome27,
                              ),
                            )),
                  Align(
                      alignment: Alignment.topRight,
                      child: ThumbSelector(
                        index: _selectedIds.indexOf(id),
                        id: id,
                        isActive: _selectedIds.contains(id),
                        onToggleSelector: onToggleSelector,
                      ))
                ],
              );
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

class ThumbSelector extends StatelessWidget {
  final bool isActive;
  final void Function(String path) onToggleSelector;
  final int index;
  final String id;
  const ThumbSelector(
      {super.key,
      required this.onToggleSelector,
      required this.index,
      required this.id,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onToggleSelector(id),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 24,
                height: 24,
                decoration: !isActive
                    ? BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(22))
                    : null,
                margin: const EdgeInsets.only(right: 8, top: 8),
                child: isActive
                    ? DoctisBadge(
                        badgeContent: '${index + 1}',
                        size: DoctisBadgeSize.m,
                        color: DoctisSimpleColors.main)
                    : null),
          ),
        ));
  }
}
