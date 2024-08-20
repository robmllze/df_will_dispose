//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:df_will_dispose/df_will_dispose.dart';
import 'package:flutter/material.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Example1 extends StatefulWidget {
  const Example1({super.key});

  @override
  _Example1State createState() => _Example1State();
}

// Option 1: WillDisposeState<MyWidget>.
// Option 2: State<MyWidget> with DisposeMixin, WillDisposeMixin.
class _Example1State extends WillDisposeState<Example1> {
  // Define resources and schedule them to be disposed when this widget gets
  // removed from the widget tree.
  late final _textController = willDispose(TextEditingController());
  late final _valueNotifier = willDispose(ValueNotifier('Initial Value'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WillDispose Example')),
      body: Column(
        children: [
          TextField(controller: _textController),
          ValueListenableBuilder<String>(
            valueListenable: _valueNotifier,
            builder: (context, value, child) => Text('Value: $value'),
          ),
          ElevatedButton(
            onPressed: () {
              _valueNotifier.value = 'Updated Value';
            },
            child: const Text('Update Value'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Resources marked with `willDispose` will be disposed automatically here.
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Example2 extends WillDisposeWidget {
  const Example2({super.key});

  @override
  Widget build(BuildContext context, WillDispose willDispose) {
    // Define resources and schedule them to be disposed when this widget gets
    // removed from the widget tree.
    final textController = willDispose(TextEditingController());
    final focusNode = willDispose(FocusNode());

    return Column(
      children: [
        TextField(
          controller: textController,
          focusNode: focusNode,
        ),
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: Example1()));
