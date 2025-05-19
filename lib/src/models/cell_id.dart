import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:spread_sheet/src/utils/functions.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

part 'cell_id.freezed.dart';

@freezed
abstract class CellId with _$CellId {
  const factory CellId({required int row, required int col}) = _CellId;

  const CellId._();

  factory CellId.fromVicinity(TableVicinity vicinity) {
    return CellId(row: vicinity.row, col: vicinity.column);
  }

  CellId get down => copyWith(row: row + 1);

  /// Get cell address in the format "A1", "B2", etc.
  String toAddress() => '${getColumnTitle(col)}$row ';
}
