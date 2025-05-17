import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/providers/sheet_state.dart';

part 'sheet_provider.g.dart';

@riverpod
class Sheet extends _$Sheet {
  @override
  SheetState build() {
    return const SheetState();
  }

  void focusCell(CellId id) {
    state = state.copyWith(selectedCell: id);
  }

  void focusDown() {
    if (state.selectedCell == null) return;
    focusCell(state.selectedCell!.down);
  }

  void changeColSize(int col, double size) {
    final newSize = state.getColSize(col) + size;
    if (newSize < 30) return;
    state = state.copyWith(colSize: {...state.colSize, col: newSize});
  }

  void changeRowSize(int row, double size) {
    final i = row - 1; // title row
    final newSize = state.getRowSize(i) + size;
    if (newSize < 30) return;
    state = state.copyWith(rowSize: {...state.rowSize, i: newSize});
  }
}
