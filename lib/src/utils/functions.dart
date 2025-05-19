/// A, B, C, ..., Z, AA, AB, etc.
String getColumnTitle(int index) {
  const max = 26;
  final quotient = index ~/ max;
  final remainder = index % max;
  return quotient > 0
      ? getColumnTitle(quotient - 1) + String.fromCharCode(remainder + 65)
      : String.fromCharCode(remainder + 65);
}
