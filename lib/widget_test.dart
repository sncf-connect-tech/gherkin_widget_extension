import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin/gherkin.dart';
import 'test_setup.dart';

void testWidgetsGherkin(String description, {required String featuresPath, required List<StepDefinitionGeneric<World>> steps, String? featureDefaultLanguage, required String featuresDirectoryPath}) {
  testWidgets(description, (WidgetTester tester) async {
    await tester.runAsync(() async {
      await runTest(featuresPath, finder : find, tester: tester,steps: steps, featureDefaultLanguage: featureDefaultLanguage, featuresDirectoryPath: featuresDirectoryPath);
    });
  }, tags: 'testWidget');
}
