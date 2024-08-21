//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/foundation.dart'
    show ChangeNotifier, VoidCallback, kDebugMode, mustCallSuper, nonVirtual;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mixin that simplifies the disposal of resources that implement
/// either [ChangeNotifier] or [CancelMixin]. This allows you to easily
/// mark resources for disposal at the same time as you define them,
/// making your code more concise.
///
/// The resources marked with [willCancel] will be canceld of when the
/// [cancel] method is called, but the marking itself is not automatic.
/// You still need to explicitly call [willCancel] on each resource.
/// ---
/// ### Example:
/// ```dart
/// late final _controller = willCancel(TextEditingController());
/// ```
mixin WillCancelMixin on CancelMixin {
  /// A list of resources that will be manually marked for disposal when
  /// [cancel] is called.
  List<CancellableResource> get resources => List.unmodifiable(_resources);

  final List<CancellableResource> _resources = [];

  /// Marks a resource for disposal. This method allows you to define and
  /// mark a resource for disposal on the same line, simplifying the code.
  ///
  /// Only resources that implement `cancel()` are supported, such as
  /// [ChangeNotifier], [CancelMixin] and more. If the resource does not
  /// implement one of these interfaces, a [NoCancelMethodDebugError] will be
  /// thrown during disposal.
  ///
  /// You can optionally provide an [onBeforeCancel] callback that will be
  /// invoked just before the resource is canceld of.
  ///
  /// Returns the resource back to allow for easy chaining or assignment.
  ///
  /// ---
  /// ### Example:
  /// ```dart
  /// final _controller = willCancel(TextEditingController(), onBeforeCancel: () {
  ///   print('TextEditingController canceld');
  /// });
  /// ```
  @nonVirtual
  T willCancel<T>(T resource, {VoidCallback? onBeforeCancel}) {
    final disposable = (
      resource: resource,
      onBeforeCancel: onBeforeCancel,
    );
    _resources.add(disposable);

    return resource;
  }

  /// Cancels of all resources, including those marked using [willCancel].
  @mustCallSuper
  @override
  void cancel() {
    final exceptions = <Object>[];
    for (final disposable in _resources) {
      final resource = disposable.resource;
      try {
        // Ensure the resource has a cancel method; throw an error if not.
        late VoidCallback cancel;
        try {
          cancel = resource.cancel as VoidCallback;
        } on NoSuchMethodError {
          throw NoCancelMethodDebugError([resource.runtimeType]);
        }

        // Attempt to call onBeforeCancel, catching and copying any errors.
        Object? onBeforeCancelError;
        try {
          disposable.onBeforeCancel?.call();
        } catch (e) {
          onBeforeCancelError = e;
        }

        // Always cancel of the resource, even if onBeforeCancel throws an
        // error.
        cancel();

        // After successful disposal, rethrow any error from onBeforeCancel.
        if (onBeforeCancelError != null) {
          throw onBeforeCancelError;
        }
      } catch (e) {
        // Collect exceptions to throw them all at the end, ensuring disposal
        // of all resources.
        exceptions.add(e);
      }
    }

    // Call the parent class's cancel method.
    super.cancel();

    // Throw any collected exceptions after disposal is complete.
    if (exceptions.isNotEmpty) {
      // Only throw NoCancelMethodDebugError in debug mode. Ignore them in
      // release.
      if (kDebugMode) {
        final cancelErrors = exceptions.whereType<NoCancelMethodDebugError>().toList();
        if (cancelErrors.isNotEmpty) {
          throw NoCancelMethodDebugError(
            cancelErrors.map((e) => e.runtimeType).toList(),
          );
        }
      }
      // Throw the first non-NoCancelMethodDebugError exception if any exist.
      final otherExceptions = exceptions.where((e) => e is! NoCancelMethodDebugError).toList();
      if (otherExceptions.isNotEmpty) {
        throw otherExceptions.first;
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef CancellableResource = ({
  dynamic resource,
  VoidCallback? onBeforeCancel,
});

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// An [Error] thrown when a type without a `cancel` method is passed to
/// `willCancel()`.
///
/// Informs the developer that the resource type cannot be properly canceld of
/// using `willCancel()`.
final class NoCancelMethodDebugError extends Error {
  final Iterable<Type> resourceTypes;

  NoCancelMethodDebugError(this.resourceTypes);

  @override
  String toString() {
    return 'NoCancelMethodDebugError: The types $resourceTypes do not implement a cancel() method. '
        "Either don't use willCancel() with them, implement CancelMixin, "
        'or use a valid type that has a cancel() method.';
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mixin that adds a [cancel] method to a class.
mixin CancelMixin {
  /// Override to manage the disposal of resources.
  void cancel();
}
