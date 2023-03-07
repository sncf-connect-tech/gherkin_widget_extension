import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/gherkin_widget_extension.dart';
import 'package:gherkin_widget_extension/utils/widget_renderer.dart';

import '../buckets/example_bucket.dart';

StepDefinitionGeneric<WidgetCucumberWorld> givenAFreshApp() {
  return given<WidgetCucumberWorld>('I launch the counter application',
      (context) async {
    currentWorld.bucket = ExampleBucket();
    var widgetToPump = const MaterialTestWidget(
      child: MyApp(),
    );
    pumpWidget(widgetToPump);
  });
}

StepDefinitionGeneric<WidgetCucumberWorld> whenButtonTapped() {
  return when2<String, int, WidgetCucumberWorld>(
      'I tap the {string} button {int} times', (key, count, context) async {
    currentWorld.readBucket<ExampleBucket>().nbActions = count;
    var button = find.widgetWithSemanticLabel(FloatingActionButton, key);
    expect(button, findsOneWidget);
    for (var i = 0; i < count; i++) {
      await tapAndPump(button);
    }
  });
}

StepDefinitionGeneric<WidgetCucumberWorld> thenCounterIsUpdated() {
  return given2<String, String, WidgetCucumberWorld>(
      'I expect the {string} to be {string}', (key, count, context) async {
    var button = find.widgetWithSemanticLabel(Text, count);
    expect(button, findsOneWidget);
  });
}
