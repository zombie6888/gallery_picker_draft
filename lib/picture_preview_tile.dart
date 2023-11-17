import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:file_picker_draft/picture_preview_selector.dart';
import 'package:flutter/material.dart';

class PicturePreviewTile extends StatelessWidget {
  final String id;
  final int index;
  final bool isActive;
  final Image? previewImage;
  final bool isLoaded;
  final void Function(String id) onToggleSelector;
  final void Function(String id) onPressTile;

  const PicturePreviewTile(
      {super.key,
      required this.id,
      required this.previewImage,
      required this.onToggleSelector,
      required this.onPressTile,
      required this.isLoaded,
      required this.isActive,
      required this.index});

  @override
  Widget build(BuildContext context) {
    final image = previewImage?.image;
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            width: 100,
            height: 100,
            color: DoctisBackgroundColors.monochrome5,
            child: isLoaded && image != null
                ? AnimatedPadding(
                    padding:
                        isActive ? const EdgeInsets.all(12) : EdgeInsets.zero,
                    duration: const Duration(milliseconds: 100),
                    child: GestureDetector(
                      onTap: () => onPressTile(id),
                      child: Hero(
                        tag: id,
                        child: Image(
                          image: image,
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
            child: PicturePreviewSelector(
              index: index,
              id: id,
              isActive: isActive,
              onToggleSelector: onToggleSelector,
            ))
      ],
    );
  }
}
