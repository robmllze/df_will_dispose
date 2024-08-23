//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. The use of this
// source code is governed by an MIT-style license described in the LICENSE
// file located in this project's root directory.
//
// See: https://opensource.org/license/mit
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/widgets.dart';

import '_index.g.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

extension WillDisposeOnBuildContextX on BuildContext {
  /// Schedules the [resource] for disposal when the current widget is
  /// removed from the widget tree. This attempts to call `dispose()` on
  /// the resource.
  ///
  /// Optionally, [onBeforeDispose] is called immediately before disposal.
  ///
  /// In debug mode, throws [NoDisposeMethodDebugError] if the resource does not
  /// have a `dispose()` method.
  T willDispose<T>(T resource, {VoidCallback? onBeforeDispose}) {
    final instance = _WillDispose();
    instance.willDispose(resource, onBeforeDispose: onBeforeDispose);
    return ContextStore.of(this).attach(
      resource,
      key: resource.hashCode,
      onDetach: (data) {
        instance.dispose();
      },
    );
  }
}

class _WillDispose extends _Dispose with WillDisposeMixin {}

class _Dispose with DisposeMixin {
  @override
  void dispose() {}
}
