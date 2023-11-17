import 'dart:io';

import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:file_picker_draft/file_picker_bottomsheet.dart';
import 'package:flutter/material.dart';

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

  pickFiles(List<File> files) {
    setState(() {
      _selectedFiles = files;
    });
  }

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
                    builder: (context) =>
                        FilePickerBottomSheet(onPickFiles: pickFiles));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                child: Text('Загрузить файлы', style: TextStyle(fontSize: 22)),
              )),
        ],
      );
    }));
  }
}
