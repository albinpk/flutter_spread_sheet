import 'package:flutter/material.dart';
import 'package:spread_sheet/src/models/cell_id.dart';

class SheetModel extends InheritedModel<ModelType> {
  const SheetModel({required super.child, super.key, this.selectedCell});

  final CellId? selectedCell;

  @override
  bool updateShouldNotify(covariant SheetModel oldWidget) {
    return selectedCell != oldWidget.selectedCell;
  }

  @override
  bool updateShouldNotifyDependent(
    covariant SheetModel oldWidget,
    Set<ModelType> dependencies,
  ) {
    if (dependencies.contains(ModelType.selectedCell) &&
        selectedCell != oldWidget.selectedCell) {
      return true;
    }
    return false;
  }

  static SheetModel of(BuildContext context, {ModelType? type}) {
    return InheritedModel.inheritFrom<SheetModel>(context, aspect: type)!;
  }
}

enum ModelType { selectedCell }
