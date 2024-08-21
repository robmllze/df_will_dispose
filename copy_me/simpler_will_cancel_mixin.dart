// This is a simplified version of WillCancelMixin, with onBeforeCancel
// removed for simplicity. Feel free to copy, modify, and include it in your
// code as needed.

import 'package:flutter/foundation.dart' show mustCallSuper, nonVirtual;

mixin WillCancelMixin on CancelMixin {
  final List<dynamic> _resources = []; // List to keep track of resources.

  @nonVirtual
  T willCancel<T>(T resource) {
    _resources.add(resource); // Add resource to the list for later cancellation.
    return resource;
  }

  @mustCallSuper
  @override
  void cancel() {
    for (final resource in _resources) {
      try {
        resource.cancel(); // Call the cancel method.
      } on NoSuchMethodError {
        assert(false, () {
          throw NoCancelMethodDebugError(
              resource.runtimeType,); // Handle missing cancel method.
        });
      }
    }
    super.cancel(); // Call the parent cancel method.
  }
}

// Error class for resources without a cancel method.
final class NoCancelMethodDebugError extends Error {
  final Type resourceType;

  NoCancelMethodDebugError(this.resourceType);

  @override
  String toString() {
    return 'NoCancelMethodDebugError: The type $resourceType does not implement a cancel() method. '
        "Either don't use willCancel() with this type, implement CancelMixin, "
        'or use a valid type that has a cancel method.';
  }
}

// Mixin to add a cancel method to a class.
mixin CancelMixin {
  void cancel();
}
