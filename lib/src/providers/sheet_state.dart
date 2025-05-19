import 'package:freezed_annotation/freezed_annotation.dart';
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
  }) = _SheetState;

  const SheetState._();

  double getColSize(int index) => colSize[index] ?? 120;

  double getRowSize(int index) => rowSize[index] ?? 30;

  CellData? getCellData(CellId id) => data[id.row]?[id.col];

  bool isCellSelected(CellId id) => selectedCells.contains(id);

  bool isCellFocused(CellId id) => focusedCell == id;

  bool isColSelected(int col) => selectedCells.any((id) => id.col == col);

  bool isRowSelected(int row) => selectedCells.any((id) => id.row == row);
}

@freezed
abstract class CellData with _$CellData {
  const factory CellData({required String value}) = _CellData;
}
