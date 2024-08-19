# DF Will Dispose

<a href="https://www.buymeacoffee.com/robmllze" target="_blank"><img align="right" src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

Dart & Flutter Packages by DevCetra.com & contributors.

[![Pub Package](https://img.shields.io/pub/v/df_will_dispose.svg)](https://pub.dev/packages/df_will_dispose)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://raw.githubusercontent.com/robmllze/df_will_dispose/main/LICENSE)

---

## Summary

A package to mark resources for disposal upon definition, simplifying your code. For a full feature set, please refer to the [API reference](https://pub.dev/documentation/df_will_dispose/).

## Quickstart

1. Use `WillDisposeState` instead of `State` for your widgets, or simply mix in `DisposeMixin` and `WillDisposeMixin` to your existing state classes.
2. Define your resources using the `willDispose` function, which will automatically dispose of the resource when the widget is disposed.
3. Only `ChangeNotifier` and `DisposeMixin` resources are supported at the moment.
4. Common `ChangeNotifier` resources include `ValueNotifier`, `FocusNode`, most all Flutter controllers and [Pods](https://pub.dev/packages/df_pod).
5. You can also create your own classes that implement `DisposeMixin`, enabling them to work seamlessly with `WillDisposeMixin`.

### Example:

```dart
// Option 1: WillDisposeState<MyWidget>.
// Option 2: State<MyWidget> with DisposeMixin, WillDisposeMixin.
class _MyWidgetState extends WillDisposeState<MyWidget> {
  // Define and mark resources for disposal on the same line.
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

## Installation

Use this package as a dependency by adding it to your `pubspec.yaml` file (see [here](https://pub.dev/packages/df_will_dispose/install)).

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

This project is released under the MIT License. See [LICENSE](https://raw.githubusercontent.com/robmllze/df_will_dispose/main/LICENSE) for more information.
