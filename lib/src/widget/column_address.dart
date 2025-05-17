import 'package:flutter/material.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/utils/extensions.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class ColumnAddress extends StatelessWidget {
  const ColumnAddress({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final selected =
        context.model(ModelType.selectedCell).selectedCell?.col == index;
    return ColoredBox(
      color: selected ? Colors.black26 : Colors.transparent,
      child: Stack(
        children: [
          Center(
            child: Text(
              _getTitle(index),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: DragHandle(
              axis: Axis.horizontal,
              onUpdate: (value) {
                context.state.changeColSize(index, value);
              },
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
