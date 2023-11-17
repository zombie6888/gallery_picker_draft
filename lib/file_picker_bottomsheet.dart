import 'dart:io';

import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_draft/picture_picker.dart';
import 'package:file_picker_draft/picture_preview_screen.dart';
import 'package:flutter/material.dart';

class FilePickerBottomSheet extends StatelessWidget {
  final Function(List<File> files) onPickFiles;
  const FilePickerBottomSheet({super.key, required this.onPickFiles});

  pickGalleryFiles(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.push(MaterialPageRoute(
        builder: (BuildContext context) {
          return PicturePreviewScreen(child: PicturePicker(onSubmit: (paths) {
            final files = paths.map((p) => File(p)).toList();
            onPickFiles(files);
            Navigator.of(context).pop();
          }));
        },
        fullscreenDialog: true));
  }

  pickFiles(BuildContext context) async {
    List<File> files = [];
    Navigator.of(context).pop();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: true,
    );
    final pickedFiles = result?.files;
    if (pickedFiles == null) return;
    for (var file in pickedFiles) {
      final path = file.path;
      if (path != null) {
        files.add(File(path));
      }
    }
    if (files.isNotEmpty) {
      onPickFiles(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: DoctisInsets.all.m,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: DoctisInsets.bottom.s,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Прикрепить', style: DoctisTypography.text.title_20_bold),
                IconButton(
                  icon: DoctisIcon(DoctisIcons.cross,
                      doctisIconColor: DoctisIconColors.monochrome20),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                DoctisRow(
                  divider: true,
                  isDark: true,
                  child: DoctisRowChildBadge2(
                    onPressed: () => pickGalleryFiles(context),
                    title: 'Выбрать фото из галереи',
                    rightIcon: DoctisIcon(
                      DoctisIcons.chevron_right,
                      doctisIconColor: DoctisIconColors.monochrome20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => pickFiles(context),
                  child: DoctisRow(
                    isDark: true,
                    child: DoctisRowChildBadge2(
                      onPressed: () => pickFiles(context),
                      title: 'Выбрать файл',
                      rightIcon: DoctisIcon(
                        DoctisIcons.chevron_right,
                        doctisIconColor: DoctisIconColors.monochrome20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
