import 'package:flutter/material.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/utils/extensions.dart';

class RowAddress extends StatelessWidget {
  const RowAddress({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final selected =
        context.model(ModelType.selectedCell).selectedCell?.row == index;
    return ColoredBox(
      color: selected ? Colors.grey : Colors.transparent,
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
