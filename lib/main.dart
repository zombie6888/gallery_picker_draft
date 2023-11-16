import 'dart:io';

import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'gallery_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDds();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const DoctisPortal(
        child: MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (context) {
      return Column(
        children: [
          for (var file in _selectedFiles) Text(file.path),
          TextButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    builder: (context) {
                      return FilePickerBottomSheet(onPickFiles: (files) {
                        setState(() {
                          _selectedFiles = files;
                        });
                      });
                    });
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child:
                    Text('Загрузить картинки', style: TextStyle(fontSize: 22)),
              )),
        ],
      );
    }));
  }
}

class FullScreenModal extends StatelessWidget {
  final Widget child;
  const FullScreenModal({super.key, required this.child});

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
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
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

class FilePickerBottomSheet extends StatelessWidget {
  final Function(List<File> files) onPickFiles;
  const FilePickerBottomSheet({super.key, required this.onPickFiles});

  pickGalleryFiles(BuildContext context) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return FullScreenModal(child: GalleryPicker(onSubmit: (paths) {
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
