import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class RowHead extends ConsumerWidget {
  const RowHead({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sheetProvider.notifier);
    final selected = ref.watch(
      sheetProvider.select((v) => v.isRowSelected(index)),
    );
    return ColoredBox(
      color: selected ? Colors.black26 : Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            onTap: () => notifier.selectRow(index),
            child: Center(
              child: Text(
                index.toString(),
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
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
