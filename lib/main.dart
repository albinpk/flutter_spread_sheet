import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/app.dart';

void main() {
  runApp(const ProviderScope(child: Root()));
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const App(),
      theme: ThemeData.light().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          // border: OutlineInputBorder(borderSide: BorderSide.none),
          // focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.zero),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(iconSize: 18),
        ),
      ),
    );
  }
}
