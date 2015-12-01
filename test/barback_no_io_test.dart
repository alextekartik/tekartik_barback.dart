library tekartik_barback.test.barback_no_io_test;

// AssetId safe
import 'package:barback/src/asset/asset_id.dart';
// BarbackSettings safe
import 'package:barback/src/transformer/barback_settings.dart';
import 'package:source_span/source_span.dart';
import 'package:dev_test/test.dart';
// Asset not safe
// Logger not safe
//import 'package:barback/src/transformer/transform_logger.dart' as brbck;
//import 'package:barback/src/log.dart' as brbck;

// this does not run on dartium/chrome => barback requires dart:io
main() {
  group('import', () {
    test('AssetId', () {
      AssetId id = new AssetId('', '');
      expect(id, isNotNull);
    });

    test('BarbackSettings', () {
      BarbackSettings settings = new BarbackSettings(null, BarbackMode.DEBUG);
      expect(settings.mode, BarbackMode.DEBUG);
    });

    test('SourceSpan', () {
      SourceSpan span;
      expect(span, isNull);
    });
  });
}
