import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:xml/xml.dart';

import '../test_setup.dart';
import 'package:path/path.dart' as p;

class XmlReporter extends Reporter {
  final List<TestSuite> _testSuites = List.empty(growable: true);
  int _testSuiteIndex = 0;
  int _testCaseIndex = 0;

  String outputFilename;
  String dirRoot;

  XmlReporter(
      {this.outputFilename = 'junit-report.xml', required this.dirRoot});

  @override
  Future<void> onFeatureStarted(StartedMessage message) async {
    _testSuites.add(TestSuite(message.name, message.context.filePath));
    _testCaseIndex = 0;
  }

  @override
  Future<void> onFeatureFinished(FinishedMessage message) async {
    _testSuiteIndex++;
  }

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    _testSuites[_testSuiteIndex].testCases.add(TestCase(message.name));
    _testSuites[_testSuiteIndex].tests++;
  }

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {
    if (!message.passed) {
      _testSuites[_testSuiteIndex].failures++;
    }
    _testSuites[_testSuiteIndex].testCases[_testCaseIndex].isPassed =
        message.passed;
    _testSuites[_testSuiteIndex].testCases[_testCaseIndex].time = DateTime.now()
        .difference(
            _testSuites[_testSuiteIndex].testCases[_testCaseIndex].timestamp)
        .inMilliseconds
        .toString();
    _testSuites[_testSuiteIndex].time = DateTime.now()
        .difference(_testSuites[_testSuiteIndex].timestamp)
        .inMilliseconds
        .toString();
    //TODO améliorer le calcul du chemin pour la CI
    _testSuites[_testSuiteIndex].testCases[_testCaseIndex].dumpFileContent =
        currentWorld.dumpFileContent;
    _testSuites[_testSuiteIndex].testCases[_testCaseIndex].screenshotPath =
        '$dirRoot/${p.relative(currentWorld.screenshot?.path.toString() ?? '')}';
    _testCaseIndex++;
  }

  @override
  Future<void> onStepStarted(StepStartedMessage message) async {}

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    final attachments = message.attachments.map((e) => e.data).toList();
    _testSuites[_testSuiteIndex].testCases[_testCaseIndex].stepResults.add(
        TestStep(
            name: message.name,
            stepResult: message.result,
            attachments: attachments));
  }

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async {
    _testSuites[_testSuiteIndex].errors++;
  }

  @override
  Future<void> message(String message, MessageLevel level) async {}

  /// Fonction appelée une fois toutes les exécutions de tests déroulées
  @override
  Future<void> dispose() async {
    await _generateXmlJunitReport();
  }

  Future<void> _generateXmlJunitReport() async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('testsuites', nest: () {
      for (var testSuite in _testSuites) {
        builder.element('testsuite', nest: () {
          builder.attribute('name', testSuite.name);
          builder.attribute('filename', testSuite.featureFile);
          builder.attribute('tests', testSuite.tests);
          builder.attribute('failures', testSuite.failures);
          builder.attribute('errors', testSuite.errors);
          builder.attribute('time', testSuite.time);
          builder.attribute('suite', testSuite.name);
          for (var testCase in testSuite.testCases) {
            builder.element('testcase', nest: () {
              builder.attribute('name', testCase.name);
              builder.attribute('time', testCase.time);
              var systemOut = testCase.stepResults
                  .map((step) =>
                      step.name + ('.' * 80) + step.stepResult.result.name)
                  .join('\n');
              builder.element('system-out', nest: () {
                builder.text(systemOut);
                if (!testCase.isPassed) {
                  builder.text('\n');
                  final screenshotPath = testCase.stepResults
                      .firstWhere((element) =>
                          element.stepResult.result ==
                          StepExecutionResult.error)
                      .attachments
                      .firstWhere((element) => element.endsWith('png'));
                  builder.text('[[ATTACHMENT|$screenshotPath]]');
                }
              });
              if (!testCase.isPassed) {
                var error = testCase.stepResults
                    .firstWhere((element) =>
                        element.stepResult.result != StepExecutionResult.pass)
                    .stepResult as ErroredStepResult;
                builder.element('failure', nest: () {
                  builder.attribute('message', error.exception);
                  builder.text('\n$systemOut\n\n'
                      '${error.exception}\n\n'
                      '${error.stackTrace}\n\n'
                      '${testCase.dumpFileContent ?? ''}');
                });
              }
            });
          }
        });
      }
    });
    final document = builder.buildDocument();
    await File(outputFilename).writeAsString(document.toString());
  }
}

class TestSuites {
  final String name;
  final List<TestSuite> testSuiteList = List.empty(growable: true);

  TestSuites(this.name);
}

class TestSuite {
  final String name;
  final String featureFile;
  final DateTime timestamp = DateTime.now();
  final List<TestCase> testCases = List.empty(growable: true);
  int tests = 0;
  int failures = 0;
  int errors = 0;
  String time = '0';

  TestSuite(this.name, this.featureFile);
}

class TestCase {
  final String name;
  final DateTime timestamp = DateTime.now();
  final List<TestStep> stepResults = List.empty(growable: true);
  bool isPassed = false;
  String time = '0';
  String? dumpFileContent;
  String? screenshotPath;

  TestCase(this.name);
}

class TestStep {
  final String name;
  final StepResult stepResult;
  final Iterable<String> attachments;

  TestStep({
    required this.name,
    required this.stepResult,
    required this.attachments,
  });
}
