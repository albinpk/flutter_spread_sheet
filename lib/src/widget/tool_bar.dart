import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/enums.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';

class ToolBar extends ConsumerWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sheetProvider);
    final notifier = ref.watch(sheetProvider.notifier);
    return SegmentedButtonTheme(
      data: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          iconSize: 16,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          ),
        ),
      ),
      child: Row(
        spacing: 10,
        children: [
          SizedBox(width: 50, child: Text(state.selectedRange() ?? '')),

          // text align
          SegmentedButton<CellAlign>(
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

          // text style
          SegmentedButton<CellTextStyleType>(
            segments:
                CellTextStyleType.values
                    .map((e) => ButtonSegment(value: e, icon: Icon(e.icon)))
                    .toList(),
            selected: state.selectedCellTextStyle(),
            multiSelectionEnabled: true,
            showSelectedIcon: false,
            emptySelectionAllowed: true,
            onSelectionChanged: notifier.setCellTextStyle,
          ),

          Row(
            children: [
              _ColorPicker(
                tooltip: 'Background Color',
                icon: const Icon(Icons.format_color_fill_rounded),
                onChange: notifier.setCellColor,
              ),
              _ColorPicker(
                tooltip: 'Text Color',
                icon: const Icon(Icons.format_color_text_rounded),
                onChange: notifier.setTextColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColorPicker extends HookWidget {
  const _ColorPicker({
    required this.icon,
    required this.onChange,
    required this.tooltip,
  });

  final Widget icon;
  final ValueChanged<Color> onChange;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final controller = useOverlayPortalController();
    final link = useMemoized(LayerLink.new);
    return OverlayPortal(
      controller: controller,
      child: CompositedTransformTarget(
        link: link,
        child: IconButton(
          tooltip: tooltip,
          onPressed: controller.show,
          icon: icon,
        ),
      ),
      overlayChildBuilder: (context) {
        return CompositedTransformFollower(
          link: link,
          targetAnchor: Alignment.bottomRight,
          offset: const Offset(-200, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: TapRegion(
              onTapOutside: (_) => controller.hide(),
              child: Card(
                elevation: 4,
                child: SizedBox(
                  width: 200,
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    padding: const EdgeInsets.all(4),
                    shrinkWrap: true,
                    children: [
                      for (final color in [
                        ...Colors.primaries,
                        Colors.black,
                        Colors.white,
                      ])
                        Card.outlined(
                          margin: EdgeInsets.zero,
                          clipBehavior: Clip.hardEdge,
                          color: color,
                          child: InkWell(
                            onTap: () {
                              onChange(color);
                              controller.hide();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
