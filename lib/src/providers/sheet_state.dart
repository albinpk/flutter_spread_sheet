import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spread_sheet/src/models/cell_id.dart';

part 'sheet_state.freezed.dart';

@freezed
abstract class SheetState with _$SheetState {
  const factory SheetState({
    CellId? selectedCell,
    @Default({}) Map<int, double> rowSize,
    @Default({}) Map<int, double> colSize,
  }) = _SheetState;

  const SheetState._();

  double getColSize(int index) => colSize[index] ?? 120;

  double getRowSize(int index) => rowSize[index] ?? 30;
}
