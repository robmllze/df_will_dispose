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

extension WillCancelOnBuildContextX on BuildContext {
  /// Schedules the [resource] for cancellation when the current widget is
  /// removed from the widget tree. This attempts to call `cancel()` on
  /// the resource.
  ///
  /// Optionally, [onBeforeCancel] is called immediately before cancellation.
  ///
  /// In debug mode, throws [NoCancelMethodDebugError] if the resource does not
  /// have a `cancel()` method.
  T willCancel<T>(T resource, {VoidCallback? onBeforeCancel}) {
    final instance = _WillCancel();
    instance.willCancel(resource, onBeforeCancel: onBeforeCancel);
    return ContextStore.of(this).attach(
      resource,
      key: resource.hashCode,
      onDetach: (data) {
        instance.cancel();
      },
    );
  }
}

class _WillCancel extends _Cancel with WillCancelMixin {}

class _Cancel with CancelMixin {
  @override
  void cancel() {}
}
