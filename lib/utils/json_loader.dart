import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';

class JsonLoader {
  static Future loadJson(
    Iterable<String> globs,
  ) async {
    final cache = <String, String>{};
    for (final pattern in globs) {
      final jsonPath = '${Directory.current.path}/$pattern';
      await for (final path in Glob(jsonPath).list()) {
        if (path is File) {
          final file = await (path as File).readAsString();
          cache[pattern] = file;
        }
      }
    }
    final manifest = <String, List<String>>{};
    cache.forEach((key, _) {
      manifest[key] = [key];
    });

    return cache;
  }
}
