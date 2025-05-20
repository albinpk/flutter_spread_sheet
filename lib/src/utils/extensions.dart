import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  ColorScheme get cs => Theme.of(this).colorScheme;
}
