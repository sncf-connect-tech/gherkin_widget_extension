import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';

class CucumberWorld extends World {
  final WidgetTester tester;
  final SemanticsHandle semantics;
  late String scenarioName;
  late String json;
  late Bucket bucket;
  File? dumpFile;
  File? screenshot;

  T readBucket<T>() {
    return bucket as T;
  }

  String getScenarioAsFileName() {
    return scenarioName.replaceAll(" ", "_").replaceAll(":_", "").toLowerCase();
  }

  CucumberWorld(this.tester, this.semantics);
}

abstract class Bucket {}
