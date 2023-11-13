import 'package:file_picker/gallery_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Album> _albums = [];
  List<Medium> _mediums = [];
  List<AssetEntityImage> _assets = [];

  @override
  initState() {
    super.initState();
    loadAlbums();
  }

  loadAlbums() async {
    final PermissionState ps = await PhotoManager
        .requestPermissionExtend(); // the method can use optional param `permission`.
    if (ps.isAuth) {
      print('is auth');
      List<AssetEntityImage> assets = [];
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
          type: RequestType.image, onlyAll: true);
      final int count = await PhotoManager.getAssetCount();
      print(count);
      for (var path in paths) {
        final List<AssetEntity> entities =
            await path.getAssetListPaged(page: 0, size: 80);
        for (var entity in entities) {
          final AssetEntityImage image = AssetEntityImage(
            entity,
            isOriginal: false, // Defaults to `true`.
            thumbnailSize: const ThumbnailSize.square(100), // Preferred value.
            thumbnailFormat: ThumbnailFormat.jpeg, // Defaults to `jpeg`.
          );

          assets.add(image);
        }
      }
      setState(() {
        _assets = assets;
      });
    } else if (ps.hasAccess) {
      print('access granted');
      // List<String> assets = [];
      // final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
      // for (var path in paths) {
      //   final List<AssetEntity> entities =
      //       await path.getAssetListPaged(page: 0, size: 80);
      //   for (var entity in entities) {
      //     final asset = await entity.getMediaUrl() ?? '';
      //     assets.add(asset);
      //   }
      // }
      // setState(() {
      //   _assets = assets;
      // });
    } else {
      print('eror permisions');
      // Limited(iOS) or Rejected, use `==` for more precise judgements.
      // You can call `PhotoManager.openSetting()` to open settings for further steps.
    }

    // final albums = await PhotoGallery.listAlbums();
    // List<Medium> mediums = [];
    // for (var album in albums) {
    //   MediaPage page = await album.listMedia();
    //   mediums.addAll(page.items);
    // }
    // setState(() {
    //   _albums = albums;
    //   _mediums = mediums;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: GalleryView(images: _assets)
        // _assets.isEmpty
        //     ? const Center(child: CircularProgressIndicator())
        //     : ListView(
        //         children: [..._assets.map((a) => a)],
        //       ), // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
