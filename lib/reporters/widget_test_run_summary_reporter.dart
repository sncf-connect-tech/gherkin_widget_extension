import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/reporters/widget_stdout_reporter.dart';

class WidgetTestRunSummaryReporter extends WidgetStdoutReporter {
  final _timer = Stopwatch();
  final List<StepFinishedMessage> _ranSteps = <StepFinishedMessage>[];
  final List<ScenarioFinishedMessage> _ranScenarios = <ScenarioFinishedMessage>[];

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    // on n'implémente rien pour pas appeler CustomStdoutReporter.onScenarioStarted() en double
  }

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {
    _ranScenarios.add(message);
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    _ranSteps.add(message);
  }

  @override
  Future<void> message(String message, MessageLevel level) async {}

  @override
  Future<void> onTestRunStarted() async {
    _timer.start();
  }

  @override
  Future<void> onTestRunFinished() async {
    _timer.stop();
    logger.i(_getRanScenariosSummary());
    logger.i(_getRanStepsSummary());
    logger.i('${Duration(milliseconds: _timer.elapsedMilliseconds)}\n');
  }

  @override
  Future<void> dispose() async {
    if (_timer.isRunning) {
      _timer.stop();
    }
  }

  String _getRanScenariosSummary() {
    return "\n${_ranScenarios.length} scenario${_ranScenarios.length > 1 ? "s" : ""} (${_collectScenarioSummary(_ranScenarios)})";
  }

  String _getRanStepsSummary() {
    return "${_ranSteps.length} step${_ranSteps.length > 1 ? "s" : ""} (${_collectStepSummary(_ranSteps)})";
  }

  String _collectScenarioSummary(Iterable<ScenarioFinishedMessage> scenarios) {
    final summaries = <String>[];
    if (scenarios.any((s) => s.passed)) {
      summaries.add(passColor("${scenarios.where((s) => s.passed).length} passed"));
    }

    if (scenarios.any((s) => !s.passed)) {
      summaries.add(failColor("${scenarios.where((s) => !s.passed).length} failed"));
    }

    return summaries.join(', ');
  }

  String _collectStepSummary(Iterable<StepFinishedMessage> steps) {
    final summaries = <String>[];
    final passed = steps.where((s) => s.result.result == StepExecutionResult.pass);
    final skipped = steps.where((s) => s.result.result == StepExecutionResult.skipped);
    final failed = steps.where((s) =>
        s.result.result == StepExecutionResult.error ||
        s.result.result == StepExecutionResult.fail ||
        s.result.result == StepExecutionResult.timeout);
    if (passed.isNotEmpty) {
      summaries.add(passColor("${passed.length} passed"));
    }

    if (skipped.isNotEmpty) {
      summaries.add(warnColor("${skipped.length} skipped"));
    }

    if (failed.isNotEmpty) {
      summaries.add(failColor("${failed.length} failed"));
    }

    return summaries.join(', ');
  }
}
