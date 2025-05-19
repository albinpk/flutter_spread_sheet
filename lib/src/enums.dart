import 'package:flutter/material.dart';

/// Alignment options for a cell in the spreadsheet.
enum CellAlign {
  left(Icons.format_align_left_rounded),
  center(Icons.format_align_center_rounded),
  right(Icons.format_align_right_rounded);

  const CellAlign(this.icon);

  final IconData icon;
}

/// Text style options for a cell in the spreadsheet.
enum CellTextStyleType {
  bold(Icons.format_bold_rounded),
  italic(Icons.format_italic_rounded),
  strike(Icons.format_strikethrough_rounded);

  const CellTextStyleType(this.icon);

  final IconData icon;
}
