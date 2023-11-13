import 'package:flutter/material.dart';

class GalleryView extends StatefulWidget {
  final List<Image> images;
  final int page;
  final int itemsCount;
  final int size;
  const GalleryView(
      {super.key,
      required this.images,
      required this.page,
      required this.size,
      required this.itemsCount});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  List<int> _selectedIndexes = [];

  onToggleSelector(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.removeWhere((e) => e == index);
      } else {
        _selectedIndexes.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        crossAxisCount: 3,
        children: [
          for (var i = 0; i < widget.itemsCount; i++)
            Stack(
              fit: StackFit.expand,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    color: Colors.red,
                    child: widget.images.length > i
                        ? AnimatedPadding(
                            padding: _selectedIndexes.contains(i)
                                ? const EdgeInsets.all(12)
                                : EdgeInsets.zero,
                            duration: const Duration(milliseconds: 100),
                            child: Image(
                              image: widget.images[i].image,
                              fit: BoxFit.cover,
                            ),
                          )
                        : null),
                Positioned(
                    top: 0,
                    right: 0,
                    child: ThumbSelector(
                      index: i,
                      isActive: _selectedIndexes.contains(i),
                      onToggleSelector: onToggleSelector,
                    ))
              ],
            )
        ]);
  }
}

class ThumbSelector extends StatelessWidget {
  final bool isActive;
  final void Function(int index) onToggleSelector;
  final int index;
  const ThumbSelector(
      {super.key,
      required this.onToggleSelector,
      required this.index,
      this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onToggleSelector(index),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                color: isActive ? Colors.teal : null,
                border: isActive ? null : Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(22)),
            margin: const EdgeInsets.only(right: 7, top: 7),
            child:
                isActive ? Center(child: Text((index + 1).toString())) : null,
          ),
        ),
      ),
    );
  }
}
