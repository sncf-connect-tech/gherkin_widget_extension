<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A BDD-oriented widget test runner using [Cucumber](https://cucumber.io/docs/guides/overview/).
Use all the power and flexibility of the [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) package with 
[flutter test widget](https://docs.flutter.dev/cookbook/testing/widget/introduction).

Write your own steps using [gherkin syntax](https://cucumber.io/docs/gherkin/reference/) in `.feature` files, 
then create associated [step definitions](https://cucumber.io/docs/guides/overview/#what-is-gherkin),
set up the configuration and you are ready to describe actions and assertions on widgets of your application.

***

## -- Features

* Run your tests written with gherkin within a widget test context,
* Expose a `WidgetCucumberWorld` designed for widget tests with its buckets to store and share data through steps,
* ✨ Accessibility-friendly : search widget by semantic labels **AND** check its full semantic,
* Provide a Json loader to help building widget using Json data,
* Screenshot and widget tree dumped in a file on test failure,
* [flutter_gherkin reporters](https://pub.dev/packages/flutter_gherkin#reporting) adapted for widget tests,

## -- Getting started

> 📝 **Note:** [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) provides Gherkin parser and test runner for 
> both Dart tests and Flutter integration test, this plugin use **ONLY** the Dart test runner.

Knowledge on Gherkin syntax and Cucumber framework helps, documentation available here: https://cucumber.io/docs/gherkin/.

This README is based on some [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) README examples.

### 🥒 Add gherkin dependency
In the `pubspec.yaml`, add the [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) library to enable Gherkin parsing :
```yaml
gherkin: ^2.0.8
```
Then run `pub get` to download required dependencies.

### ✏️ Write a scenario
In the `test` folder, create a `features` folder. If there is no `test` folder, then create it.
In the `features` folder, create a `feature` file such as `counter.feature` and write your first scenario :
```gherkin
Feature: Counter
  The counter should be incremented when the button is pressed.

  Scenario: Counter increases when the button is pressed
    Given I launch the counter application
    When I tap the "increment" button 10 times
    Then I expect the "counter" to be "10"
```
Next step: implementation of step definitions.

### 🔗 Declare step definitions

Step definitions are like links between the gherkin sentence and the code that interacts with the widget.

In the `test` folder, create a `step_definitions` folder.
In the `features` folder, create a `steps.dart` file and start implementing step definitions :
```dart
import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/gherkin_widget_extension.dart';

StepDefinitionGeneric<WidgetCucumberWorld> givenAFreshApp() {
  return given<WidgetCucumberWorld>(
      'I launch the counter application', (context) async {
        // ...
  });
}
```

<!-- voir comment parler de ça :
#### Role des steps définitions
set le contexte du test, stockage dans bucket
pump widget avec les données du contexte
fait des actions sur le widget
fait des vérifications--> 

> #### 💡 _Advice_
> For better understanding, one of good practices advises to split step definitions files according gherkin keywords
> (all Given step definitions within the same file `given_steps.dart`, all When step definitions within the same file
> `when_steps.dart`, etc...). Organizing those files into folder representing the feature is a plus.

### ⚙️ Add some configuration
The [flutter_gherkin](https://pub.dev/packages/flutter_gherkin) offers a wide list of customizable properties
available [here](https://pub.dev/packages/flutter_gherkin#configuration).

🚧 _More details soon..._

### 🧪 Set up the test runner

Create a new file `widget_test_runner.dart` in `test` folder and call the test runner method:
```dart
import 'package:gherkin_widget_extension/widget_test.dart';
import 'test_setup.dart';

void main() {
  testWidgetsGherkin('widget tests',
      testConfiguration: TestWidgetsConfiguration(featurePath: 'FEATURES_FOLDER_PATH/**/**.feature'));
}
```

### 🪄 Run your tests

Open a terminal and execute the file you created before:
```shell
flutter test test/widget_test_runner.dart
```

🚧 _More details soon..._

## -- Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

### 🪣 `WidgetCucumberWorld` and buckets
🚧 _More details soon..._

### 👁️ Don't forget the accessibility
🚧 _More details soon..._

### 🔄 Json loader
🚧 _More details soon..._

### 📸 Screenshot and widget tree rendering
🚧 _More details soon..._

### 📋 Widget test reporters
🚧 _More details soon..._

## -- Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
