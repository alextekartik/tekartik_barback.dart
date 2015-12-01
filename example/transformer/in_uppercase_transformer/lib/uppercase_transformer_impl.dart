library tekartik_uppercase_transformer;

import 'package:tekartik_transformer/transformer.dart';
import 'dart:async';
import 'package:path/path.dart';

class UppercaseTransformer extends Object
    with TransformerMixin
    implements Transformer {
  BarbackSettings settings;

  @override
  String get allowedExtensions => ".txt .in";

  // ctor
  UppercaseTransformer.asPlugin([this.settings]);

  @override
  Future apply(Transform transform) async {
    String content = await transform.readPrimaryInputAssetAsString();
    transform.logger.info("in ${transform.primaryInputId}");
    transform.logger.info("in $content");
    // The extension of the output is changed to ".html".
    var id = transform.primaryInputId.changeExtension(".out");

    String newContent = content.toUpperCase();

    if (!posix
        .basenameWithoutExtension(transform.primaryInputId.path)
        .contains('_no_consume')) {
      transform.consumePrimary();
    }

    transform.addOutputFromString(id, newContent);

    transform.logger.fine("out ${id}");
    transform.logger.fine("out ${newContent}");
  }

  @override
  isPrimary(AssetId id) {
    // Allow all files if [primaryExtensions] is not overridden.
    bool isPrimary = false;
    for (var extension in allowedExtensions.split(" ")) {
      if (id.path.endsWith(extension)) {
        isPrimary = true;
        break;
      }
    }

    if (isPrimary) {
      if (posix.basename(id.path).startsWith('no_')) {
        return false;
      }

      // ok
      return true;
    }

    return false;
  }
}
