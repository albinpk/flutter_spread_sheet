import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/providers/sheet_state.dart';

class SheetCell extends HookConsumerWidget {
  const SheetCell({required this.id, super.key});

  final CellId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(sheetProvider.notifier);
    final (selected, data, focused) = ref.watch(
      sheetProvider.select((v) {
        return (v.isCellSelected(id), v.getCellData(id), v.isCellFocused(id));
      }),
    );

    ref.listen(sheetProvider, (_, next) {
      // if (next.selectedCell == id) focusNode.requestFocus();
    });

    return InkWell(
      focusColor: Colors.transparent,
      splashColor: Colors.transparent,
      mouseCursor: SystemMouseCursors.basic,
      onTap: focused ? null : () => notifier.selectCell(id),
      onDoubleTap: selected & !focused ? () => notifier.focusCell(id) : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color:
              selected && !focused
                  ? Colors.black.withValues(alpha: 0.05)
                  : Colors.transparent,
          border:
              selected
                  ? Border.all(width: focused ? 1.5 : 0)
                  : const Border.fromBorderSide(BorderSide.none),
        ),
        child:
            focused
                ? _Input(
                  data: data,
                  onSubmitted: notifier.unfocus,
                  onChanged: (value) => notifier.setCellData(id, value),
                )
                : Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(data?.value ?? ''),
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
    return TextField(
      controller: controller,
      autofocus: true,
      style: Theme.of(context).textTheme.bodyMedium,
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
