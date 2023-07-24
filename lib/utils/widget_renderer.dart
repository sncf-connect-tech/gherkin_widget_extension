import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_widget_extension/gherkin_widget_extension.dart';

import '../test_setup.dart';

Future<void> takeScreenshot({withWidgetTreeRender = false, prefix = ''}) async {
  await currentWorld.tester.pumpAndSettle();
  RenderObject? renderObject = _getMainWidget()?.renderObject;
  if (renderObject != null) {
    RenderRepaintBoundary boundary = renderObject as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    final screenshotFile =
        _getReportFolderPath(filenamePrefix: prefix, fileExtension: 'png');
    await screenshotFile.writeAsBytes(pngBytes);
    currentWorld.reportFilesPath.add(screenshotFile.path);
    currentWorld.screenshot = screenshotFile;
    if (withWidgetTreeRender) {
      await dumpWidgetRender(prefix: prefix);
    }
  } else {
    logger.e('Screenshot failed.');
  }
}

Future<void> dumpWidgetRender({prefix = ''}) async {
  Element? widget = _getMainWidget();
  if (widget != null) {
    final widgetRendering = _printWidgetTree(_getMainWidget(), 0);
    logger.i("Widget tree render :\n $widgetRendering");
    final dumpPath =
        _getReportFolderPath(filenamePrefix: prefix, fileExtension: 'txt');
    await dumpPath.writeAsString(widgetRendering.toString());
    currentWorld.reportFilesPath.add(dumpPath.path);
    currentWorld.dumpFileContent = widgetRendering;
  } else {
    logger.e('Widget render dump failed.');
  }
}

File _getReportFolderPath(
    {required String filenamePrefix, required String fileExtension}) {
  final scenarioName = currentWorld.getScenarioAsFileName();
  return File(
      '${currentWorld.reportFolderPath}/$filenamePrefix${filenamePrefix.isNotEmpty ? '_' : ''}$scenarioName.$fileExtension');
}

Element? _getMainWidget() {
  try {
    return currentWorld.tester.allElements
        .firstWhere((element) => element.widget.runtimeType == RepaintBoundary);
  } catch (e) {
    logger.e('Cannot get a RepaintBoundary widget.');
    return null;
  }
}

int? firstLevel;

String _printWidgetTree(Element? element, int level) {
  if (element != null) {
    var content = _printWidgetContent(element.widget, level) ?? "";
    if (content.isNotEmpty) {
      firstLevel ??= level;
    }
    final children = element.debugDescribeChildren();
    if (children.isNotEmpty) {
      var childContent = "";
      for (var child in children) {
        childContent += _printWidgetTree(child.value as Element?, level + 1);
      }
      if (content.isNotEmpty) {
        return "$content\n$childContent";
      } else {
        return childContent;
      }
    } else {
      return content;
    }
  } else {
    return "";
  }
}

String? _printWidgetContent(Widget widget, int level) {
  if (_widgetPrinter.containsKey(widget.runtimeType)) {
    var widgetContent = _widgetPrinter[widget.runtimeType]!.call(widget);
    if (widgetContent.isNotEmpty) {
      return ("${"-" * (level - (firstLevel ?? level))} $widgetContent");
    } else {
      return null;
    }
  } else {
    // print ("${"-" * level}\t --> ${widget}");
    return null;
  }
}

final _widgetPrinter = {
  Text: (Widget widget) {
    final textContent = (widget as Text).data;
    return (textContent != null && textContent.isNotEmpty)
        ? 'Text : $textContent'
        : '';
  },
  TextField: (Widget widget) {
    final textContent = (widget as TextField).controller?.text;
    return (textContent != null && textContent.isNotEmpty)
        ? 'TextField : $textContent'
        : '';
  },
  Semantics: (Widget widget) {
    final textContent = (widget as Semantics).properties.label;
    return (textContent != null && textContent.isNotEmpty)
        ? 'Semantics : $textContent'
        : '';
  },
  Checkbox: (Widget widget) {
    final isTicked = (widget as Checkbox).value ?? false;
    return isTicked ? 'Checkbox checked' : 'Checkbox unchecked';
  }
};
