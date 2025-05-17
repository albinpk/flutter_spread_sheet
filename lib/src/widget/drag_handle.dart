import 'package:flutter/material.dart';

class DragHandle extends StatefulWidget {
  const DragHandle({required this.axis, required this.onUpdate, super.key});

  final Axis axis;
  final ValueChanged<double> onUpdate;

  @override
  State<DragHandle> createState() => _DragHandleState();
}

class _DragHandleState extends State<DragHandle> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isVertical = widget.axis == Axis.vertical;
    return MouseRegion(
      cursor:
          isVertical
              ? SystemMouseCursors.resizeRow
              : SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onHorizontalDragUpdate: isVertical ? null : _onDrag,
        onVerticalDragUpdate: isVertical ? _onDrag : null,
        child:
            isVertical
                ? Divider(
                  height: 5,
                  thickness: 5,
                  color: _hovering ? Colors.black45 : Colors.transparent,
                )
                : VerticalDivider(
                  width: 5,
                  thickness: 5,
                  color: _hovering ? Colors.black45 : Colors.transparent,
                ),
      ),
    );
  }

  void _onDrag(DragUpdateDetails details) {
    if (details.primaryDelta case final x?) widget.onUpdate(x);
  }
}
