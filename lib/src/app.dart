import 'package:flutter/material.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/sheet_view.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  CellId? _selectedCell;

  final Map<int, double> _rowSize = {};
  final Map<int, double> _colSize = {};

  @override
  Widget build(BuildContext context) {
    return SheetModel(
      selectedCell: _selectedCell,
      rowSize: _rowSize,
      colSize: _colSize,
      child: const Scaffold(
        body: Padding(padding: EdgeInsets.all(8), child: SheetView()),
      ),
    );
  }

  static AppState of(BuildContext context) {
    return context.findAncestorStateOfType<AppState>()!;
  }

  void focusCell(CellId id) {
    setState(() => _selectedCell = id);
  }

  void focusDown() {
    if (_selectedCell == null) return;
    focusCell(_selectedCell!.down);
  }

  void changeColSize(int col, double size) {
    final newSize = (_colSize[col] ?? SheetView.colSize) + size;
    if (newSize < 30) return;
    setState(() => _colSize[col] = newSize);
  }

  void changeRowSize(int row, double size) {
    final i = row - 1; // title row
    final newSize = (_rowSize[i] ?? SheetView.rowSize) + size;
    if (newSize < 30) return;
    setState(() => _rowSize[i] = newSize);
  }
}
