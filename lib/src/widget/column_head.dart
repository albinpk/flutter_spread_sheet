import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/utils/extensions.dart';
import 'package:spread_sheet/src/utils/functions.dart';
import 'package:spread_sheet/src/widget/drag_handle.dart';

class ColumnHead extends HookConsumerWidget {
  const ColumnHead({required this.index, super.key});

  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hover = useState(false);
    final controller = useMemoized(MenuController.new);
    final notifier = ref.watch(sheetProvider.notifier);
    final (selected, isPinned) = ref.watch(
      sheetProvider.select(
        (v) => (v.isColSelected(index), v.pinnedCol == index),
      ),
    );
    return MouseRegion(
      onEnter: (_) => hover.value = true,
      onExit: (_) => hover.value = false,
      child: ColoredBox(
        color: selected ? context.cs.primaryContainer : Colors.transparent,
        child: Stack(
          children: [
            InkWell(
              onTap: () => notifier.selectCol(index),
              onSecondaryTap: controller.open,
              child: Center(
                child: Text(
                  getColumnTitle(index),
                  style: const TextStyle(fontWeight: FontWeight.w300),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hover.value || controller.isOpen)
                    _buildMenu(
                      controller: controller,
                      notifier: notifier,
                      pinned: isPinned,
                    ),
                  DragHandle(
                    axis: Axis.horizontal,
                    onUpdate: (value) => notifier.changeColSize(index, value),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          leadingIcon: pinned
              ? const Icon(Icons.done, size: 18)
              : const SizedBox(width: 18),
          child: const Text('Freeze'),
          onPressed: () => notifier.pinCol(pinned ? null : index),
        ),
        SubmenuButton(
          menuChildren: [
            MenuItemButton(
              leadingIcon: const Icon(Icons.arrow_downward_rounded, size: 18),
              child: const Text('Ascending'),
              onPressed: () => notifier.sortCol(index, asc: true),
            ),
            MenuItemButton(
              leadingIcon: const Icon(Icons.arrow_upward_rounded, size: 18),
              child: const Text('Descending'),
              onPressed: () => notifier.sortCol(index, asc: false),
            ),
          ],
          leadingIcon: const Icon(Icons.sort_by_alpha_rounded, size: 18),
          child: const Text('Sort'),
        ),
      ],
      child: IconButton(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
        ),
        padding: EdgeInsets.zero,
        onPressed: controller.open,
        icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black54),
      ),
    );
  }
}
