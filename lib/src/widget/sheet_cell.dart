import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/enums.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/providers/sheet_state.dart';
import 'package:spread_sheet/src/utils/extensions.dart';

class SheetCell extends HookConsumerWidget {
  const SheetCell({required this.id, super.key});

  final CellId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sheetProvider.notifier);
    final (
      selected,
      data,
      focused,
      isDragging,
    ) = ref.watch(
      sheetProvider.select((v) {
        return (
          v.isCellSelected(id),
          v.getCellData(id),
          v.isCellFocused(id),
          v.isDragging,
        );
      }),
    );

    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          color: data.cellStyle.bgColor,
          border: selected
              ? Border.all(width: focused ? 2 : 1, color: context.cs.primary)
              : const Border.fromBorderSide(BorderSide.none),
        ),
        child: GestureDetector(
          // TODO(albin): https://github.com/flutter/flutter/issues/169411
          // onPanStart: isDragging
          //     ? null
          //     : (_) {
          //         'start'.logger();
          //         notifier.startDragging(id);
          //       },
          // onPanEnd: isDragging
          //     ? (_) {
          //         'end'.logger();
          //         notifier.stopDragging();
          //       }
          //     : null,
          // onPanCancel: isDragging
          //     ? () {
          //         'cancel'.logger();
          //         notifier.stopDragging();
          //       }
          //     : null,
          child: InkWell(
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            mouseCursor: SystemMouseCursors.basic,
            // onHover: (_) {
            //   if (ref.read(sheetProvider).isDragging) {
            //     notifier.dragHover(id);
            //   }
            // },
            onTap: focused
                ? null
                : () {
                    if (selected) return notifier.focusCell(id);
                    notifier.selectCell(
                      id,
                      clearAll: context.platform == TargetPlatform.macOS
                          ? !HardwareKeyboard.instance.isMetaPressed
                          : !HardwareKeyboard.instance.isControlPressed,
                    );
                  },
            // onDoubleTap: selected & !focused ? () => notifier.focusCell(id) : null,
            child: focused
                ? _Input(
                    data: data,
                    onSubmitted: notifier.unfocus,
                    onChanged: (value) => notifier.setCellData(id, value),
                  )
                : _View(data: data),
          ),
        ),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.data});

  final CellData data;

  @override
  Widget build(BuildContext context) {
    final style = data.textStyle;
    return Align(
      alignment: switch (data.align) {
        CellAlign.left => Alignment.centerLeft,
        CellAlign.center => Alignment.center,
        CellAlign.right => Alignment.centerRight,
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          data.value,
          textAlign: switch (data.align) {
            CellAlign.left => TextAlign.left,
            CellAlign.center => TextAlign.center,
            CellAlign.right => TextAlign.right,
          },
          style: TextStyle(
            fontSize: 16,
            color: style.color,
            fontWeight: style.bold ? FontWeight.bold : null,
            fontStyle: style.italic ? FontStyle.italic : null,
            decoration: style.strike ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}

class _Input extends HookWidget {
  const _Input({this.data, this.onSubmitted, this.onChanged});

  final CellData? data;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: data?.value);
    final style = data?.textStyle;
    return TextField(
      controller: controller,
      autofocus: true,
      textAlign: switch (data?.align) {
        CellAlign.left => TextAlign.left,
        CellAlign.center => TextAlign.center,
        CellAlign.right => TextAlign.right,
        null => TextAlign.start,
      },
      style: TextStyle(
        fontSize: 16,
        color: style?.color,
        fontWeight: style?.bold ?? false ? FontWeight.bold : null,
        fontStyle: style?.italic ?? false ? FontStyle.italic : null,
        decoration: style?.strike ?? false ? TextDecoration.lineThrough : null,
      ),
      textAlignVertical: TextAlignVertical.top,
      onTapOutside: (_) => onSubmitted?.call(),
      // onSubmitted: (_) => onSubmitted?.call(),
      onChanged: onChanged,
      cursorHeight: 16,
      // expands: true,
      maxLines: null,
      decoration: const InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      ),
    );
  }
}
