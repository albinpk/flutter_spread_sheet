import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spread_sheet/src/enums.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/providers/sheet_state.dart';

part 'sheet_provider.g.dart';

@riverpod
class Sheet extends _$Sheet {
  @override
  SheetState build() {
    return SheetState(
      selectedCells: {const CellId(row: 1, col: 0)},
    );
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
    final data = state.data.clone();
    final row = data[id.row] ??= {};
    row[id.col] = row[id.col]?.copyWith(value: value) ?? CellData(value: value);
    state = state.copyWith(data: data);
  }

  void selectCol(int index) {
    state = state.copyWith(
      selectedCells: {
        for (int i = 0; i <= state.rowCount; i++) CellId(row: i, col: index),
      },
    );
  }

  void selectRow(int index) {
    state = state.copyWith(
      selectedCells: {
        for (int i = 0; i <= state.colCount; i++) CellId(row: index, col: i),
      },
    );
  }

  void setCellAlign(CellAlign align) {
    _updateSelectedCells((cell) => cell.copyWith(align: align));
  }

  void setCellTextStyle(Set<CellTextStyleType> type) {
    _updateSelectedCells(
      (cell) => cell.copyWith.textStyle(
        bold: type.contains(CellTextStyleType.bold),
        italic: type.contains(CellTextStyleType.italic),
        strike: type.contains(CellTextStyleType.strike),
      ),
    );
  }

  void sortCol(int index, {required bool asc}) {
    final data = state.data.clone();
    final nonEmpty = data.values.where(
      (e) => e[index]?.value.isNotEmpty ?? false,
    );
    final empty = data.values.where((e) => e[index]?.value.isEmpty ?? true);
    final sorted = nonEmpty
        .sorted((a, b) {
          final aData = a[index]!;
          final bData = b[index]!;
          return asc
              ? aData.value.compareTo(bData.value)
              : bData.value.compareTo(aData.value);
        })
        .followedBy(empty)
        .toList();
    state = state.copyWith(
      data: sorted.asMap().map((k, v) => MapEntry(k + 1, v)),
    );
  }

  void pinCol(int? index) {
    state = state.copyWith(pinnedCol: index);
  }

  void pinRow(int? index) {
    state = state.copyWith(pinnedRow: index);
  }

  void selectAllCell() {
    state = state.copyWith(
      selectedCells: {
        for (int i = 0; i <= state.rowCount; i++)
          for (int j = 0; j <= state.colCount; j++) CellId(row: i, col: j),
      },
    );
  }

  void setCellColor(Color color) {
    _updateSelectedCells((cell) => cell.copyWith.cellStyle(bgColor: color));
  }

  void setTextColor(Color color) {
    _updateSelectedCells((cell) => cell.copyWith.textStyle(color: color));
  }

  void _updateSelectedCells(CellData Function(CellData cell) fn) {
    if (state.selectedCells.isEmpty) return;
    final data = state.data.clone();
    for (final c in state.selectedCells) {
      final row = data[c.row] ??= {};
      row[c.col] = fn(row[c.col] ?? CellData.empty);
    }
    state = state.copyWith(data: data);
  }
}
