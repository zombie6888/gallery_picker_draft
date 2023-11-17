import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:flutter/material.dart';

class PicturePreviewScreen extends StatelessWidget {
  final Widget child;
  const PicturePreviewScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text("Прикрепить фото",
              style: DoctisTypography.text.title_20_bold.copyWith(
                color: DoctisTextColors.monochrome,
              )),
          backgroundColor: DoctisBackgroundColors.monochrome0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: DoctisIcon(
              DoctisIcons.chevron_left,
              doctisIconSize: DoctisIconSize.m,
              doctisIconColor: DoctisIconColors.monochrome,
            ),
          ),
        ),
        body: Padding(padding: DoctisInsets.horizontal.m, child: child));
  }
}
