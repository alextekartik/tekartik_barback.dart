@TestOn("vm")
library tekartik_uppercase_transformer_test;

import 'package:tekartik_pub/pub.dart';
import 'dart:async';
import 'package:dev_test/test.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:mirrors';

class _TestUtils {
  static final String scriptPath =
      (reflectClass(_TestUtils).owner as LibraryMirror).uri.toFilePath();
}

String get testScriptPath => _TestUtils.scriptPath;

Future<String> get _pubPackageRoot => getPubPackageRoot(testScriptPath);

main() {
  group('uppercase_transformer_impl', () {
    //_test.Context ctx;
    test('runBuild', () async {
      PubPackage pkg = new PubPackage(await _pubPackageRoot);
      //print(pkg);
      ProcessResult result = await pkg.pubRun(['build', 'example']);

      //stdout.writeln(result.stdout);
      //stderr.writeln(result.stderr);
      // on 1.13, current windows is failing
      if (!Platform.isWindows) {
        expect(result.exitCode, 0);
      }

      // expect to find the result in build
      String outPath = join(pkg.path, 'build', 'example');
      expect(new File(join(outPath, 'test.in')).existsSync(), isFalse);
      expect(new File(join(outPath, 'test_no.out')).existsSync(), isFalse);
      expect(new File(join(outPath, 'no_test.out')).existsSync(), isFalse);
      expect(
          new File(join(outPath, 'test_no_consume.in')).existsSync(), isTrue);
      expect(
          new File(join(outPath, 'test.out')).readAsStringSync(), 'TRANSFORM');
      expect(new File(join(outPath, 'test_no.no_in')).readAsStringSync(),
          'no_transform');
    });
  });
}
