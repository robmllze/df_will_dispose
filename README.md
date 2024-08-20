# DF - Will Dispose

<a href="https://www.buymeacoffee.com/robmllze" target="_blank"><img align="right" src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

Dart & Flutter Packages by DevCetra.com & contributors.

[![Pub Package](https://img.shields.io/pub/v/df_will_dispose.svg)](https://pub.dev/packages/df_will_dispose)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/robmllze/df_will_dispose/main/LICENSE)

---

## Summary

This package offers a lightweight approach to managing resource disposal in Flutter, providing an alternative to hooks. It's designed to simplify your code by marking resources for disposal upon definition. Additionally, if you prefer to avoid adding extra dependencies, the mixins used in this package are so short and simple that you can easily copy them directly into your project.

- [View and copy the mixins here.](https://github.com/robmllze/df_will_dispose/blob/main/lib/src/will_dispose_mixin.dart)
- [Or check out the even simpler vesion here.](https://github.com/robmllze/df_will_dispose/blob/main/copy_me/simple_will_dispose_mixin.dart)

## Quickstart

1. Use this package as a dependency by adding it to your `pubspec.yaml` file (see [here](https://pub.dev/packages/df_will_dispose/install)).
2. For stateful widgets, use `WillDisposeState` instead of `State`, or simply mix in `DisposeMixin` and `WillDisposeMixin` to your existing state classes.
3. For widgets that behave like stateless widgets but need to manage disposable resources, extend `WillDisposeWidget`.
4. Define your resources using the `willDispose` function, which will automatically dispose of the resource when the widget is disposed.
5. Use the `willDispose` function to define your resources. This ensures they are disposed of automatically when the widget is removed from the widget tree.
6. Any resource with a `dispose()` method can be managed. If a resource does not have a `dispose()` method, `NoDisposeMethodDebugError` will be thrown during disposal.
7. Common disposable resources include `ChangeNotifier`, `ValueNotifier`, `FocusNode`, most Flutter controllers and [Pods](https://pub.dev/packages/df_pod).
8. You can also create your own classes that implement `DisposeMixin`, enabling them to work seamlessly with `WillDisposeMixin`.

### Example 1 - StatefulWidget:

`DisposeMixin` and `WillDisposeMixin` can be used with a `StatefulWidget` to manage disposable resources effectively. You can also simplify this by using `WillDisposeState` instead of `State`. By utilizing these mixins, you can easily mark resources like `TextEditingController` and `ValueNotifier` for disposal when the widget is removed from the widget tree. This approach ensures that all resources are properly disposed of without requiring manual cleanup, simplifying resource management in your stateful widgets.

```dart
class _Example1State extends State<Example1> with DisposeMixin, WillDisposeMixin {
  // Define resources and schedule them to be disposed when this widget gets
  // removed from the widget tree.
  late final _textEditingController = willDispose(TextEditingController());
  late final _valueNotifier = willDispose(ValueNotifier('Initial Value'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WillDispose Example')),
      body: Column(
        children: [
          TextField(controller: _textEditingController),
          ValueListenableBuilder<String>(
            valueListenable: _valueNotifier,
            builder: (context, value, child) => Text('Value: $value'),
          ),
          ElevatedButton(
            onPressed: () {
              _valueNotifier.value = 'Updated Value';
            },
            child: const Text('Update Value'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Resources marked with `willDispose` will be disposed automatically here.
    super.dispose();
  }
}
```

### Example 2 - WillDisposeWidget:

`WillDisposeWidget` is a specialized widget that combines the simplicity of a `StatelessWidget` with the resource management capabilities of a `StatefulWidget`. It's designed to automatically manage and dispose of resources like `TextEditingController`, `FocusNode`, or other disposable objects when the widget is removed or rebuilt. Ideal for small, self-contained components, `WillDisposeWidget` typically won’t rebuild unless externally triggered, but when it does, it ensures all resources are properly disposed of and recreated, providing a seamless reset. While useful for managing disposable resources efficiently in small widgets, a traditional stateful approach might be better suited for more complex widgets requiring extensive state handling.

```dart
class Example2 extends WillDisposeWidget {
  const Example2({super.key});

  /// Override this method if you need to customize the disposal behavior.
  @override
  void onDispose(WillDispose willDispose) {
    print('${willDispose.resources.length} resources are about to be disposed!');
    willDispose.dispose();
  }

  @override
  Widget build(BuildContext context, WillDispose willDispose) {
    // Define resources and schedule them to be disposed when this widget gets
    // removed from the widget tree.
    final textController = willDispose(TextEditingController());
    final focusNode = willDispose(FocusNode());

    return Column(
      children: [
        TextField(
          controller: textController,
          focusNode: focusNode,
        ),
      ],
    );
  }
}
```

---

## Contributing and Discussions

This is an open-source project, and we warmly welcome contributions from everyone, regardless of experience level. Whether you're a seasoned developer or just starting out, contributing to this project is a fantastic way to learn, share your knowledge, and make a meaningful impact on the community.

### Ways you can contribute:

- **Buy me a coffee:** If you'd like to support the project financially, consider [buying me a coffee](https://www.buymeacoffee.com/robmllze). Your support helps cover the costs of development and keeps the project growing.
- **Share your ideas:** Every perspective matters, and your ideas can spark innovation.
- **Report bugs:** Help us identify and fix issues to make the project more robust.
- **Suggest improvements or new features:** Your ideas can help shape the future of the project.
- **Help clarify documentation:** Good documentation is key to accessibility. You can make it easier for others to get started by improving or expanding our documentation.
- **Write articles:** Share your knowledge by writing tutorials, guides, or blog posts about your experiences with the project. It's a great way to contribute and help others learn.

No matter how you choose to contribute, your involvement is greatly appreciated and valued!

---

### Special Thanks:

Special thanks to `u/Mulsivaas` and `u/groogoloog` on Reddit for their valuable feedback, which helped improve this package.

### Chief Maintainer:

📧 Email _Robert Mollentze_ at robmllze@gmail.com

### Dontations:

If you're enjoying this package and find it valuable, consider showing your appreciation with a small donation. Every bit helps in supporting future development. You can donate here:

https://www.buymeacoffee.com/robmllze

---

## License

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/df_bulk_replace/main/LICENSE) for more information.
