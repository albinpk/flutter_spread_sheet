import 'package:flutter/material.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/utils/extensions.dart';

class SheetCell extends StatefulWidget {
  const SheetCell({required this.id, super.key});

  final CellId id;

  @override
  State<SheetCell> createState() => _SheetCellState();
}

class _SheetCellState extends State<SheetCell> {
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final selectedCell = context.model(ModelType.selectedCell).selectedCell;
    if (selectedCell == widget.id && !_focusNode.hasPrimaryFocus) {
      _focusNode.requestFocus();
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasPrimaryFocus) {
      context.state.focusCell(widget.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: TextField(
        focusNode: _focusNode,
        onSubmitted: (_) => context.state.focusDown(),
        textAlignVertical: TextAlignVertical.top,
        cursorHeight: 16,
        expands: true,
        maxLines: null,
        decoration: const InputDecoration(
          // isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        ),
      ),
    );
  }
}
