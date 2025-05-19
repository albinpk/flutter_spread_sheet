import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spread_sheet/src/enums.dart';
import 'package:spread_sheet/src/models/cell_id.dart';

part 'sheet_state.freezed.dart';

@freezed
abstract class SheetState with _$SheetState {
  const factory SheetState({
    CellId? focusedCell,
    @Default({}) Set<CellId> selectedCells,
    @Default({}) Map<int, double> rowSize,
    @Default({}) Map<int, double> colSize,
    @Default({}) Map<int, Map<int, CellData>> data,
    @Default(100) int rowCount,
    @Default(27) int colCount,
  }) = _SheetState;

  const SheetState._();

  double getColSize(int index) => colSize[index] ?? 120;

  double getRowSize(int index) => rowSize[index] ?? 30;

  CellData getCellData(CellId id) => data[id.row]?[id.col] ?? CellData.empty;

  bool isCellSelected(CellId id) => selectedCells.contains(id);

  bool isCellFocused(CellId id) => focusedCell == id;

  bool isColSelected(int col) => selectedCells.any((id) => id.col == col);

  bool isRowSelected(int row) => selectedCells.any((id) => id.row == row);

  String? selectedRange() => selectedCells.singleOrNull?.toAddress();

  CellAlign? selectedCellAlign() {
    return selectedCells.map((e) => getCellData(e).align).toSet().singleOrNull;
  }
}

@freezed
abstract class CellData with _$CellData {
  const factory CellData({
    @Default('') String value,
    @Default(CellAlign.left) CellAlign align,
  }) = _CellData;

  static const empty = CellData();
}
