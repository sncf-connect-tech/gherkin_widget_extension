import 'dart:convert';

import 'package:logger/logger.dart';

class MonochromePrinter extends LogPrinter {
  MonochromePrinter();

  @override
  List<String> log(LogEvent event) {
    var messageStr = _stringifyMessage(event.message);
    return [messageStr];
  }

  String _stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = const JsonEncoder.withIndent(null);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }
}
