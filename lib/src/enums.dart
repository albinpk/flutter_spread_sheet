import 'package:flutter/material.dart';

/// Alignment options for a cell in the spreadsheet.
enum CellAlign {
  left(Icons.format_align_left_rounded),
  center(Icons.format_align_center_rounded),
  right(Icons.format_align_right_rounded);

  const CellAlign(this.icon);

  final IconData icon;
}
