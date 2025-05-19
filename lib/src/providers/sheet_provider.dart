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
    state = state.copyWith(focusedCell: id, selectedCells: {id});
  }

  void unfocus() => state = state.copyWith(focusedCell: null);

  void selectCell(CellId id, {bool clearAll = true}) {
    state = state.copyWith(
      selectedCells: {if (!clearAll) ...state.selectedCells, id},
    );
  }

  void focusDown() {
    // if (state.selectedCell == null) return;
    // focusCell(state.selectedCell!.down);
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

  void setCellData(CellId id, String value) {
    state = state.copyWith(
      data: {
        ...state.data,
        id.row: {...?state.data[id.row], id.col: CellData(value: value)},
      },
    );
  }
}
