//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/widgets.dart';

import '_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// An abstract [Widget] that simplifies managing resources that require
/// disposal. This widget provides a [WillDispose] instance to handle disposing
/// resources automatically.
/// ---
/// ### Example:
/// ```dart
/// class MyWidget extends WillDisposeWidget {
///   const MyWidget({super.key});
///
///   @override
///   Widget build(BuildContext context, WillDispose willDispose) {
///     // Mark resources for disposal when defining them.
///     final textController = willDispose(TextEditingController());
///     final focusNode = willDispose(FocusNode());
///
///     return Column(
///       children: [
///         TextField(controller: textController, focusNode: focusNode),
///         // Other widgets...
///       ],
///     );
///   }
/// }
/// ```
///
/// In this example, `TextEditingController` and `FocusNode` are marked for
/// disposal using the `willDispose` method. They will be automatically disposed
/// of when the widget is removed from the widget tree.
abstract class WillDisposeWidget extends StatefulWidget {
  const WillDisposeWidget({super.key});

  @protected
  @override
  _WillDisposeWidgetState createState() => _WillDisposeWidgetState();

  /// This method must be implemented by subclasses to build the widget's UI.
  /// It provides a [WillDispose] instance, allowing resources to be easily
  /// marked for disposal within the build method.
  @protected
  Widget build(BuildContext context, WillDispose willDispose);

  /// Override this method if you need to customize the disposal behavior.
  @protected
  void onDispose(WillDispose willDispose) {
    willDispose.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class _WillDisposeWidgetState extends State<WillDisposeWidget> with DisposeMixin {
  WillDispose? _willDispose;

  @override
  Widget build(BuildContext context) {
    // Dispose the previous WillDispose instance before creating a new one.
    // This ensures that any resources associated with the previous state are
    // properly cleaned up before rebuilding the widget.
    _willDispose?.dispose();
    _willDispose = WillDispose._();
    return widget.build(context, _willDispose!);
  }

  @override
  void dispose() {
    // Ensure all resources marked for disposal are cleaned up when the widget
    // is removed from the widget tree.
    widget.onDispose(_willDispose!);
    super.dispose();
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A basic mixin that provides a no-op [dispose] method.  This class can be
/// extended or mixed in when a class needs to implement DisposeMixin but
/// doesn't have any resources to dispose.
class _Dispose with DisposeMixin {
  @override
  void dispose() {}
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// The [WillDispose] class is used to manage the lifecycle of disposable
/// resources within a widget. It ensures that all resources are properly
/// disposed of when the widget is removed from the tree.
///
/// This class is typically used in conjunction with [WillDisposeWidget].
class WillDispose extends _Dispose with WillDisposeMixin {
  WillDispose._();

  /// Marks a resource for disposal. This method allows the resource to be
  /// managed by the [WillDispose] instance, ensuring it is disposed of
  /// automatically when the widget is disposed.
  ///
  /// The [onBeforeDispose] callback, if provided, will be invoked just
  /// before the resource is disposed of.
  ///
  /// Returns the resource back to allow for easy chaining or assignment.
  T call<T>(T resource, {void Function()? onBeforeDispose}) {
    return willDispose(resource, onBeforeDispose: onBeforeDispose);
  }
}
