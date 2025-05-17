import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spread_sheet/src/models/cell_id.dart';

class SheetModel extends InheritedModel<ModelType> {
  const SheetModel({
    required this.selectedCell,
    required this.rowSize,
    required this.colSize,
    required super.child,
    super.key,
  });

  final CellId? selectedCell;
  final Map<int, double> rowSize;
  final Map<int, double> colSize;

  @override
  bool updateShouldNotify(covariant SheetModel oldWidget) {
    return true;
    // TODO(albin): map has same reference
    return selectedCell != oldWidget.selectedCell ||
        !mapEquals(colSize, oldWidget.colSize) ||
        !mapEquals(rowSize, oldWidget.rowSize);
  }

  @override
  bool updateShouldNotifyDependent(
    covariant SheetModel oldWidget,
    Set<ModelType> dependencies,
  ) {
    return true;
    if (dependencies.contains(ModelType.selectedCell) &&
        selectedCell != oldWidget.selectedCell) {
      return true;
    }

    if (dependencies.contains(ModelType.colSize) &&
        !mapEquals(colSize, oldWidget.colSize)) {
      return true;
    }

    if (dependencies.contains(ModelType.rowSize) &&
        !mapEquals(rowSize, oldWidget.rowSize)) {
      return true;
    }

    return false;
  }

  static SheetModel of(BuildContext context, {ModelType? type}) {
    return InheritedModel.inheritFrom<SheetModel>(context, aspect: type)!;
  }
}

enum ModelType { selectedCell, colSize, rowSize }
