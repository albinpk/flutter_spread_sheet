// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

@immutable
class CellId {
  const CellId({required this.row, required this.col});

  factory CellId.fromVicinity(TableVicinity vicinity) {
    return CellId(row: vicinity.row, col: vicinity.column);
  }

  final int row;
  final int col;

  CellId get down => copyWith(row: row + 1);

  @override
  String toString() => 'CellId(row: $row, col: $col)';

  @override
  bool operator ==(covariant CellId other) {
    if (identical(this, other)) return true;

    return other.row == row && other.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  CellId copyWith({int? row, int? col}) {
    return CellId(row: row ?? this.row, col: col ?? this.col);
  }
}
