@TestOn("vm")
library tekartik_barback.transformer_test;

import 'package:tekartik_barback/transformer_memory.dart';
import 'io_test_common.dart';

main() {
  defineTests(new MemoryTransformerContext());
}

defineTests(MemoryTransformerContext ctx) {
  group('context_common', () {
    test('dummy', () async {
      AssetId assetId = new AssetId(null, 'dummy');
      expect(await ctx.readAssetAsString(assetId), isNull);
    });
    test('write', () async {
      AssetId assetId = new AssetId(null, 'in');
      expect(assetId, await ctx.addOutputAssetFromString(assetId, "hello"));
      expect(await ctx.readAssetAsString(assetId), "hello");
    });

    test('write_two', () async {
      AssetId assetId1 = new AssetId(null, 'in1');
      AssetId assetId2 = new AssetId(null, 'in2');
      expect(assetId1, await ctx.addOutputAssetFromString(assetId1, "hello"));
      expect(assetId2, await ctx.addOutputAssetFromString(assetId2, "world"));
      expect(await ctx.readAssetAsString(assetId1), "hello");
      expect(await ctx.readAssetAsString(assetId2), "world");
    });
  });
}
