import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/reporters/widget_stdout_reporter.dart';
import 'package:gherkin_widget_extension/reporters/widget_test_run_summary_reporter.dart';
import 'package:gherkin_widget_extension/reporters/xml_reporter.dart';

import 'package:gherkin_widget_extension/world/widget_hooks.dart';
import 'package:glob/glob.dart';

import 'step_definitions/steps.dart';

TestConfiguration testWidgetsConfiguration({
  String featurePath = '*.feature',
}) {
  return TestConfiguration(features: [
    Glob(featurePath)
  ],
      hooks: [
    WidgetHooks(dumpFolderPath: 'widget_tests_report_folder')
  ], reporters: [
    WidgetStdoutReporter(),
    WidgetTestRunSummaryReporter(),
    XmlReporter(dirRoot: Directory.current.path),
  ],
      stepDefinitions: [
    givenAFreshApp(),
    whenButtonTapped(),
    thenCounterIsUpdated()
  ],
      defaultTimeout: const Duration(milliseconds: 60000 * 10));
}
