import 'dart:developer';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/test_setup.dart';
import 'package:gherkin_widget_extension/utils/string_utils.dart';
import 'package:gherkin_widget_extension/utils/widget_actions.dart';
import 'package:gherkin_widget_extension/utils/widget_renderer.dart';

class WidgetHooks implements Hook {

  final String dumpFolderPath;

  WidgetHooks(this.dumpFolderPath);

  @override
  int get priority => 1;

  @override
  Future<void> onBeforeRun(TestConfiguration config) async {
    if (!(await Directory(dumpFolderPath).exists())) {
      await Directory(dumpFolderPath).create();
    }
  }

  @override
  Future<void> onAfterScenarioWorldCreated(World world, String scenario, Iterable<Tag> tags) async {}

  @override
  Future<void> onBeforeScenario(TestConfiguration config, String scenario, Iterable<Tag> tags) async {
    currentWorld.scenarioName = scenario;
  }

  @override
  Future<void> onBeforeStep(World world, String step) async {}

  @override
  Future<void> onAfterStep(World world, String step, StepResult stepResult) async {
    if ([StepExecutionResult.fail, StepExecutionResult.error].contains(stepResult.result)) {
      var dumpFileName = _getDumpFilePath();
      currentWorld.dumpFile = File("$dumpFileName.txt");
      currentWorld.screenshot = File("$dumpFileName.png");
      await takeScreenshot();
      await dumpWidgetRender();
    }
  }

  @override
  Future<void> onAfterRun(TestConfiguration config) async {}

  String _getDumpFilePath() {
    var filePath = "${Directory.current.path}/$dumpFolderPath/${currentWorld.getScenarioAsFileName()}";
    return StringUtils.removeDiacritics(source: filePath);
  }

  @override
  Future<void> onAfterScenario(TestConfiguration config, String scenario, Iterable<Tag> tags, {bool passed = true}) async {
    try {
      currentWorld.semantics.dispose();
      await disposeWidget();
      currentWorld.dispose();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
