@TestOn("vm")
library tekartik_barback.test.barback_test;

import 'package:barback/barback.dart';
import 'package:dev_test/test.dart';

// this does not run on dartium/chrome => barback requires dart:io
main() {
  group('transform', () {
    test('transform_in_browser', () {
      //clearOutFolderSync();
      Transform trfm;
      expect(trfm, isNull);
    });
  });
}
