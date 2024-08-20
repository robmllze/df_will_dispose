//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/foundation.dart' show VoidCallback, kDebugMode, mustCallSuper, nonVirtual;

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mixin that simplifies the disposal of resources that implement
/// either [ChangeNotifier] or [DisposeMixin]. This allows you to easily
/// mark resources for disposal at the same time as you define them,
/// making your code more concise.
///
/// The resources marked with [willDispose] will be disposed of when the
/// [dispose] method is called, but the marking itself is not automatic.
/// You still need to explicitly call [willDispose] on each resource.
/// ---
/// ### Example:
/// ```dart
/// late final _controller = willDispose(TextEditingController());
/// ```
mixin WillDisposeMixin on DisposeMixin {
  /// A list of resources that will be manually marked for disposal when
  /// [dispose] is called.
  List<DisposableResource> get resources => List.unmodifiable(_resources);

  final List<DisposableResource> _resources = [];

  /// Marks a resource for disposal. This method allows you to define and
  /// mark a resource for disposal on the same line, simplifying the code.
  ///
  /// Only resources that implement `dispose()` are supported, such as
  /// [ChangeNotifier], [DisposeMixin] and more. If the resource does not
  /// implement one of these interfaces, a [NoDisposeMethodDebugError] will be
  /// thrown during disposal.
  ///
  /// You can optionally provide an [onBeforeDispose] callback that will be
  /// invoked just before the resource is disposed of.
  ///
  /// Returns the resource back to allow for easy chaining or assignment.
  ///
  /// ---
  /// ### Example:
  /// ```dart
  /// final _controller = willDispose(TextEditingController(), onBeforeDispose: () {
  ///   print('TextEditingController disposed');
  /// });
  /// ```
  @nonVirtual
  T willDispose<T>(T resource, {void Function()? onBeforeDispose}) {
    final disposable = (
      resource: resource,
      onBeforeDispose: onBeforeDispose,
    );
    _resources.add(disposable);

    return resource;
  }

  /// Disposes of all resources, including those marked using [willDispose].
  @mustCallSuper
  @override
  void dispose() {
    final exceptions = <Object>[];
    for (final disposable in _resources) {
      final resource = disposable.resource;
      try {
        // Ensure the resource has a dispose method; throw an error if not.
        late VoidCallback dispose;
        try {
          dispose = resource.dispose as VoidCallback;
        } on NoSuchMethodError {
          throw NoDisposeMethodDebugError([resource.runtimeType]);
        }

        // Attempt to call onBeforeDispose, catching and copying any errors.
        Object? onBeforeDisposeError;
        try {
          disposable.onBeforeDispose?.call();
        } catch (e) {
          onBeforeDisposeError = e;
        }

        // Always dispose of the resource, even if onBeforeDispose throws an
        // error.
        dispose();

        // After successful disposal, rethrow any error from onBeforeDispose.
        if (onBeforeDisposeError != null) {
          throw onBeforeDisposeError;
        }
      } catch (e) {
        // Collect exceptions to throw them all at the end, ensuring disposal
        // of all resources.
        exceptions.add(e);
      }
    }

    // Call the parent class's dispose method.
    super.dispose();

    // Throw any collected exceptions after disposal is complete.
    if (exceptions.isNotEmpty) {
      // Only throw NoDisposeMethodDebugError in debug mode. Ignore them in
      // release.
      if (kDebugMode) {
        final disposeErrors = exceptions.whereType<NoDisposeMethodDebugError>().toList();
        if (disposeErrors.isNotEmpty) {
          throw NoDisposeMethodDebugError(
            disposeErrors.map((e) => e.runtimeType).toList(),
          );
        }
      }
      // Throw the first non-NoDisposeMethodDebugError exception if any exist.
      final otherExceptions = exceptions.where((e) => e is! NoDisposeMethodDebugError).toList();
      if (otherExceptions.isNotEmpty) {
        throw otherExceptions.first;
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef DisposableResource = ({
  dynamic resource,
  VoidCallback? onBeforeDispose,
});

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// An [Error] thrown when a type without a `dispose` method is passed to
/// `willDispose()`.
///
/// Informs the developer that the resource type cannot be properly disposed of
/// using `willDispose()`.
final class NoDisposeMethodDebugError extends Error {
  final Iterable<Type> resourceTypes;

  NoDisposeMethodDebugError(this.resourceTypes);

  @override
  String toString() {
    return 'NoDisposeMethodDebugError: The types $resourceTypes do not implement a dispose() method. '
        "Either don't use willDispose() with this type, implement DisposeMixin, "
        'or use a valid type that has a dispose method.';
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mixin that adds a [dispose] method to a class.
mixin DisposeMixin {
  /// Override to manage the disposal of resources.
  void dispose();
}
