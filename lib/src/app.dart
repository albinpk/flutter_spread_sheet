import 'package:flutter/material.dart';
import 'package:spread_sheet/src/models/cell_id.dart';
import 'package:spread_sheet/src/sheet_state.dart';
import 'package:spread_sheet/src/sheet_view.dart';
import 'package:spread_sheet/src/utils/logger.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  CellId? _selectedCell;

  @override
  Widget build(BuildContext context) {
    return SheetModel(
      selectedCell: _selectedCell,
      child: const Scaffold(
        body: Padding(padding: EdgeInsets.all(8), child: SheetView()),
      ),
    );
  }

  static AppState of(BuildContext context) {
    return context.findAncestorStateOfType<AppState>()!;
  }

  void focusCell(CellId id) {
    setState(() => _selectedCell = id.logger());
  }

  void focusDown() {
    if (_selectedCell == null) return;
    focusCell(_selectedCell!.down);
  }
}
