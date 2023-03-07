
import 'dart:async';

import 'package:gherkin_widget_extension/utils/font_loader.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
      await loadAppFonts();
      await testMain();
}
