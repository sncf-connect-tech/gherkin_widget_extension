import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/test_setup.dart';
import 'package:gherkin_widget_extension/utils/widget_actions.dart';
import 'package:gherkin_widget_extension/utils/widget_renderer.dart';

class WidgetHooks implements Hook {
  WidgetHooks({required this.dumpFolderPath});

  final String dumpFolderPath;

  @override
  int get priority => 1;

  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    if (await Directory(dumpFolderPath).exists()) {
      await Directory(dumpFolderPath).delete(recursive: true);
    }
    await Directory(dumpFolderPath).create();
  }

  @override
  Future<void> onAfterScenarioWorldCreated(
      World world, String scenario, Iterable<Tag> tags) async {}

  @override
  Future<void> onBeforeScenario(
      TestConfiguration config, String scenario, Iterable<Tag> tags) async {
    currentWorld.scenarioName = scenario;
    currentWorld.reportFolderPath = '${Directory.current.path}/$dumpFolderPath';
  }

  @override
  Future<void> onBeforeStep(World world, String step) async {
    currentWorld.currentStep = step;
  }

  @override
  Future<void> onAfterStep(
      World world, String step, StepResult stepResult) async {
    if ([StepExecutionResult.fail, StepExecutionResult.error]
        .contains(stepResult.result)) {
      await takeScreenshot(withWidgetTreeRender: true, prefix: 'FAILED');
      currentWorld.reportFilesPath
          .where((file) => file.contains('FAILED'))
          .forEach((failedFile) {
        currentWorld.attach(failedFile, 'txt', step);
      });
    }
  }

  @override
  Future<void> onAfterRun(TestConfiguration config) async {}

  @override
  Future<void> onAfterScenario(
      TestConfiguration config, String scenario, Iterable<Tag> tags,
      {bool passed = true}) async {
    try {
      currentWorld.semantics.dispose();
      await disposeWidget();
      currentWorld.dispose();
    } catch (e) {
      throwsAssertionError;
    }
  }
}
