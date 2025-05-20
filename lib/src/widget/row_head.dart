import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/utils/extensions.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class RowHead extends HookConsumerWidget {
  const RowHead({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useMemoized(MenuController.new);
    final notifier = ref.watch(sheetProvider.notifier);
    final (selected, isPinned) = ref.watch(
      sheetProvider.select(
        (v) => (v.isRowSelected(index), v.pinnedRow == index),
      ),
    );
    return ColoredBox(
      color: selected ? context.cs.primaryContainer : Colors.transparent,
      child: Stack(
        children: [
          InkWell(
            onTap: () => notifier.selectRow(index),
            onSecondaryTap: controller.open,
            child: Center(
              child: Text(
                index.toString(),
                style: const TextStyle(fontWeight: FontWeight.w300),
              ),
            ),
          ),

          // menu button (visible on right click)
          Align(
            alignment: Alignment.centerRight,
            child: _buildMenu(
              controller: controller,
              notifier: notifier,
              pinned: isPinned,
            ),
          ),

          // drag handle
          Align(
            alignment: Alignment.bottomCenter,
            child: DragHandle(
              axis: Axis.vertical,
              onUpdate: (value) => notifier.changeRowSize(index, value),
            ),
          ),
        ],
      ),
    );
  }

  MenuAnchor _buildMenu({
    required MenuController controller,
    required Sheet notifier,
    required bool pinned,
  }) {
    return MenuAnchor(
      controller: controller,
      menuChildren: [
        MenuItemButton(
          leadingIcon:
              pinned
                  ? const Icon(Icons.done, size: 18)
                  : const SizedBox(width: 18),
          child: const Text('Freeze'),
          onPressed: () => notifier.pinRow(pinned ? null : index),
        ),
      ],
    );
  }
}
