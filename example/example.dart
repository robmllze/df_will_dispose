//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: unused_field

import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'package:df_will_dispose/df_will_dispose.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// EXAMPLE 1
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class TimerWithCounterExample extends StatefulWidget {
  const TimerWithCounterExample({super.key});

  @override
  _TimerWithCounterExampleState createState() => _TimerWithCounterExampleState();
}

class _TimerWithCounterExampleState extends WillDisposeState<TimerWithCounterExample> {
  // Define resources and schedule them to be disposed when this widget ia
  // removed from the widget tree.
  late final _secondsRemaining = willDispose(ValueNotifier<int>(60));
  late final _tickCounter = willDispose(ValueNotifier<int>(0));
  late final _timer = willDispose(
    Timer.periodic(
      const Duration(seconds: 1),
      _onTick,
    ),
  );

  void _onTick(Timer timer) {
    if (_secondsRemaining.value > 0) {
      _secondsRemaining.value--;
      _tickCounter.value++;
    } else {
      timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _secondsRemaining,
          builder: (context, value, child) {
            return Text(
              '$value seconds remaining',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
        const SizedBox(height: 20),
        ValueListenableBuilder<int>(
          valueListenable: _tickCounter,
          builder: (context, value, child) {
            return Text(
              'Ticks: $value',
              style: const TextStyle(fontSize: 24),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    // All resources will be disposed of automatically here.
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// EXAMPLE 2
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ChatBoxExample extends WillDisposeWidget {
  const ChatBoxExample({super.key});

  @override
  Widget build(BuildContext context, WillDispose willDispose) {
    // Define resources and schedule them to be disposed when this widget ia
    // removed from the widget tree.
    final textEditingController = willDispose(TextEditingController());
    final focusNode = willDispose(FocusNode());

    return Row(
      children: [
        TextField(
          controller: textEditingController,
          focusNode: focusNode,
        ),
        ElevatedButton(
          onPressed: () {
            final text = textEditingController.text;
            if (kDebugMode) {
              print('Submitted: $text');
            }
            textEditingController.clear();
            focusNode.requestFocus();
          },
          child: const Text('Submit!'),
        ),
      ],
    );
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
//
// EXAMPLE 3
//
// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FormExample extends WillDisposeWidget {
  const FormExample({super.key});

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
    // Define resources and schedule them to be disposed when this widget ia
    // removed from the widget tree.
    final textEditingController = willDispose(TextEditingController());
    final scrollController = willDispose(ScrollController());
    final focusNode = willDispose(FocusNode());

    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: const InputDecoration(labelText: 'Enter your name'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final text = textEditingController.text;
              // Perform some action, like submitting the form.
              if (kDebugMode) {
                print('Name: $text');
              }
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Scroll to the top of the form and focus on the first field.
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
              focusNode.requestFocus();
            },
            child: const Text('Scroll to Top'),
          ),
        ],
      ),
    );
  }
}
