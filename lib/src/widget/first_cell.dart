import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spread_sheet/src/providers/sheet_provider.dart';

class FirstCell extends HookConsumerWidget {
  const FirstCell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => ref.read(sheetProvider.notifier).selectAllCell(),
    );
  }
}
