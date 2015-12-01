library tekartik_barback.transformer_memory_test;

import 'package:tekartik_barback/transformer_memory.dart';
import 'package:dev_test/test.dart';

main() {
  defineTests(new MemoryTransformerContext());
}

defineTests(MemoryTransformerContext ctx) {
  group('memory', () {
    test('read_content', () async {
      ctx.clear();
      //Asset asset = ctx.addAsset(new Asset.fromString(new AssetId(null, )))getStringContentAsset("in", "hello");
      AssetId assetId = ctx.addStringAsset("in", "hello");
      expect(await ctx.assets[assetId].readAsString(), "hello");
      expect(ctx.getStringAsset("in"), "hello");

      expect(await ctx.readAssetAsString(assetId), "hello");
    });

    test('output', () async {
      ctx.clear();
      //Asset asset = ctx.addAsset(new Asset.fromString(new AssetId(null, )))getStringContentAsset("in", "hello");
      AssetId assetId = ctx.addStringAsset("in", "hello");
      AssetId outAssetId =
          ctx.addOutputAssetFromString(new AssetId(null, "back"), "world");
      expect(await ctx.assets[assetId].readAsString(), "hello");
      expect(ctx.getStringAsset("in"), "hello");

      expect(await ctx.readAssetAsString(assetId), "hello");
      expect(await ctx.readAssetAsString(outAssetId), "world");
    });

    test('none', () async {
      ctx.clear();
      //Asset asset = ctx.addAsset(new Asset.fromString(new AssetId(null, )))getStringContentAsset("in", "hello");
      AssetId assetId = new AssetId(null, "dummy");
      expect(ctx.getStringAsset("in"), isNull);

      expect(await ctx.readAssetAsString(assetId), isNull);
    });
  });

  group('transform', () {
    test('in', () async {
      AssetId assetId = ctx.addStringAsset("in", "hello");
      Transform transform = ctx.newTransform(assetId);
      expect(await transform.readPrimaryInputAssetAsString(), "hello");
      expect(await ctx.readAssetAsString(assetId), "hello");
    });

    test('out', () async {
      AssetId assetId = new AssetId(null, "out");
      Transform transform = ctx.newTransform(null);
      transform.addOutputFromString(assetId, "hello");
      expect(await transform.readInputAsString(assetId), "hello");
    });

    test('consume', () async {
      AssetId assetId = ctx.addStringAsset("in", "hello");
      Transform transform = ctx.newTransform(assetId);
      transform.consumePrimary();
      expect(await transform.readInputAsString(assetId), isNull);
    });
  });
}
