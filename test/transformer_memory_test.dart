library tekartik_transformer_test;

import 'package:tekartik_transformer/transformer_memory.dart';
import 'package:dev_test/test.dart';
//import 'io_test_common.dart';

/*
class Context {
  String packageName = "tekartik_transformer";
  String pubPackageRoot;
  TransformerContext context;

  static Future<Context> setUp() async {
    Context test = new Context();
    test.pubPackageRoot = await await getPubPackageRoot(testScriptPath);
    test.context = new MemoryTransformerContext(test.pubPackageRoot);
    return test;
  }

  Asset getStringContentAsset(String path, String content) {
    AssetId assetId = new AssetId(packageName, path);
    Asset asset = new Asset.fromString(assetId, content);
    return asset;
  }

// find the exported asset
  Asset getPackageAsset(String package, String path) {
    AssetId assetId = new AssetId(package, path);
    Asset asset = new Asset.fromPath(
        assetId, join(pubPackageRoot, "packages", package, path));
    return asset;
  }
}
*/

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
/*
    test('read_external_content', () {
      Asset asset = ctx.getPackageAsset("dev_test", "test.dart");
      Transform transform = new Transform(ctx.context, asset);
      return transform.readInputAsString(asset.id).then((String content) {
        //expect(content, 'voilà');
        //print(content);
        expect(content, isNotEmpty);
      });
    });

    test('read another package', () {
      AssetId toReadAssetId = new AssetId(packageName, 'test/data/simple_content.txt');

      AssetId assetId = new AssetId("dummy", 'test/data/simple_content.txt');
      Asset asset = new Asset.fromPath(assetId, assetId.path);
      Transform transform = new Transform(context, asset);
      return transform.readInputAsString(toReadAssetId).then((String content) {
        expect(content, 'voilà');
      });
    });
    */
}
