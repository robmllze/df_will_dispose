import 'package:df_will_dispose/df_will_dispose.dart';
import 'package:flutter/material.dart';

import 'pages/_index.g.dart';
import 'test_animation.dart';

void main() {
  ContextStore.instance.verbose = true;
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final pageController = context.willDispose(PageController());
    const pages = [
      Page1(),
      Page2(),
    ];
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const TestAnimation(),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {});
                },
                children: pages,
              ),
            ),
            OutlinedButton(
              onPressed: () {
                final nextPageIndex =
                    ((pageController.page?.toInt() ?? 0) + 1) % pages.length;
                pageController.jumpToPage(nextPageIndex);
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Next Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
