import 'package:flutter/material.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/utils/extensions.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class RowAddress extends StatelessWidget {
  const RowAddress({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final selected =
        context.model(ModelType.selectedCell).selectedCell?.row == index;
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
              onUpdate: (value) {
                context.state.changeRowSize(index, value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
