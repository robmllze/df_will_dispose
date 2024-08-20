// This is a simplified version of WillDisposeMixin, with onBeforeDispose
// removed for simplicity. Feel free to copy, modify, and include it in your
// code as needed.

import 'package:flutter/foundation.dart' show mustCallSuper, nonVirtual;

mixin WillDisposeMixin on DisposeMixin {
  final List<dynamic> _resources = []; // List to keep track of resources.

  @nonVirtual
  T willDispose<T>(T resource) {
    _resources.add(resource); // Add resource to the list for later disposal.
    return resource;
  }

  @mustCallSuper
  @override
  void dispose() {
    for (final resource in _resources) {
      try {
        resource.dispose(); // Call the dispose method.
      } on NoSuchMethodError {
        assert(false, () {
          throw NoDisposeMethodDebugError(
              resource.runtimeType,); // Handle missing dispose method.
        });
      }
    }
    super.dispose(); // Call the parent dispose method.
  }
}

// Error class for resources without a dispose method.
final class NoDisposeMethodDebugError extends Error {
  final Type resourceType;

  NoDisposeMethodDebugError(this.resourceType);

  @override
  String toString() {
    return 'NoDisposeMethodDebugError: The type $resourceType does not implement a dispose() method. '
        "Either don't use willDispose() with this type, implement DisposeMixin, "
        'or use a valid type that has a dispose method.';
  }
}

// Mixin to add a dispose method to a class.
mixin DisposeMixin {
  void dispose();
}
