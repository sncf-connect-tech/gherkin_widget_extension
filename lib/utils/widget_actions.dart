import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../test_setup.dart';
import 'material_widget_app.dart';

tapAndPump(Finder finder) async {
  await currentWorld.tester.tap(finder);
  await currentWorld.tester.pumpAndSettle();
}

extension CustomFinder on CommonFinders {
  Finder widgetWithSemanticLabel(Type widgetType, String semanticLabel,
      {bool skipOffstage = true, Matcher? semanticMatcher}) {
    final parentWidget = find.ancestor(
      of: find.bySemanticsLabel(semanticLabel, skipOffstage: skipOffstage),
      matching: find.byType(widgetType, skipOffstage: skipOffstage),
    );
    if (semanticMatcher != null) {
      final semanticWidget = find.descendant(
          of: parentWidget, matching: bySemanticsLabel(semanticLabel));
      final widgetSemantics = currentWorld.tester.getSemantics(semanticWidget);
      expect(widgetSemantics, semanticMatcher);
    }
    return parentWidget;
  }
}

Future<void> pumpWidgetWithMaterial(Widget child,
    {StatelessWidget? customMaterialApp}) async {
  await currentWorld.tester.pumpWidget(MaterialTestWidget(child: child));
}

Future<void> pumpWidget(Widget child,
    {StatelessWidget? customMaterialApp}) async {
  await currentWorld.tester.pumpWidget(child);
}

Future<void> disposeWidget() async {
  // on pump un widget vide pour forcer la réinitialisation des cubits
  await currentWorld.tester.pumpWidget(const SizedBox.shrink());
}
