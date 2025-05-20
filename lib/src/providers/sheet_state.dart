import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spread_sheet/src/enums.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/models/cell_text_style.dart';

part 'sheet_state.freezed.dart';

typedef SheetRowData = Map<int, CellData>;

typedef SheetData = Map<int, SheetRowData>;

@freezed
abstract class SheetState with _$SheetState {
  const factory SheetState({
    CellId? focusedCell,
    @Default({}) Set<CellId> selectedCells,
    @Default({}) Map<int, double> rowSize,
    @Default({}) Map<int, double> colSize,
    @Default({
      // 1: {0: CellData(value: 'b'), 1: CellData(value: '1')},
      // 2: {0: CellData(value: 'a'), 1: CellData(value: '5')},
      // 3: {0: CellData(value: 'c'), 1: CellData(value: '9')},
      // 4: {0: CellData(value: 'e'), 1: CellData(value: '4')},
      // 5: {0: CellData(value: 'd'), 1: CellData(value: '2')},
    })
    SheetData data,
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

  Set<CellTextStyleType> selectedCellTextStyle() {
    final style = selectedCells.map((e) => getCellData(e).textStyle).toList();
    final bold = style.map((e) => e.bold).toSet().singleOrNull ?? false;
    final italic = style.map((e) => e.italic).toSet().singleOrNull ?? false;
    final strike = style.map((e) => e.strike).toSet().singleOrNull ?? false;
    return {
      if (bold) CellTextStyleType.bold,
      if (italic) CellTextStyleType.italic,
      if (strike) CellTextStyleType.strike,
    };
  }
}

@freezed
abstract class CellData with _$CellData {
  const factory CellData({
    @Default('') String value,
    @Default(CellAlign.left) CellAlign align,
    @Default(CellTextStyle()) CellTextStyle textStyle,
  }) = _CellData;

  static const empty = CellData();
}

extension SheetDataX on SheetData {
  /// Deep clone the sheet data
  SheetData clone() => {
    ...map((k, v) => MapEntry(k, {...v})),
  };
}
