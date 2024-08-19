//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:flutter/foundation.dart';

import 'dispose_mixin.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A mixin that simplifies the disposal of resources that implement
/// either [ChangeNotifier] or [DisposeMixin]. This allows you to easily
/// mark resources for disposal at the same time as you define them,
/// making your code more concise.
///
/// The resources marked with [willDispose] will be disposed of when the
/// [dispose] method is called, but the marking itself is not automatic.
/// You still need to explicitly call [willDispose] on each resource.
///
/// ---
/// ### Example:
/// ```dart
/// late final _controller = willDispose(TextEditingController());
/// ```
mixin WillDisposeMixin on DisposeMixin {
  /// A list of resources that will be manually marked for disposal when
  /// [dispose] is called.
  final List<_Disposable> _disposables = [];

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
  /// final _controller = willDispose(TextEditingController(), onBeforeDispose: () {
  ///   print('TextEditingController disposed');
  /// });
  /// ```
  @nonVirtual
  T willDispose<T>(T resource, {void Function()? onBeforeDispose}) {
    final disposable = _isDisposable(resource);
    assert(
      disposable,
      'Invalid argument: autoDispose() was called with an instance of ${resource.runtimeType}. '
      'Only instances of ChangeNotifier or DisposeMixin are supported.',
    );
    if (disposable) {
      _disposables.add(_Disposable(resource, onBeforeDispose));
    }
    return resource;
  }

  /// Disposes of all resources, including those marked using [willDispose].
  @mustCallSuper
  @override
  void dispose() {
    for (final disposable in _disposables) {
      final res = disposable.resource;
      if (res is ChangeNotifier) {
        res.dispose();
      }
      if (res is DisposeMixin) {
        res.dispose();
      }

      disposable.onDispose?.call();
    }
    super.dispose();
  }

  /// Checks if a resource is disposable by verifying if it implements either
  /// [ChangeNotifier] or [DisposeMixin].
  ///
  /// Returns `true` if the resource can be disposed of using this mixin,
  /// `false` otherwise.
  bool _isDisposable(dynamic resource) {
    return resource is ChangeNotifier || resource is DisposeMixin;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// A helper class that stores a resource and an optional `onDispose` callback.
class _Disposable {
  final dynamic resource;
  final void Function()? onDispose;

  _Disposable(this.resource, this.onDispose);
}
