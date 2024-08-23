import 'package:df_will_dispose/df_will_dispose.dart';

import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    context.willDispose(ValueNotifier(1));

    return Container(
      color: Colors.blue.shade200,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
