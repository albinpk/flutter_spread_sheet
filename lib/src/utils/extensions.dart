import 'package:flutter/widgets.dart';
import 'package:spread_sheet/src/app.dart';
import 'package:spread_sheet/src/sheet_state.dart';

extension ContextExt on BuildContext {
  SheetModel model([ModelType? type]) {
    return SheetModel.of(this, type: type);
  }

  AppState get state => AppState.of(this);
}
