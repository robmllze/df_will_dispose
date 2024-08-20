# DF WillDispose

<a href="https://www.buymeacoffee.com/robmllze" target="_blank"><img align="right" src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

Dart & Flutter Packages by DevCetra.com & contributors.

[![Pub Package](https://img.shields.io/pub/v/df_will_dispose.svg)](https://pub.dev/packages/df_will_dispose)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/robmllze/df_will_dispose/main/LICENSE)

---

## Summary

Theis package offers a lightweight approach to managing resource disposal in Flutter, providing an alternative to hooks. It's designed to simplify your code by marking resources for disposal upon definition. Additionally, if you prefer to avoid adding extra dependencies, the mixins used in this package are so short and simple that you can easily copy them directly into your project. The package is under an open-use license, so you can freely use and modify the mixins without needing to include the license file.

[View and copy the mixins here.](https://github.com/robmllze/df_will_dispose/blob/main/lib/src/will_dispose_mixin.dart).

## Quickstart

0. Use this package as a dependency by adding it to your `pubspec.yaml` file (see [here](https://pub.dev/packages/df_will_dispose/install)).
1. For stateful widgets, use `WillDisposeState` instead of `State`, or simply mix in `DisposeMixin` and `WillDisposeMixin` to your existing state classes.
2. For widgets that behave like stateless widgets but need to manage disposable resources, extend `WillDisposeWidget`.
3. Define your resources using the `willDispose` function, which will automatically dispose of the resource when the widget is disposed.
4. Use the `willDispose` function to define your resources. This ensures they are disposed of automatically when the widget is removed from the widget tree.
5. Any resource with a `dispose()` method can be managed. If a resource does not have a `dispose()` method, `NoDisposeMethodDebugError` will be thrown during disposal.
6. Common disposable resources include `ChangeNotifier`, `ValueNotifier`, `FocusNode`, most Flutter controllers and [Pods](https://pub.dev/packages/df_pod).
7. You can also create your own classes that implement `DisposeMixin`, enabling them to work seamlessly with `WillDisposeMixin`.

### Example 1 - StatefulWidget:

```dart
class _Example1State extends WillDisposeState<Example1> {
  // Define resources and schedule them to be disposed when this widget gets
  // removed from the widget tree.
  late final _textController = willDispose(TextEditingController());
  late final _valueNotifier = willDispose(ValueNotifier('Initial Value'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WillDispose Example')),
      body: Column(
        children: [
          TextField(controller: _textController),
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

```dart
class Example2 extends WillDisposeWidget {
  const Example2({super.key});

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

### Chief Maintainer:

📧 Email _Robert Mollentze_ at robmllze@gmail.com

### Dontations:

If you're enjoying this package and find it valuable, consider showing your appreciation with a small donation. Every bit helps in supporting future development. You can donate here:

https://www.buymeacoffee.com/robmllze

---

## License

This project is released under an Open Use License. See [LICENSE](https://raw.githubusercontent.com/robmllze/df_will_dispose/main/LICENSE) for more information.
