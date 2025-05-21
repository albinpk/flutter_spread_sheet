import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cell_style.freezed.dart';

@freezed
abstract class CellStyle with _$CellStyle {
  const factory CellStyle({Color? bgColor}) = _CellStyle;
}
