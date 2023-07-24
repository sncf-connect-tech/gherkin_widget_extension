import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/world/widget_cucumber_world.dart';
import 'package:logger/logger.dart';

late WidgetCucumberWorld currentWorld;
final Logger logger =
    Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

Future<void> runTest(
    {required WidgetTester tester,
    required TestConfiguration testConfiguration,
    WidgetCucumberWorld? customWord}) async {
  final config = testConfiguration
    ..createWorld = (TestConfiguration config) => Future.value(currentWorld =
        customWord ?? WidgetCucumberWorld(tester, tester.ensureSemantics()));
  return GherkinRunner().execute(config);
}
