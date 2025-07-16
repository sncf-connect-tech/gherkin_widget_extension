import 'package:gherkin/gherkin.dart';
import 'package:logger/logger.dart';

import 'monochrome_printer.dart';

class WidgetStdoutReporter implements FullReporter {
  /// https://talyian.github.io/ansicolors/
  final AnsiColor neutralColor = AnsiColor.none();
  final AnsiColor debugColor = AnsiColor.fg(7); // gray
  final AnsiColor failColor = AnsiColor.fg(9);
  final AnsiColor warnColor = AnsiColor.fg(208);
  final AnsiColor passColor = AnsiColor.fg(10);
  final AnsiColor coolColor = AnsiColor.fg(45);

  final logger = Logger(printer: MonochromePrinter());

  @override
  Future<void> dispose() async {}

  @override
  ReportActionHandler<FeatureMessage> get feature => ReportActionHandler();

  @override
  Future<void> message(String message, MessageLevel level) async {}

  @override
  Future<void> onException(Object exception, StackTrace stackTrace) async {}

  @override
  ReportActionHandler<ScenarioMessage> get scenario => ReportActionHandler(
        onStarted: ([message]) async {
          logger.i(coolColor("\n${"-" * 100}\n"));
          if (message == null) {
            logger.i(failColor('Cannot get scenario information'));
          } else {
            logger.i(coolColor(
                '${DateTime.now()} - Running scenario: ${message.name + _getContext(message.context)}'));
          }
        },
        onFinished: ([message]) async {
          if (message == null) {
            logger.i(failColor('Cannot get scenario information'));
          } else {
            var scenarioColor = message.hasPassed ? passColor : failColor;
            var scenarioStatus = message.hasPassed ? "PASSED" : "FAILED";
            logger.i(
                "${scenarioColor(scenarioStatus)}: Scenario ${message.name}");
          }
        },
      );

  @override
  ReportActionHandler<StepMessage> get step => ReportActionHandler(
        onFinished: ([message]) async {
          if (message == null) {
            logger.i(failColor('Cannot get scenario information'));
          } else {
            if (message.result == null) {
              logger.i(failColor('Cannot get result scenario information'));
            } else {
              var stepColor =
                  message.result!.result == StepExecutionResult.passed
                      ? passColor
                      : failColor;
              String printMessage;
              if (message.result is ErroredStepResult) {
                var errorMessage = (message.result as ErroredStepResult);
                printMessage = failColor(
                    '${errorMessage.exception}\n${errorMessage.stackTrace}');
              } else {
                printMessage = [
                  stepColor('  '),
                  stepColor(_getStatePrefixIcon(message.result!.result)),
                  stepColor(message.name),
                  neutralColor(_getExecutionDuration(message.result!)),
                  stepColor(_getReasonMessage(message.result!)),
                  stepColor(_getErrorMessage(message.result!))
                ].join((' ')).trimRight();
              }
              logger.i(printMessage);
            }
          }
        },
      );

  @override
  ReportActionHandler<TestMessage> get test => ReportActionHandler();

  String _getReasonMessage(StepResult stepResult) =>
      (stepResult.resultReason != null && stepResult.resultReason!.isNotEmpty)
          ? '\n      ${stepResult.resultReason}'
          : '';

  String _getErrorMessage(StepResult stepResult) =>
      stepResult is ErroredStepResult
          ? '\n${stepResult.exception}\n${stepResult.stackTrace}'
          : '';

  String _getContext(RunnableDebugInformation? context) => neutralColor(
      "\t# ${_getFeatureFilePath(context)}:${context?.lineNumber}");

  String _getFeatureFilePath(RunnableDebugInformation? context) =>
      context?.filePath.replaceAll(RegExp(r'\.\\'), '') ?? '';

  String _getExecutionDuration(StepResult stepResult) =>
      ' (${stepResult.elapsedMilliseconds}ms)';

  String _getStatePrefixIcon(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.passed:
        return '√';
      case StepExecutionResult.error:
      case StepExecutionResult.fail:
      case StepExecutionResult.timeout:
        return '×';
      case StepExecutionResult.skipped:
        return '-';
    }
  }
}
