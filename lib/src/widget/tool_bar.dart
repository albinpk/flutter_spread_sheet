import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/enums.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';

class ToolBar extends ConsumerWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sheetProvider);
    final notifier = ref.watch(sheetProvider.notifier);
    return Row(
      children: [
        SizedBox(width: 50, child: Text(state.selectedRange() ?? '')),

        SegmentedButton<CellAlign>(
          style: SegmentedButton.styleFrom(
            iconSize: 16,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
          ),
          segments:
              CellAlign.values
                  .map(
                    (e) => ButtonSegment(
                      value: e,
                      icon: Icon(e.icon),
                      tooltip: 'Align ${e.name}',
                    ),
                  )
                  .toList(),
          selected: {if (state.selectedCellAlign() case final align?) align},
          showSelectedIcon: false,
          emptySelectionAllowed: true,
          onSelectionChanged: (v) {
            if (v.firstOrNull case final align?) {
              notifier.setCellAlign(align);
            }
          },
        ),
      ],
    );
  }
}
