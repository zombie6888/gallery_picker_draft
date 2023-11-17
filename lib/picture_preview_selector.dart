import 'package:doctis_design_system/doctis_design_system.dart';
import 'package:flutter/material.dart';

class PicturePreviewSelector extends StatelessWidget {
  final bool isActive;
  final void Function(String path) onToggleSelector;
  final int index;
  final String id;
  const PicturePreviewSelector(
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
                  decoration: BoxDecoration(
                      color: isActive ? DoctisRootColors.main : null,
                      border:
                          !isActive ? Border.all(color: Colors.white) : null,
                      borderRadius: BorderRadius.circular(22)),
                  margin: const EdgeInsets.only(right: 8, top: 8),
                  child: isActive
                      ? Center(
                          child: Text('${index + 1}',
                              style: DoctisTypography.text.button_s.copyWith(
                                  color:
                                      DoctisSimpleColors.main.foregroundColor)),
                        )
                      : null)),
        ));
  }
}

class PicturePreviewBudge extends StatelessWidget {
  final bool isActive;
  final void Function(String path) onToggleSelector;
  final int index;
  final String id;
  const PicturePreviewBudge(
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
