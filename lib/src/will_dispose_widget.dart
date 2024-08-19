//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/material.dart';

import '_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A widget that simplifies the disposal of resources that implement
/// either [ChangeNotifier] or [DisposeMixin]. This allows you to easily
/// mark resources for disposal within the [build] function via [WillDispose].
@visibleForTesting
abstract class WillDisposeWidget extends StatefulWidget {
  const WillDisposeWidget({super.key});

  @override
  _WillDisposeWidgetState createState() => _WillDisposeWidgetState();

  @protected
  Widget build(BuildContext context, WillDispose willDispose);
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _WillDisposeWidgetState extends State<WillDisposeWidget> {
  final _willDispose = WillDispose._();

  @override
  Widget build(BuildContext context) {
    return widget.build(context, _willDispose);
  }

  @override
  void dispose() {
    _willDispose.dispose();
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _DisposeMixin with DisposeMixin {
  @override
  void dispose() {}
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// The [WillDispose] class manages disposable resources within a widget.
class WillDispose extends _DisposeMixin with WillDisposeMixin {
  WillDispose._();

  /// Marks a resource for disposal. This method allows you to define and
  /// mark a resource for disposal on the same line, simplifying the code.
  ///
  /// Only resources that implement [ChangeNotifier] or [DisposeMixin] are
  /// supported. If the resource does not implement one of these interfaces,
  /// an assert will trigger indicating the misuse.
  ///
  /// You can optionally provide an [onBeforeDispose] callback that will be
  /// invoked just before the resource is disposed of.
  ///
  /// Returns the resource back to allow for easy chaining or assignment.
  ///
  /// ---
  /// ### Example:
  /// ```dart
  /// Widget build(BuildContext context, WillDispose willDispose) {
  ///   final _controller = willDispose(TextEditingController());
  /// }
  /// ```
  T call<T>(T resource, {void Function()? onBeforeDispose}) {
    return willDispose(resource, onBeforeDispose: onBeforeDispose);
  }
}
