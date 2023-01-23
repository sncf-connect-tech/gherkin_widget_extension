import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:glob/glob.dart';

import 'reporters/custom_stdout_reporter.dart';
import 'reporters/custom_test_run_summary_reporter.dart';
import 'reporters/xml_reporter.dart';
import 'world/cucumber_world.dart';
import 'package:logger/logger.dart';

import 'world/widget_hooks.dart';

late CucumberWorld currentWorld;

const defaultConnexionTimeoutInMs = 60000;

final testId = Platform.environment['TEST_ID'];
final dumpFolderPath = Platform.environment['DUMP_FOLDER'] ?? 'widget_tests_dumps';
final Logger logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

var defaultReporters = [CustomStdoutReporter(), CustomTestRunSummaryReporter()];

TestConfiguration testWidgetsConfiguration(
  Iterable<StepDefinitionGeneric<World>> steps, {
  String featurePath = '*.feature',
  required String featuresDirectoryPath,
  required String dirRoot,
  String? featureDefaultLanguage,
  TestConfiguration? testConfiguration,
  Iterable<Reporter>? reporters
}) {
  var tags = "@widget";
  if (testId != null) {
    tags += " and ($testId)";
  }
  if (kDebugMode) {
    log('Tags : $tags');
  }

  return (testConfiguration ?? TestConfiguration())
    ..features = [Glob(featurePath)]
    ..featureFileMatcher = IoFeatureFileAccessor(
        workingDirectory: Directory('${Directory.current.parent.path}/$featuresDirectoryPath'))
    ..featureFileReader = IoFeatureFileAccessor(
        workingDirectory: Directory('${Directory.current.parent.path}/$featuresDirectoryPath'))
    ..featureDefaultLanguage = featureDefaultLanguage ?? "fr"
    ..tagExpression = tags
    ..hooks = [WidgetHooks()]
    ..order = ExecutionOrder.sequential
    ..stopAfterTestFailed = false
    ..reporters = [...defaultReporters, ...?reporters, XmlReporter(dirRoot: dirRoot)]
    ..stepDefinitions = steps
    ..defaultTimeout = const Duration(milliseconds: defaultConnexionTimeoutInMs * 10);
}

Future<void> runTest(String testFileGlob,
    {required CommonFinders finder, required WidgetTester tester, featureDefaultLanguage, required String featuresDirectoryPath, required String dirRoot, TestConfiguration? testConfiguration, required List<StepDefinitionGeneric<World>> steps}) async {
  final config = testWidgetsConfiguration(steps, featurePath: testFileGlob, featureDefaultLanguage: featureDefaultLanguage, featuresDirectoryPath: featuresDirectoryPath, dirRoot: dirRoot, testConfiguration: testConfiguration)..createWorld =
      (TestConfiguration config) => Future.value(currentWorld = CucumberWorld(tester, tester.ensureSemantics()));
  return GherkinRunner().execute(config);
}
