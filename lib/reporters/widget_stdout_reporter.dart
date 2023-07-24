import 'package:gherkin/gherkin.dart';
import 'package:logger/logger.dart';

import 'monochrome_printer.dart';

class WidgetStdoutReporter extends Reporter {
  /// https://talyian.github.io/ansicolors/
  final AnsiColor neutralColor = AnsiColor.none();
  final AnsiColor debugColor = AnsiColor.fg(7); // gray
  final AnsiColor failColor = AnsiColor.fg(9);
  final AnsiColor warnColor = AnsiColor.fg(208);
  final AnsiColor passColor = AnsiColor.fg(10);
  final AnsiColor coolColor = AnsiColor.fg(45);

  final logger = Logger(printer: MonochromePrinter());

  @override
  Future<void> onScenarioStarted(StartedMessage message) async {
    logger.i(coolColor("\n${"-" * 100}\n"));
    logger.i(coolColor(
        '${DateTime.now()} - Running scenario: ${message.name + _getContext(message.context)}'));
  }

  @override
  Future<void> onScenarioFinished(ScenarioFinishedMessage message) async {
    var scenarioColor = message.passed ? passColor : failColor;
    var scenarioStatus = message.passed ? "PASSED" : "FAILED";
    logger.i("${scenarioColor(scenarioStatus)}: Scenario ${message.name}");
  }

  @override
  Future<void> onStepFinished(StepFinishedMessage message) async {
    var stepColor = message.result.result == StepExecutionResult.pass
        ? passColor
        : failColor;
    String printMessage;
    if (message.result is ErroredStepResult) {
      var errorMessage = (message.result as ErroredStepResult);
      printMessage =
          failColor('${errorMessage.exception}\n${errorMessage.stackTrace}');
    } else {
      printMessage = [
        stepColor('  '),
        stepColor(_getStatePrefixIcon(message.result.result)),
        stepColor(message.name),
        neutralColor(_getExecutionDuration(message.result)),
        stepColor(_getReasonMessage(message.result)),
        stepColor(_getErrorMessage(message.result))
      ].join((' ')).trimRight();
    }
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
    if (stepResult.resultReason != null &&
        stepResult.resultReason!.isNotEmpty) {
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
    return neutralColor(
        "\t# ${_getFeatureFilePath(context)}:${context.lineNumber}");
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
