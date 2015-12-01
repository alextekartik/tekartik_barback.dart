@TestOn("vm")
library tekartik_uppercase_transformer_test;

import 'package:tekartik_barback/transformer_memory.dart';
import 'package:tekartik_in_uppercase_transformer/uppercase_transformer_impl.dart';
//import 'package:barback/barback.dart' show Asset, AssetSet, AssetId;
import 'package:dev_test/test.dart';
//import 'package:tekartik_common/project_utils.dart';
//import 'transformer_test.dart' as _test;
import 'dart:async';

String packageName = 'tekartik_common';

main() {
  defineTests(new MemoryTransformerContext());
}

defineTests(MemoryTransformerContext ctx) {
  group('uppercase_transformer_impl', () {
    //_test.Context ctx;

    UppercaseTransformer transformer;

    setUp(() async {
      //ctx = await _test.Context.setUp();
      transformer = new UppercaseTransformer.asPlugin();
    });

    Future checkSingleContent(Transform transform,
        {String path, String content}) async {
      expect(ctx.outputs.length, 1);
      MemoryAsset output = ctx.outputs.first;
      if (path != null) {
        expect(output.id.path, path);
      }
      if (content != null) {
        String readContent = await transform.readInputAsString(output.id);
        expect(readContent, content);
      }
    }
    test('read', () async {
      AssetId assetId = ctx.addStringAsset("some_path.txt", "some text");
      Transform transform = ctx.newTransform(assetId);
      expect(transformer.isPrimary(assetId), isTrue);
      await transformer.apply(transform);
      await checkSingleContent(transform,
          path: "some_path.out", content: "SOME TEXT");
      print(transform.logger.logs);
    });

    /*
    solo_test('build', () {
      return transformerBuildDir(transformer, join(dataPath, 'sub')).then((TransformerContext context) {
        expect(context.outputs.length, 1);

        return transformerBuildDir(transformer, dataPath).then((TransformerContext context) {
          expect(context.outputs.length, 2);
        });
      });

    });
    */
  });
}
