// This is a simplified version of WillDisposeMixin, with onBeforeDispose and
// extensive comments removed for simplicity. Feel free to copy, modify, and
// include it in your code as needed.

import 'package:flutter/foundation.dart'
    show VoidCallback, kDebugMode, mustCallSuper, nonVirtual;

mixin SimpleWillDisposeMixin on DisposeMixin {
  final List<dynamic> _resources = []; // List to keep track of resources.

  @nonVirtual
  T willDispose<T>(T resource) {
    _resources.add(resource); // Add resource to the list for later disposal.
    return resource;
  }

  @mustCallSuper
  @override
  void dispose() {
    final exceptions = <Object>[]; // List to collect any exceptions.
    for (final resource in _resources) {
      try {
        final dispose = resource.dispose
            as VoidCallback; // Ensure resource has dispose method.
        dispose(); // Call the dispose method.
      } on NoSuchMethodError {
        assert(false, () {
          throw NoDisposeMethodDebugError(
            [resource.runtimeType],
          ); // Handle missing dispose method.
        });
      } catch (e) {
        exceptions.add(e); // Add any exceptions to the list.
      }
    }

    super.dispose(); // Call the parent dispose method.

    if (exceptions.isNotEmpty) {
      if (kDebugMode) {
        final disposeErrors =
            exceptions.whereType<NoDisposeMethodDebugError>().toList();
        if (disposeErrors.isNotEmpty) {
          throw NoDisposeMethodDebugError(
            disposeErrors.map((e) => e.runtimeType).toList(),
          ); // Throw errors in debug mode.
        }
      }

      final otherExceptions =
          exceptions.where((e) => e is! NoDisposeMethodDebugError).toList();
      if (otherExceptions.isNotEmpty) {
        throw otherExceptions.first; // Throw the first exception if any.
      }
    }
  }
}

// Error class for resources without a dispose method.
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

// Mixin to add a dispose method to a class.
mixin DisposeMixin {
  void dispose();
}
