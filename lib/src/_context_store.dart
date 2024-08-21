//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// Dart/Flutter (DF) Packages by DevCetra.com & contributors. Use of this
// source code is governed by an an MIT-style license that can be found in the
// LICENSE file located in this project's root directory.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:collection';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/widgets.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class ContextStore {
  //
  //
  //

  bool verbose = false;

  //
  //
  //

  static final instance = ContextStore._();
  ContextStore._();

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

    // Ensure the context entry exists in the map.
    final contextDataMap = _store[context] ??= {};

    // Ensure the context entry exists in the map and check if it existed.
    final didContextMapExist = contextDataMap.isNotEmpty;

    // Check if the data for the given key is already present.
    if (contextDataMap.containsKey(keyOrType)) {
      if (verbose) {
        if (kDebugMode) {
          print(
            '[ContextStore] Data for key hask ${_keyHash(context, keyOrType)} is already attached.',
          );
        }
      }
    } else {
      // Schedule a context check if it's not already being checked.
      if (!didContextMapExist) {
        // Store the data in the map.
        _store[context]![keyOrType] = (
          data: data,
          onDetach: onDetach != null ? (e) => onDetach(e as T) : null,
        );

        _scheduleContextCheck(context);

        if (verbose) {
          if (kDebugMode) {
            print(
              '[ContextStore] Attached context data associated with hash ${_keyHash(context, keyOrType)}',
            );
            print(
              '[ContextStore] Context data map length: ${contextDataMap.length}',
            );
            print(
              '[ContextStore] Store map length: ${_store.length}',
            );
          }
        }
      }
    }

    return data;
  }

  //
  //
  //

  T? get<T>(
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

    if (verbose) {
      if (kDebugMode) {
        print(
          '[ContextStore] Detached context data associated with ${_keyHash(context, keyOrType)}',
        );
        print(
          '[ContextStore] Context data map length: ${contextDataMap!.length}',
        );
        print(
          '[ContextStore] Store map length: ${_store.length}',
        );
      }
    }

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_store.containsKey(context)) {
        if (!_isContextValid(context)) {
          final contextDataMap = _store[context];
          if (contextDataMap != null) {
            for (final key in List.of(contextDataMap.keys)) {
              detach<dynamic>(context, key: key);
            }
          }
        } else {
          _scheduleContextCheck(context);
        }
      }
    });
  }

  //
  //
  //

  bool _isContextValid(BuildContext context) {
    final element = context as Element;
    return element.mounted;
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

typedef ContextStoreData<T> = ({T data, void Function(T data)? onDetach});
typedef ContextStoreMap<T>
    = HashMap<BuildContext, Map<dynamic, ContextStoreData<T>>>;
typedef ContextMap<T> = Map<dynamic, ContextStoreData<T>>;
