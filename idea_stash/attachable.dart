// import 'package:flutter/widgets.dart';

// mixin AttachableMixin<E extends Element> on Widget {
//   @override
//   E createElement() {
//     if (this is StatelessWidget) {
//       return _StatelessAttachableElement(this as StatelessWidget) as E;
//     } else if (this is StatefulWidget) {
//       return _StatefulAttachableElement(this as StatefulWidget) as E;
//     } else {
//       throw UnsupportedError(
//           'AttachableMixin can only be used with StatelessWidget or StatefulWidget');
//     }
//   }

//   void attach<T>(BuildContext context, T object, void Function(T) onDetach) {
//     (context as _AttachableElement).addUnmountListener(() => onDetach(object));
//   }
// }

// abstract class _AttachableElement extends Element {
//   _AttachableElement(Widget widget) : super(widget);

//   final _callbacks = <VoidCallback>{};

//   void addUnmountListener(VoidCallback callback) => _callbacks.add(callback);

//   @override
//   void unmount() {
//     for (final callback in _callbacks) {
//       callback();
//     }
//     _callbacks.clear();
//     super.unmount();
//   }
// }

// class _StatelessAttachableElement extends StatelessElement with _AttachableElementMixin {
//   _StatelessAttachableElement(StatelessWidget widget) : super(widget);
// }

// class _StatefulAttachableElement extends StatefulElement with _AttachableElementMixin {
//   _StatefulAttachableElement(StatefulWidget widget) : super(widget);
// }

// mixin _AttachableElementMixin on Element {
//   final _callbacks = <VoidCallback>{};

//   void addUnmountListener(VoidCallback callback) => _callbacks.add(callback);

//   @override
//   void unmount() {
//     for (final callback in _callbacks) {
//       callback();
//     }
//     _callbacks.clear();
//     super.unmount();
//   }

//   bool _isBuilding = false;

//   @override
//   void performRebuild() {
//     _isBuilding = true;
//     super.performRebuild();
//     _isBuilding = false;
//   }

//   @override
//   bool get debugDoingBuild => _isBuilding;
// }
