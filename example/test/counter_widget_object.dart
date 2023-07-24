import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_widget_extension/gherkin_widget_extension.dart';

class CounterWidgetObject implements TestWidgets {
  @override
  Future<void> pumpItUp() async {
    var widgetToPump = const MaterialTestWidget(
      child: MyApp(),
    );
    await pumpWidget(widgetToPump);
  }

  Future<void> tapTheButton(String key, int count) async {
    var button = find.widgetWithSemanticLabel(FloatingActionButton, key);
    expect(button, findsOneWidget);
    for (var i = 0; i < count; i++) {
      await tapAndPump(button);
    }
  }

  Future<void> checkDisplayedNumber(String count) async =>
      expect(find.widgetWithSemanticLabel(Text, count), findsOneWidget);
}
