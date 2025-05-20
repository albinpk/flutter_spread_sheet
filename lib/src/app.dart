import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';
import 'package:spread_sheet/src/widget/column_head.dart';
import 'package:spread_sheet/src/widget/first_cell.dart';
import 'package:spread_sheet/src/widget/row_head.dart';
import 'package:spread_sheet/src/widget/sheet_cell.dart';
import 'package:spread_sheet/src/widget/tool_bar.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (rowCount, colCount, pinnedCol) = ref.watch(
      sheetProvider.select((v) => (v.rowCount, v.colCount, v.pinnedCol)),
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const ToolBar(),
            const SizedBox(height: 10),
            Expanded(
              child: TableView.builder(
                verticalDetails: const ScrollableDetails.vertical(
                  physics: ClampingScrollPhysics(),
                ),
                horizontalDetails: const ScrollableDetails.horizontal(
                  physics: ClampingScrollPhysics(),
                ),
                pinnedColumnCount: pinnedCol == null ? 1 : pinnedCol + 2,
                pinnedRowCount: 1,
                rowCount: rowCount + 1, // + 1 for title
                columnCount: colCount,
                diagonalDragBehavior: DiagonalDragBehavior.free,
                columnBuilder: (i) => _columnBuilder(i, ref),
                rowBuilder: (i) => _rowBuilder(i, ref),
                cellBuilder: _cellBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _border = BorderSide(color: Colors.black12, width: 0.5);

  TableSpan _columnBuilder(int index, WidgetRef ref) {
    final (size, pinned) = ref.watch(
      sheetProvider.select(
        (v) => (v.getColSize(index - 1), v.pinnedCol == index - 1),
      ),
    );
    return TableSpan(
      extent: index == 0 ? const FixedSpanExtent(40) : FixedSpanExtent(size),
      backgroundDecoration: SpanDecoration(
        border: SpanBorder(
          leading: _border,
          trailing:
              pinned
                  ? _border.copyWith(width: 2, color: Colors.black26)
                  : _border,
        ),
      ),
    );
  }

  TableSpan _rowBuilder(int index, WidgetRef ref) {
    final size = ref.watch(
      sheetProvider.select((v) => v.getRowSize(index - 1)),
    );
    return TableSpan(
      extent: FixedSpanExtent(size),
      backgroundDecoration: const SpanDecoration(
        border: SpanBorder(leading: _border, trailing: _border),
      ),
    );
  }

  TableViewCell _cellBuilder(BuildContext context, TableVicinity vicinity) {
    return TableViewCell(
      child:
          vicinity.row == 0 && vicinity.column == 0
              ? const FirstCell()
              : vicinity.row == 0
              ? ColumnHead(index: vicinity.column - 1)
              : vicinity.column == 0
              ? RowHead(index: vicinity.row)
              : SheetCell(
                id: CellId(row: vicinity.row, col: vicinity.column - 1),
              ),
    );
  }
}
