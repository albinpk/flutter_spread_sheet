import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DragHandle extends HookWidget {
  const DragHandle({required this.axis, required this.onUpdate, super.key});

  final Axis axis;
  final ValueChanged<double> onUpdate;

  @override
  Widget build(BuildContext context) {
    final hovering = useState(false);
    final isVertical = axis == Axis.vertical;
    return MouseRegion(
      cursor:
          isVertical
              ? SystemMouseCursors.resizeRow
              : SystemMouseCursors.resizeColumn,
      onEnter: (_) => hovering.value = true,
      onExit: (_) => hovering.value = false,
      child: GestureDetector(
        onHorizontalDragUpdate: isVertical ? null : _onDrag,
        onVerticalDragUpdate: isVertical ? _onDrag : null,
        child:
            isVertical
                ? Divider(
                  height: 5,
                  thickness: 5,
                  color: hovering.value ? Colors.black45 : Colors.transparent,
                )
                : VerticalDivider(
                  width: 5,
                  thickness: 5,
                  color: hovering.value ? Colors.black45 : Colors.transparent,
                ),
      ),
    );
  }

  void _onDrag(DragUpdateDetails details) {
    if (details.primaryDelta case final x?) onUpdate(x);
  }
}
