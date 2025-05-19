import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell_text_style.freezed.dart';

@freezed
abstract class CellTextStyle with _$CellTextStyle {
  const factory CellTextStyle({
    @Default(false) bool bold,
    @Default(false) bool italic,
    @Default(false) bool strike,
    @Default(Colors.black) Color color,
  }) = _CellTextStyle;
}
