import 'package:df_will_dispose/df_will_dispose.dart';

import 'package:flutter/material.dart';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  late final valueNotifer = context.willDispose(ValueNotifier(1));
  int setStateCounter = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade200,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: valueNotifer,
            builder: (context, value, child) {
              return Text(value.toString());
            },
          ),
          OutlinedButton(
            onPressed: () {
              setState(() {
                setStateCounter++;
              });
            },
            child: Text('setState $setStateCounter'),
          ),
          OutlinedButton(
            onPressed: () {
              valueNotifer.value++;
            },
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
