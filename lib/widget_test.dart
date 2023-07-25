import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/world/widget_cucumber_world.dart';
import 'test_setup.dart';

void testWidgetsGherkin(String description, {required TestConfiguration testConfiguration, WidgetCucumberWorld? customWorld}) {
  testWidgets(description, (WidgetTester tester) async {
    await tester.runAsync(() async {
      await runTest(tester: tester, testConfiguration: testConfiguration, customWorld: customWorld);
    });
  }, tags: 'testWidget');
}
