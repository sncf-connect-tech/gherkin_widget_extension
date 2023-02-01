import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_setup.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

Future<void> takeScreenshot({withWidgetTreeRender = false}) async {
  await currentWorld.tester.pumpAndSettle();
  RenderObject? renderObject = _getMainWidget()?.renderObject;
  if (renderObject != null) {
    RenderRepaintBoundary boundary = renderObject as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    await currentWorld.screenshot?.writeAsBytes(pngBytes);

    if (withWidgetTreeRender) {
      await dumpWidgetRender();
    }
  } else {
    logger.e('Screenshot failed.');
  }
}

Future<void> dumpWidgetRender() async {
  Element? widget = _getMainWidget();
  if (widget != null) {
    final widgetRendering = _printWidgetTree(_getMainWidget(), 0);
    logger.i("Impression widget :\n $widgetRendering");
    await currentWorld.dumpFile?.writeAsString(widgetRendering.toString());
  } else {
    logger.e('Widget render dump failed.');
  }
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
      children.forEach((child) {
        childContent += _printWidgetTree(child.value as Element?, level + 1);
      });
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
    if (textContent != null && textContent.isNotEmpty) {
      return "Text : $textContent";
    } else {
      return "";
    }
  },
  TextField: (Widget widget) {
    final textContent = (widget as TextField).controller?.text;
    if (textContent != null && textContent.isNotEmpty) {
      return "TextField : $textContent";
    } else {
      return "";
    }
  },
  Semantics: (Widget widget) {
    final textContent = (widget as Semantics).properties.label;
    if (textContent != null && textContent.isNotEmpty) {
      return "Semantics : $textContent";
    } else {
      return "";
    }
  },
  Checkbox: (Widget widget) {
    final isTicked = (widget as Checkbox).value ?? false;
    if (isTicked) {
      return "Checkbox cochée";
    } else {
      return "Checkbox décochée";
    }
  }
};
