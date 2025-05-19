import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class ColumnAddress extends ConsumerWidget {
  const ColumnAddress({required this.index, super.key});

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
                _getTitle(index),
                style: const TextStyle(fontWeight: FontWeight.w500),
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

  String _getTitle(int index) {
    const max = 26;
    final quotient = index ~/ max;
    final remainder = index % max;
    return quotient > 0
        ? _getTitle(quotient - 1) + String.fromCharCode(remainder + 65)
        : String.fromCharCode(remainder + 65);
  }
}
