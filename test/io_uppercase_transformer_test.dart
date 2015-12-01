@TestOn("vm")
library tekartik_uppercase_transformer_test;

import 'package:tekartik_pub/pub.dart';
import 'dart:async';
import 'io_test_common.dart';
import 'dart:io';
import 'package:path/path.dart';

String packageName = 'tekartik_common';

Future<String> get _pubPackageRoot => getPubPackageRoot(join(
    dirname(dirname(testScriptPath)),
    'example',
    'transformer',
    'in_uppercase_transformer'));

main() {
  group('uppercase_transformer_impl', () {
    //_test.Context ctx;
    test('runTest', () async {
      PubPackage pkg = new PubPackage(await _pubPackageRoot);
      //print(pkg);
      await pkg.pubRun(['get', '--offline']);
      ProcessResult result = await pkg.pubRun(pkg.runTestCmdArgs(
          //ProcessResult result = await run(dartExecutable, pubArguments(pkg.runTestCmdArgs(
          [],
          platforms: ["vm"],
          reporter: TestReporter.EXPANDED,
          concurrency:
              1)); //, workingDirectory: pkg.path, connectStdout: true);

      // on 1.13, current windows is failing
      if (!Platform.isWindows) {
        expect(result.exitCode, 0);
      }
    });
  });
}
