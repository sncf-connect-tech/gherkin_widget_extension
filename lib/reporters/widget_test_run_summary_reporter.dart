import 'package:gherkin/gherkin.dart';
import 'package:gherkin_widget_extension/reporters/widget_stdout_reporter.dart';

class WidgetTestRunSummaryReporter extends WidgetStdoutReporter {
  final _timer = Stopwatch();

  final List<StepMessage> _ranSteps = <StepMessage>[];
  final List<ScenarioMessage> _ranScenarios = <ScenarioMessage>[];

  @override
  ReportActionHandler<ScenarioMessage> get scenario => ReportActionHandler(
        onStarted: ([message]) async {},
        onFinished: ([message]) async {
          if (message == null) {
            logger.i(failColor('Cannot get scenario information'));
          } else {
            _ranScenarios.add(message);
          }
        },
      );

  @override
  ReportActionHandler<StepMessage> get step => ReportActionHandler(
        onStarted: ([message]) async {},
        onFinished: ([message]) async {
          if (message == null) {
            logger.i(failColor('Cannot get scenario information'));
          } else {
            _ranSteps.add(message);
          }
        },
      );

  @override
  ReportActionHandler<TestMessage> get test => ReportActionHandler(
        onStarted: ([message]) async => _timer.start(),
        onFinished: ([message]) async {
          _timer.stop();
          logger.i(_getRanScenariosSummary());
          logger.i(_getRanStepsSummary());
          logger.i('${Duration(milliseconds: _timer.elapsedMilliseconds)}\n');
        },
      );

  @override
  Future<void> dispose() async {
    if (_timer.isRunning) {
      _timer.stop();
    }
  }

  String _getRanScenariosSummary() {
    return '\n${_ranScenarios.length} scenario${_ranScenarios.length > 1 ? 's' : ''} (${_collectScenarioSummary(_ranScenarios)})';
  }

  String _getRanStepsSummary() {
    return '${_ranSteps.length} step${_ranSteps.length > 1 ? 's' : ''} (${_collectStepSummary(_ranSteps)})';
  }

  String _collectScenarioSummary(Iterable<ScenarioMessage> scenarios) {
    final summaries = <String>[];
    if (scenarios.any((s) => s.hasPassed)) {
      summaries.add(
          passColor("${scenarios.where((s) => s.hasPassed).length} passed"));
    }

    if (scenarios.any((s) => !s.hasPassed)) {
      summaries.add(
          failColor("${scenarios.where((s) => !s.hasPassed).length} failed"));
    }

    return summaries.join(', ');
  }

  String _collectStepSummary(Iterable<StepMessage> steps) {
    final summaries = <String>[];
    final passed =
        steps.where((s) => s.result?.result == StepExecutionResult.passed);
    final skipped =
        steps.where((s) => s.result?.result == StepExecutionResult.skipped);
    final failed = steps.where((s) =>
        s.result?.result == StepExecutionResult.error ||
        s.result?.result == StepExecutionResult.fail ||
        s.result?.result == StepExecutionResult.timeout);
    if (passed.isNotEmpty) {
      summaries.add(passColor('${passed.length} passed'));
    }

    if (skipped.isNotEmpty) {
      summaries.add(warnColor('${skipped.length} skipped'));
    }

    if (failed.isNotEmpty) {
      summaries.add(failColor('${failed.length} failed'));
    }

    return summaries.join(', ');
  }
}
