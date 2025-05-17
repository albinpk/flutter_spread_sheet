import 'package:flutter/material.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/utils/extensions.dart';

class ColumnAddress extends StatelessWidget {
  const ColumnAddress({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context) {
    final selected =
        context.model(ModelType.selectedCell).selectedCell?.col == index;
    return ColoredBox(
      color: selected ? Colors.grey : Colors.transparent,
      child: Center(
        child: Text(
          _getTitle(index),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
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
