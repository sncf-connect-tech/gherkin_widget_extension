import 'package:gherkin/gherkin.dart';

extension TestConfigurationHelper on TestConfiguration {
  TestConfiguration copyWith({
    Iterable<Pattern>? features,
    String? featureDefaultLanguage,
    String? tagExpression,
    Duration? defaultTimeout,
    ExecutionOrder? order,
    Iterable<StepDefinitionGeneric>? stepDefinitions,
    Iterable<CustomParameter<dynamic>>? customStepParameterDefinitions,
    Iterable<Hook>? hooks,
    Iterable<Reporter>? reporters,
    CreateWorld? createWorld,
    FeatureFileMatcher? featureFileMatcher,
    FeatureFileReader? featureFileReader,
    bool? stopAfterTestFailed,
    int? stepMaxRetries,
    Duration? retryDelay,
  }) {
    return TestConfiguration(
      features: features ?? this.features,
      featureDefaultLanguage:
          featureDefaultLanguage ?? this.featureDefaultLanguage,
      tagExpression: tagExpression ?? this.tagExpression,
      defaultTimeout: defaultTimeout ?? this.defaultTimeout,
      order: order ?? this.order,
      stepDefinitions: stepDefinitions ?? this.stepDefinitions,
      customStepParameterDefinitions:
          customStepParameterDefinitions ?? this.customStepParameterDefinitions,
      hooks: hooks ?? this.hooks,
      reporters: reporters ?? this.reporters,
      createWorld: createWorld ?? this.createWorld,
      featureFileMatcher: featureFileMatcher ?? this.featureFileMatcher,
      featureFileReader: featureFileReader ?? this.featureFileReader,
      stopAfterTestFailed: stopAfterTestFailed ?? this.stopAfterTestFailed,
      stepMaxRetries: stepMaxRetries ?? this.stepMaxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
    );
  }
}
