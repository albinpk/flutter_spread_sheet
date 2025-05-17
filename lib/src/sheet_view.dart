import 'package:flutter/material.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/widget/column_address.dart';
import 'package:spread_sheet/src/widget/row_address.dart';
import 'package:spread_sheet/src/widget/sheet_cell.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class SheetView extends StatelessWidget {
  const SheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return TableView.builder(
      verticalDetails: const ScrollableDetails.vertical(
        physics: ClampingScrollPhysics(),
      ),
      horizontalDetails: const ScrollableDetails.horizontal(
        physics: ClampingScrollPhysics(),
      ),
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      diagonalDragBehavior: DiagonalDragBehavior.free,
      columnBuilder: _columnBuilder,
      rowBuilder: _rowBuilder,
      cellBuilder: _cellBuilder,
    );
  }

  TableSpan _columnBuilder(int index) {
    return TableSpan(
      extent:
          index == 0 ? const FixedSpanExtent(40) : const FixedSpanExtent(120),
      backgroundDecoration: const SpanDecoration(
        border: SpanBorder(
          leading: BorderSide(color: Colors.black12, width: 0.5),
          trailing: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
    );
  }

  TableSpan _rowBuilder(int index) {
    return const TableSpan(
      extent: FixedSpanExtent(30),
      backgroundDecoration: SpanDecoration(
        border: SpanBorder(
          leading: BorderSide(color: Colors.black12, width: 0.5),
          trailing: BorderSide(color: Colors.black12, width: 0.5),
        ),
      ),
    );
  }

  TableViewCell _cellBuilder(BuildContext context, TableVicinity vicinity) {
    return TableViewCell(
      child:
          vicinity.row == 0 && vicinity.column == 0
              ? const SizedBox.shrink()
              : vicinity.row == 0
              ? ColumnAddress(index: vicinity.column - 1)
              : vicinity.column == 0
              ? RowAddress(index: vicinity.row)
              : SheetCell(
                id: CellId(row: vicinity.row, col: vicinity.column - 1),
              ),
    );
  }
}
