import 'package:gherkin/gherkin.dart';
import 'package:logger/logger.dart';

import 'monochrome_printer.dart';

class CustomStdoutReporter extends Reporter {
  /// https://talyian.github.io/ansicolors/
  final AnsiColor NEUTRAL_COLOR = AnsiColor.none();
  final AnsiColor DEBUG_COLOR = AnsiColor.fg(7); // gray
  final AnsiColor FAIL_COLOR = AnsiColor.fg(9);
  final AnsiColor WARN_COLOR = AnsiColor.fg(208);
  final AnsiColor PASS_COLOR = AnsiColor.fg(10);
  final AnsiColor COOL_COLOR = AnsiColor.fg(45);

  final logger = Logger(printer: MonochromePrinter());

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    logger.i(COOL_COLOR("\n${"-" * 100}\n"));
    logger.i(COOL_COLOR('${DateTime.now()} - Running scenario: ${message.name + _getContext(message.context)}'));
  }

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {
    var scenarioColor = message.passed ? PASS_COLOR : FAIL_COLOR;
    var scenarioStatus = message.passed ? "PASSED" : "FAILED";
    logger.i("${scenarioColor(scenarioStatus)}: Scenario ${message.name}");
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    var stepColor = message.result.result == StepExecutionResult.pass ? PASS_COLOR : FAIL_COLOR;
    var printMessage = [
      stepColor('  '),
      stepColor(_getStatePrefixIcon(message.result.result)),
      stepColor(message.name),
      NEUTRAL_COLOR(_getExecutionDuration(message.result)),
      stepColor(_getReasonMessage(message.result)),
      stepColor(_getErrorMessage(message.result))
    ].join((' ')).trimRight();
    logger.i(printMessage);

    // TODO adapter à cette classe
    // if (message.attachments.isNotEmpty) {
    //   message.attachments.forEach(
    //     (attachment) {
    //       var attachment2 = attachment;
    //       printMessageLine(
    //         [
    //           '    ',
    //           'Attachment',
    //           "(${attachment2.mimeType})${attachment.mimeType == 'text/plain' ? ': ${attachment.data}' : ''}"
    //         ].join((' ')).trimRight(),
    //         StdoutReporter.RESET_COLOR,
    //       );
    //     },
    //   );
    // }
  }

  String _getReasonMessage(StepResult stepResult) {
    if (stepResult.resultReason != null && stepResult.resultReason!.isNotEmpty) {
      return '\n      ${stepResult.resultReason}';
    } else {
      return '';
    }
  }

  String _getErrorMessage(StepResult stepResult) {
    if (stepResult is ErroredStepResult) {
      return '\n${stepResult.exception}\n${stepResult.stackTrace}';
    } else {
      return '';
    }
  }

  String _getContext(RunnableDebugInformation context) {
    return NEUTRAL_COLOR("\t# ${_getFeatureFilePath(context)}:${context.lineNumber}");
  }

  String _getFeatureFilePath(RunnableDebugInformation context) {
    return context.filePath.replaceAll(RegExp(r"\.\\"), "");
  }

  String _getExecutionDuration(StepResult stepResult) {
    return ' (${stepResult.elapsedMilliseconds}ms)';
  }

  String _getStatePrefixIcon(StepExecutionResult result) {
    switch (result) {
      case StepExecutionResult.pass:
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
