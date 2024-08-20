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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class Example1 extends StatefulWidget {
  const Example1({super.key});

  @override
  _Example1State createState() => _Example1State();
}

// Option 1: WillDisposeState<Example1>.
// Option 2: State<Example1> with DisposeMixin, WillDisposeMixin.
class _Example1State extends WillDisposeState<Example1> {
  // Define resources and schedule them to be disposed when this widget gets
  // removed from the widget tree.
  late final _textEditingController = willDispose(TextEditingController());
  late final _valueNotifier = willDispose(ValueNotifier('Initial Value'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WillDispose Example')),
      body: Column(
        children: [
          TextField(controller: _textEditingController),
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

  /// Override this method if you need to customize the disposal behavior.
  @override
  void onDispose(WillDispose willDispose) {
    if (kDebugMode) {
      print('${willDispose.resources.length} resources are about to be disposed!');
    }
    willDispose.dispose();
  }

  @override
  Widget build(BuildContext context, WillDispose willDispose) {
    // Define resources and schedule them to be disposed when this widget gets
    // removed from the widget tree.
    final textEditingController = willDispose(TextEditingController());
    final focusNode = willDispose(FocusNode());

    return Column(
      children: [
        TextField(
          controller: textEditingController,
          focusNode: focusNode,
        ),
      ],
    );
  }
}

void main() => runApp(const MaterialApp(home: Example1()));
