import 'package:gherkin_widget_extension/widget_test.dart';

import 'test_setup.dart';

void main() {
  testWidgetsGherkin('widget tests',
      testConfiguration: testWidgetsConfiguration(featurePath: 'test/features/*.feature'));
}
