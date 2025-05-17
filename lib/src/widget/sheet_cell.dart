import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';

class SheetCell extends HookConsumerWidget {
  const SheetCell({required this.id, super.key});

  final CellId id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusNode = useFocusNode();
    final notifier = ref.watch(sheetProvider.notifier);
    useOnListenableChange(focusNode, () {
      if (focusNode.hasPrimaryFocus) notifier.focusCell(id);
    });

    final (selected, data) = ref.watch(
      sheetProvider.select((v) {
        return (v.selectedCell == id, v.getCellData(id));
      }),
    );
    final controller = useTextEditingController(text: data?.value);

    ref.listen(sheetProvider, (_, next) {
      if (next.selectedCell == id) focusNode.requestFocus();
    });

    return DecoratedBox(
      decoration: BoxDecoration(
        border:
            selected
                ? Border.all()
                : const Border.fromBorderSide(BorderSide.none),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onSubmitted: (_) => notifier.focusDown(),
        onChanged: (value) => notifier.setCellData(id, value),
        textAlignVertical: TextAlignVertical.top,
        cursorHeight: 16,
        // expands: true,
        // maxLines: null,
        decoration: const InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        ),
      ),
    );
  }
}
