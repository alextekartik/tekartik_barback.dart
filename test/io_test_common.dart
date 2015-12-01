library tekartik_barback.test.io_test_common;

import 'dart:mirrors';
import 'package:path/path.dart';
import 'dart:io';
import 'package:dev_test/test.dart';
export 'package:dev_test/test.dart';

class _TestUtils {
  static final String scriptPath =
      (reflectClass(_TestUtils).owner as LibraryMirror).uri.toFilePath();
}

String get testScriptPath => _TestUtils.scriptPath;
String get dataPath => join(dirname(_TestUtils.scriptPath), "data");
String get outDataPath => getOutTestPath(testDescriptions);

String getOutTestPath([List<String> parts]) {
  if (parts == null) {
    parts = testDescriptions;
  }
  return join(dataPath, "out", joinAll(parts));
}

String clearOutTestPath([List<String> parts]) {
  String outPath = getOutTestPath(parts);
  try {
    new Directory(outPath).deleteSync(recursive: true);
  } catch (e) {}
  try {
    new Directory(outPath).createSync(recursive: true);
  } catch (e) {}
  return outPath;
}

// Get a file in the test specific folder
String outDataFilenamePath(String name) => join(outDataPath, name);
String inDataFilenamePath(String name) => join(dataPath, name);
