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
import 'dart:collection';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

/// Provides a way to [attach], [retrieve], and [detach] data tied to a specific
/// [BuildContext] and key, ensuring effective management of context-bound state
/// throughout the widget tree lifecycle.
///
/// ---
///
/// ### Example:
///
/// ```dart
/// final store = ContextStore.of(context);
/// store.attach<MyData>(myData);
/// final data = store.get<MyData>();
/// ```

class AssociatedContextStore {
  //
  //
  //

  /// The `BuildContext` associated with the data.
  final BuildContext context;

  /// Creates a `ContextStore` instance associated with the provided [context].
  const AssociatedContextStore(this.context);

  /// Attaches data of type [T] to [context] with an optional [key]. If no key
  /// is provided, the type [T] is used as the key.
  ///
  /// Optionally, an [onDetach] callback can be provided, which is called when
  /// the data is detached from the store.
  T attach<T>(
    T data, {
    dynamic key,
    void Function(T data)? onDetach,
  }) {
    return ContextStore.instance.attach(
      context,
      data,
      key: key,
      onDetach: onDetach,
    );
  }

  /// Retrieves data of type [T] associated with the [context]. If no key is
  /// provided, the type [T] is used as the key.
  ///
  /// Returns the data if it exists, otherwise `null`.
  T? retrieve<T>({
    dynamic key,
  }) {
    return ContextStore.instance.retrieve<T>(
      context,
      key: key,
    );
  }

  /// Detaches and removes data of type [T] associated with [context]. If no key
  /// is provided, the type [T] is used as the key.
  ///
  /// Returns the removed data if or `null` if it didn't exist.
  ContextStoreData<T>? detach<T>({
    dynamic key,
  }) {
    return ContextStore.instance.detach<T>(
      context,
      key: key,
    );
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ContextStore {
  //
  //
  //

  bool verbose = false;
  Duration contextCheckDelay = const Duration(seconds: 1);

  //
  //
  //

  static final instance = ContextStore._();
  ContextStore._();

  //
  //
  //

  /// Creates a `ContextStore` instance associated with the provided [context].
  static AssociatedContextStore of(BuildContext context) => AssociatedContextStore(context);

  //
  //
  //

  final _store = ContextStoreMap<dynamic>();
  ContextStoreMap<dynamic> get store => ContextStoreMap.of(_store);

  //
  //
  //

  T attach<T>(
    BuildContext context,
    T data, {
    dynamic key,
    void Function(T data)? onDetach,
  }) {
    final keyOrType = key ?? T;

    // Ensure the context entry exists in the map and check if it existed.
    final contextDataMap = _store[context] ??= HashMap();
    final didContextMapExist = contextDataMap.isNotEmpty;

    // Check if the data for the given key is already present.
    if (contextDataMap.containsKey(keyOrType)) {
      _log(
        'Data for key hask ${_keyHash(context, keyOrType)} is already attached.',
      );
    } else {
      // Schedule a context check if it's not already being checked.
      if (!didContextMapExist) {
        // Store the data in the map.
        _store[context]![keyOrType] = (
          data: data,
          onDetach: onDetach != null ? (e) => onDetach(e as T) : null,
        );
        _scheduleContextCheck(context);
        _log(
          'Attached context data associated with hash ${_keyHash(context, keyOrType)}',
        );
        _log(
          'Context data map length: ${contextDataMap.length}',
        );
        _log(
          'Store map length: ${_store.length}',
        );
      }
    }

    return data;
  }

  //
  //
  //

  T? retrieve<T>(
    BuildContext context, {
    dynamic key,
  }) {
    final keyOrType = key ?? T;
    return _store[context]?[keyOrType]?.data as T?;
  }

  //
  //
  //

  void detachAll() {
    for (var context in _store.keys.toList()) {
      final contextDataMap = _store[context];
      if (contextDataMap != null) {
        for (var key in contextDataMap.keys.toList()) {
          _detach<dynamic>(context, key: key);
        }
      }
    }
  }

  //
  //
  //

  ContextStoreData<T>? detach<T>(
    BuildContext context, {
    dynamic key,
  }) {
    return _detach<T>(context, key: key);
  }

  //
  //
  //

  ContextStoreData<T>? _detach<T>(
    BuildContext context, {
    dynamic key,
  }) {
    final keyOrType = key ?? T;

    // Try and remove associated data then check if it got removed.
    final contextDataMap = _store[context];
    final storeData = contextDataMap?.remove(keyOrType) as ContextStoreData<T>?;
    final didRemove = storeData != null;

    if (!didRemove) return null;

    // Clean up entire context if no data.
    if (contextDataMap?.isEmpty ?? true) {
      _store.remove(context);
    }

    // Trigger the onDetach listener if it exists.
    storeData.onDetach?.call(storeData.data);
    _log(
      'Detached context data associated with ${_keyHash(context, keyOrType)}',
    );
    _log(
      'Context data map length: ${contextDataMap!.length}',
    );
    _log(
      'Store map length: ${_store.length}',
    );

    // Return the data that was removed.
    return storeData;
  }

  //
  //
  //

  ContextMap<dynamic>? clearForContext(BuildContext context) {
    return _store.remove(context);
  }

  //
  //
  //

  int _keyHash(BuildContext context, dynamic key) {
    return context.hashCode ^ key.hashCode;
  }

  //
  //
  //

  void _scheduleContextCheck(BuildContext context) {
    _widgetsBinding ??= WidgetsBinding.instance;
    _widgetsBinding!.addPostFrameCallback((_) {
      _log('Post frame!');
      final contextDataMap = _store[context];
      if (contextDataMap == null) return;
      if (!context.mounted) {
        for (final key in List.of(contextDataMap.keys)) {
          _log('Detaching $key from context ${context.hashCode}');
          detach<dynamic>(context, key: key);
        }
      } else {
        // If the context is still mounted, schedule another check after
        // autoDetachDelay.
        Future.delayed(contextCheckDelay, () {
          _log('Scheduling another context check...');
          // ignore: use_build_context_synchronously
          _scheduleContextCheck(context);
        });
      }
    });
  }

  WidgetsBinding? _widgetsBinding;

  //
  //
  //

  void _log(String message) {
    if (verbose) {
      if (kDebugMode) {
        print('[ContextStore] $message');
      }
    }
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef ContextStoreData<T> = ({T data, void Function(T data)? onDetach});
typedef ContextStoreMap<T> = HashMap<BuildContext, HashMap<dynamic, ContextStoreData<T>>>;
typedef ContextMap<T> = HashMap<dynamic, ContextStoreData<T>>;
