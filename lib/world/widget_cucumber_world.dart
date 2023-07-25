import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

class WidgetCucumberWorld extends World {
  final WidgetTester tester;
  final SemanticsHandle semantics;
  late String scenarioName;
  List<String> reportFilesPath = List.empty(growable: true);
  late String json;
  late Bucket bucket;
  late String reportFolderPath;
  late String currentStep;
  String? dumpFileContent;
  File? screenshot;

  T readBucket<T>() {
    return bucket as T;
  }

  String getScenarioAsFileName() {
    return scenarioName.replaceAll(' ', '_').replaceAll(':_', '').toLowerCase();
  }

  WidgetCucumberWorld(this.tester, this.semantics);
}

abstract class Bucket {}
