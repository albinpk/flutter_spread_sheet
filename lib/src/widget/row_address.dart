import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class RowAddress extends ConsumerWidget {
  const RowAddress({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sheetProvider.notifier);
    final selected = ref.watch(
      sheetProvider.select((v) => v.selectedCell?.row == index),
    );
    return ColoredBox(
      color: selected ? Colors.black26 : Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Text(
              index.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DragHandle(
              axis: Axis.vertical,
              onUpdate: (value) => notifier.changeRowSize(index, value),
            ),
          ),
        ],
      ),
    );
  }
}
