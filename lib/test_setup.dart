import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/utils/test_configuration_helper.dart';
import 'package:gherkin_widget_extension/world/widget_cucumber_world.dart';
import 'package:logger/logger.dart';

late WidgetCucumberWorld currentWorld;
final Logger logger =
    Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

Future<void> runTest(
    {required WidgetTester tester,
    required TestConfiguration testConfiguration,
    WidgetCucumberWorld? customWorld}) async {
  final config = testConfiguration.copyWith(
      createWorld: (TestConfiguration config) => Future.value(currentWorld =
          customWorld ??
              WidgetCucumberWorld(tester, tester.ensureSemantics())));
  return GherkinRunner().execute(config);
}
