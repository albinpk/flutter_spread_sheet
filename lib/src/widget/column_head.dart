import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/utils/functions.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class ColumnHead extends ConsumerWidget {
  const ColumnHead({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sheetProvider.notifier);
    final selected = ref.watch(
      sheetProvider.select((v) => v.isColSelected(index)),
    );
    return ColoredBox(
      color: selected ? Colors.black26 : Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            onTap: () => notifier.selectCol(index),
            child: Center(
              child: Text(
                getColumnTitle(index),
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: DragHandle(
              axis: Axis.horizontal,
              onUpdate: (value) => notifier.changeColSize(index, value),
            ),
          ),
        ],
      ),
    );
  }
}
